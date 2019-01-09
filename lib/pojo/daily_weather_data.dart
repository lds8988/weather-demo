
import 'package:json_annotation/json_annotation.dart';

part 'daily_weather_data.g.dart';

@JsonSerializable()
class DailyWeatherData {
  String date;

  @JsonKey(name: "sr")
  String sunrise;

  @JsonKey(name: "ss")
  String sunset;

  @JsonKey(name: "tmp_max")
  String tmpMax;

  @JsonKey(name: "tmp_min")
  String tmpMin;

  @JsonKey(name: "cond_txt_d")
  String cond;

  @JsonKey(name: "cond_code_d")
  String condCode;

  DailyWeatherData(this.date, this.sunrise, this.sunset, this.tmpMax, this.tmpMin, this.cond, this.condCode);

  factory DailyWeatherData.fromJson(Map<String, dynamic> json) => _$DailyWeatherDataFromJson(json);

  Map<String, dynamic> toJson() => _$DailyWeatherDataToJson(this);
}