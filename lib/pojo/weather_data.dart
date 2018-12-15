import 'package:json_annotation/json_annotation.dart';

part 'weather_data.g.dart';

@JsonSerializable()
class WeatherData {
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

  WeatherData(
      {this.fl,
      this.tmp,
      this.condCode,
      this.cond,
      this.windDir,
      this.windSc,
      this.hum,
      this.pres});

  factory WeatherData.fromJson(Map<String, dynamic> json) =>
      _$WeatherDataFromJson(json);

  factory WeatherData.empty() {
    return WeatherData(
        fl: "",
        tmp: "",
        condCode: "",
        cond: "",
        windDir: "",
        windSc: "",
        hum: "",
        pres: "");
  }

  Map<String, dynamic> toJson() => _$WeatherDataToJson(this);

  @override
  String toString() {
    return 'WeatherData{fl: $fl, tmp: $tmp, condCode: $condCode, cond: $cond, windDir: $windDir, windSc: $windSc, hum: $hum, pres: $pres}';
  }


}
