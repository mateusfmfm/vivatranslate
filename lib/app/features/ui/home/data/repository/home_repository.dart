// ignore_for_file: invalid_return_type_for_catch_error

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:googleapis/speech/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:vivatranslate_mateus/app/core/helpers/file_audio_util.dart';

class HomeRepository {
  Future<String> transcribeAudio(String audioPath) async {
    final fileAudioUtil = FileAudioUtil(path: audioPath, base64: "");
    String _audioTranscription = "";
    final credentials = ServiceAccountCredentials.fromJson(await rootBundle
        .loadString('keys/challenges-374904-4e20da4930a2.json'));
    const scopes = [SpeechApi.cloudPlatformScope];

    final httpClient = await clientViaServiceAccount(credentials, scopes);
    var speech = SpeechApi(httpClient);
    try {
      final bytesData = await fileAudioUtil.readFileByte(audioPath);

      String audioString = base64Encode(bytesData);
      RecognizeRequest r = RecognizeRequest();
      RecognitionAudio audio =
          RecognitionAudio.fromJson({'content': audioString});
      r.audio = audio;
      RecognitionConfig config = RecognitionConfig.fromJson({
        "encoding": "FLAC",
        "sampleRateHertz": 16000,
        "languageCode": "en-US",
      });
      r.config = config;
      await speech.speech.recognize(r).then((results) {
        for (var result in results.results!) {
          _audioTranscription = result.alternatives![0].transcript!;
        }
      }).catchError((error) => log('$error'));
      return _audioTranscription;
    } catch (e) {
      print(e);
      return "";
    }
  }
}
