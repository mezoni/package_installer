#Package Intstaller
==========

Version: 0.0.1

The package installer intended for the following purpose.

The automatic execution of the process of installation of packages that required for their proper operation before they begin to be used. These processes of installation may include the following tasks: compilation of the binary files, installing the third party software and so on.

The installation procedure of package does not replace the installation that performed by package manager. Installation procedures are performed after the actual installation packages into your system by package manager.

This package is designed to perform such installation procedures.

To begin using this functionality you must read the short instruction about how these functions implemented.

Instruction for an application that uses a packages that requires the  procedure of self installation.
Instruction for organizing correct work of the self installable packages you may read below this instruction.

1. Create an application package or continue use existing application.
2. Add the dependency in your "pubspec.yaml" to this package (package_installer);
3. Create a script that will be responsible for the installation of your application and place this script in "bin" directory.
4. Name this script a meaningful name, such as "install_me.dart".
5. Formalize this script as described below.

In compliance with this instruction the script will be be able to execute of installations automatically.

install_me.dart

```dart
import 'package:package_installer/package_installer.dart';

void main() {
  var installer = new PackageInstaller();
  installer.logger.onRecord.listen((message) => print(message));
  installer.install();
}
```

This script is respond for automatic execution of the installation scripts of dependent packages before they begin to be used.
This script also can execute procedure of the self installation of your application.

This means that your application also can acts as package that requires self installation.

If you want that your application or package support procedure of the self installation follow the following instruction.

1. Create in your package in the "bin" directory a script called "_install.dart".

That's all. This script will be executed automatically when "package installer" in some application will be executed.

Because  the packages in Dart are shared between of all applications to prevent performing installation multiple time you must provide special procedure in your installation script.

This procedure can be responsible to detection of that fact the your package already installed. This may include checking that some file exists (created during installation) that was not present before first installation.

Example of installation script.

bin/_install.dart

```dart
import 'dart:io';
import 'package:path/path.dart' as pathos;

void main(List<String> args) {
  print("packageRoot: ${Platform.packageRoot}");
}

class Program {
  Map _options;

  void run(List<String> args) {
    _install();
  }

  void _install() {
    var file = new File(_getConfigFileName());
    if(!file.existsSync()) {
      _realInstall();
    } else {
      // Already installed
    }
  }

  void _realInstall() {
    var file = new File(_getConfigFileName());
    file.writeAsStringSync('');
    // Perfom installation.
    // Download and install third pary software
    // Compile binary files
  }

  String _getConfigFileName() {
    var script = Platform.script.path;
    var path = pathos.dirname(script);
    return pathos.join(path, "config.ini");
  }
}
```