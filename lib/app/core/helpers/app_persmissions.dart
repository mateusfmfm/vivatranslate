import 'dart:developer';

import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart'
    as p;

class AppPermissions {
  getPermissions() async {
    try {
      await p.Permission.storage.request();
      await p.Permission.mediaLibrary.request();
      await p.Permission.accessMediaLocation.request();
      await p.Permission.audio.request();
      await p.Permission.microphone.request();
      await p.Permission.manageExternalStorage.request();
    } catch (e) {
      log("$e");
    }
  }
}
