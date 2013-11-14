import 'dart:io';
import 'package:package_installer/package_installer.dart';

void main() {
  var installer = new PackageInstaller();
  installer.logger.onRecord.listen((message) => print(message));
  if(!installer.install()) {
    exit(1);
  }
}
