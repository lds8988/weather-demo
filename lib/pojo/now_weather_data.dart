import 'package:json_annotation/json_annotation.dart';

part 'now_weather_data.g.dart';

@JsonSerializable()
class NowWeatherData {
  String fl;

  String tmp;

  @JsonKey(name: "cond_code")
  String condCode;

  @JsonKey(name: "cond_txt")
  String cond;

  @JsonKey(name: "wind_dir")
  String windDir;

  @JsonKey(name: "wind_sc")
  String windSc;

  String hum;

  String pres;

  NowWeatherData({this.fl, this.tmp, this.condCode, this.cond, this.windDir,
    this.windSc, this.hum, this.pres});

  factory NowWeatherData.fromJson(Map<String, dynamic> json) => _$NowWeatherDataFromJson(json);

  Map<String, dynamic> toJson() => _$NowWeatherDataToJson(this);

  factory NowWeatherData.empty() {
    return NowWeatherData(
        fl: "",
        tmp: "",
        condCode: "",
        cond: "",
        windDir: "",
        windSc: "",
        hum: "",
        pres: "");
  }

}