class SpeechToTextResponse {
  List<Results>? results;

  SpeechToTextResponse({this.results});

  SpeechToTextResponse.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  List<Alternatives>? alternatives;

  Results({this.alternatives});

  Results.fromJson(Map<String, dynamic> json) {
    if (json['alternatives'] != null) {
      alternatives = <Alternatives>[];
      json['alternatives'].forEach((v) {
        alternatives!.add(Alternatives.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (alternatives != null) {
      data['alternatives'] = alternatives!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Alternatives {
  double? confidence;
  String? transcript;

  Alternatives({this.confidence, this.transcript});

  Alternatives.fromJson(Map<String, dynamic> json) {
    confidence = json['confidence'];
    transcript = json['transcript'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['confidence'] = confidence;
    data['transcript'] = transcript;
    return data;
  }
}