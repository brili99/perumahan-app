import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';

class DeviceInfo {
  static final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  late String deviceId;

  Future getDeviceInfo() async {
    try {
      print("Device Info running");
      if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor!;
      } else if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.androidId!;
      }
    } on PlatformException {
      deviceId = "NonAndroidIos";
    }
    return deviceId;
  }
}
