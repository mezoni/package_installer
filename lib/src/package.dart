part of package_installer.package_installer;

class _Package {
  String name;

  List<_Package> packages;

  String path;

  _Pubspec pubspec;

  _Package({this.pubspec}) {
    packages = new List<_Package>();
    name = pubspec.name;
    path = pathos.dirname(pubspec.path);
  }

  static _Package readPackage(String packagePath) {
    var pubspec = _Pubspec.readPackagePubspec(packagePath);
    return new _Package(pubspec: pubspec);
  }

  String toString() {
    return name;
  }
}
