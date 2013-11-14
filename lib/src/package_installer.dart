part of package_installer.package_installer;

class PackageInstaller {
  Logger logger;

  _Package _rootPackage;

  PackageInstaller({this.logger}) {
    if(logger == null) {
      logger = new Logger("PackageInstaller");
    }
  }

  bool install() {
    var result = _process('install');
    if(result) {
      logger.info("Installation successfully completed");
    } else {
      logger.info("Installation failed");
    }

    return result;
  }

  Map<String, _Package> _getApplicationPackages() {
    var packages = new Map<String, _Package>();
    var packagesPath = pathos.join(_ApplicationPath.path, "packages");
    var packagesDirectory = new Directory(packagesPath);
    for(var entry in packagesDirectory.listSync(followLinks: false, recursive: false)) {
      if(entry is Link) {
        var link = entry as Link;
        var target = link.resolveSymbolicLinksSync();
        var packagePath = pathos.dirname(target);
        var package = _Package.readPackage(packagePath);
        packages[package.name] = package;
      }
    }

    return packages;
  }

  String _getPackageInstallScript(_Package package, String operation) {
    var pubspec = package.pubspec;
    String script;
    switch(operation) {
      case 'install':
        script = pubspec.install;
        break;
    }

    if(script == null) {
      return null;
    }

    script = pathos.join(package.path, script);
    return script;
  }

  bool _process(String operation) {
    if(_ApplicationPath.path == null) {
      logger.severe("Cannot determine application path");
      return false;
    }

    var packageRoot = pathos.join(_ApplicationPath.path, 'packages');
    var rootPubspec = _Pubspec.readPackagePubspec(_ApplicationPath.path);
    var packages = _getApplicationPackages();
    _rootPackage = packages[rootPubspec.name];
    if(_rootPackage == null) {
      logger.severe("Package '${rootPubspec.name}' has no link in root 'packages' directory.");
      return false;
    }

    var dependencies = _Resolver.resolve(_rootPackage, packages);
    for(var dependency in dependencies) {
      var scriptPath = _getPackageInstallScript(dependency, operation);
      if(scriptPath != null) {
        logger.info("Installing package '$dependency'");
        var installed = false;
        ProcessResult result;
        var arguments = new List<String>();
        arguments.add("--package-root=$packageRoot");
        arguments.add(scriptPath);
        var executable = Platform.executable;
        if(new File(scriptPath).existsSync()) {
          try {
            result = Process.runSync(executable, arguments);
          } catch(exception, stackTrace) {
            logger.severe("Error has occurred during the execution of '$scriptPath'", exception, stackTrace);
          }

          if(result != null) {
            if(result.stdout != null) {
              stdout.write(result.stdout);
            }

            if(result.stderr != null) {
              stderr.write(result.stderr);
            }

            if(result.exitCode == 0) {
              installed = true;
            }
          }
        } else {
          logger.severe("The $operation script not found: $scriptPath.");
        }

        if(!installed) {
          logger.severe("Package '$dependency' not ${operation}ed");
          return false;
        }
      }
    }

    return true;
  }
}
