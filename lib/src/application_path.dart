part of package_installer.package_installer;

class _ApplicationPath {
  static final String  path = _determine();

  static String _determine() {
    var script = Platform.script;
    if(script == null) {
      return null;
    }

    var curPath = pathos.dirname(script.path);
    while(true) {
      var packagesPath = pathos.join(curPath, 'packages');
      var directory = new Directory(packagesPath);
      if(!directory.existsSync()) {
        curPath = null;
        break;
      }

      var pubspecPath = pathos.join(curPath, 'pubspec.yaml');
      if(new File(pubspecPath).existsSync()) {
        break;
      }

      var prevPath = curPath;
      curPath = pathos.dirname(curPath);
      if(curPath == prevPath) {
        curPath = null;
        break;
      }
    }

    return curPath;
  }
}
