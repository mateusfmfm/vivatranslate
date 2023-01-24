import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:googleapis/speech/v1.dart';
import 'package:googleapis_auth/auth_browser.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:vivatranslate_mateus/app/core/helpers/file_audio_util.dart';
import 'package:vivatranslate_mateus/app/features/ui/home/data/models/speech_to_text_request_model.dart';

class HomeRepository {
  transcribeAudio(String audioPath) async {
    final fileAudioUtil = FileAudioUtil(path: audioPath);
    String _audioTranscription = "";
    final credentials = ServiceAccountCredentials.fromJson(await rootBundle
        .loadString('keys/challenges-374904-4e20da4930a2.json'));
    const scopes = [SpeechApi.cloudPlatformScope];

    await clientViaServiceAccount(credentials, scopes).then((httpClient) {
      var speech = SpeechApi(httpClient);
      try {
        fileAudioUtil.readFileByte(audioPath).then((bytesData) async {
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
          }).catchError((error) => print('$error'));
        });
        return _audioTranscription;
      } catch (e) {
        print(e);
      }
    });
  }
}
