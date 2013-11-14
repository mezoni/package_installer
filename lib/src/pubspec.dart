part of package_installer.package_installer;

class _Pubspec {
  List<String> dependencies;

  String install;

  Map map;

  String name;

  String path;

  String specification;

  _Pubspec({this.path, this.specification}) {
    map = new Map.from(yaml.loadYaml(specification));
    name = _get("name");
    this.dependencies = new List<String>();
    var dependencies = _get("dependencies");
    if(dependencies != null) {
      for(var name in dependencies.keys) {
        this.dependencies.add(name);
      }
    }
  }

  static _Pubspec readPackagePubspec(String packagePath) {
    var pubspecPath = pathos.join(packagePath, "pubspec.yaml");
    return readPubspec(pubspecPath);
  }

  static _Pubspec readPubspec(String path) {
    var file = new File(path);
    if(!file.existsSync()) {
      return null;
    }

    var specification = file.readAsStringSync();
    var pubspec = new _Pubspec( path: path, specification: specification);
    _dummyModifyPubspec(pubspec);
    return pubspec;
  }

  static void _dummyModifyPubspec(_Pubspec pubspec) {
    var packagePath = pathos.dirname(pubspec.path);
    /*
     * Section 'install' must be defined in 'pubspec.yaml'
     * Example of 'pubspec.yaml':
     *
     * name: package_name
     * install: bin/_install.dart
     *
     * Because it missing we emulate this feature.
     * The path is always 'bin/_install.dart'
     */
    var relativePath = 'bin/_install.dart';
    var script = pathos.join(packagePath, relativePath);
    if(new File(script).existsSync()) {
      pubspec.install = relativePath;
    }
  }

  Object _get(String key, [Object defaultValue]) {
    if(map.keys.contains(key)) {
      return map[key];
    }

    return defaultValue;
  }
}
