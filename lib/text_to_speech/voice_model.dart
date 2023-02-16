class VoiceModel {
  String? name;
  String? locale;

  VoiceModel({this.name, this.locale});

  VoiceModel.fromJson(json) {
    name = json["name"];
    locale = json['locale'];
  }

  Map<String, String> toJson() {
    return {
      "name" : name ?? "",
      "locale": locale ?? ""
    };
  }
}
