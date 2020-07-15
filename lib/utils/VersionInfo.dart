import 'package:flutter/services.dart';

import 'package:package_info/package_info.dart';

class Version {
  static var appName;
  static var packageName;
  static var version;
  static var buildNumber;

  Future<bool> initPlatformState() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    try {
      appName = packageInfo.appName;
      packageName = packageInfo.packageName;
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
    } on PlatformException {
      print("No package info");
    }
    return true;
  }
}
