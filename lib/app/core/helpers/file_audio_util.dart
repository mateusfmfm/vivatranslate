import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class FileAudioUtil {
  final String? base64;
  final String? path;

  FileAudioUtil({this.base64, this.path});

  Future<Uint8List> readFileByte(String filePath) async {
    File audioFile = File(filePath);
    Uint8List bytes;
    var result = await audioFile.readAsBytes();
    bytes = Uint8List.fromList(result);
    return bytes;
  }

  getFileFromBase64() async {
    try {
      Uint8List bytes = base64Decode(base64!);
      final tempDir = await getTemporaryDirectory();
      File file = await File(
              "${tempDir.path.replaceAll("\\", "/")}/${DateTime.now().millisecondsSinceEpoch}.flac")
          .writeAsBytes(bytes);

      return file;
    } catch (e) {
      log("$e");
    }
  }

  deleteFile() async => await File(path!).delete();
}
