part of package_installer.package_installer;

class _Resolver {
  static List<_Package> resolve(_Package rootPackage, Map<String, _Package> packages) {
    if(rootPackage == null) {
      throw new ArgumentError("rootPackage: $rootPackage");
    }

    if(packages == null) {
      throw new ArgumentError("packages: $packages");
    }

    for(var package in packages.values) {
      for(var name in package.pubspec.dependencies) {
        var dependency = packages[name];
        if(dependency == null) {
          throw new StateError("Cannot resolve package '$name'");
        } else {
          package.packages.add(dependency);
        }
      }
    }

    var resolved = new List<_Package>();
    _resolve(rootPackage, resolved, new Set<_Package>());
    return resolved;
  }


  static _resolve(_Package package, List<_Package> resolved, Set<_Package> unresolved) {
    unresolved.add(package);
    for(var dependency in package.packages) {
      if(!resolved.contains(dependency)) {
        if(unresolved.contains(dependency)) {
          throw new StateError("Circular reference detected: $package, $dependency");
        }

        _resolve(dependency, resolved, unresolved);
      }
    }

    resolved.add(package);
    unresolved.add(package);
  }
}
