class SpeechToTextRequest {
  Config? config;
  Audio? audio;

  SpeechToTextRequest({this.config, this.audio});

  SpeechToTextRequest.fromJson(Map<String, dynamic> json) {
    config =
        json['config'] != null ? Config.fromJson(json['config']) : null;
    audio = json['audio'] != null ? Audio.fromJson(json['audio']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (config != null) {
      data['config'] = config!.toJson();
    }
    if (audio != null) {
      data['audio'] = audio!.toJson();
    }
    return data;
  }
}

class Config {
  String? encoding;
  int? sampleRateHertz;
  String? languageCode;

  Config({this.encoding, this.sampleRateHertz, this.languageCode});

  Config.fromJson(Map<String, dynamic> json) {
    encoding = json['encoding'];
    sampleRateHertz = json['sampleRateHertz'];
    languageCode = json['languageCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['encoding'] = encoding;
    data['sampleRateHertz'] = sampleRateHertz;
    data['languageCode'] = languageCode;
    return data;
  }
}

class Audio {
  String? content;

  Audio({this.content});

  Audio.fromJson(Map<String, dynamic> json) {
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['content'] = content;
    return data;
  }
}