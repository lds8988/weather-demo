import 'package:json_annotation/json_annotation.dart';
import 'package:weather_demo/pojo/daily_weather_data.dart';
import 'package:weather_demo/pojo/lifestyle.dart';
import 'package:weather_demo/pojo/now_weather_data.dart';

part 'weather_data.g.dart';

@JsonSerializable()
class WeatherData {
  @JsonKey(name: "daily_forecast")
  List<DailyWeatherData> dailyForecasts;

  NowWeatherData now;

  @JsonKey(name: "lifestyle")
  List<Lifestyle> lifestyles;

  WeatherData(this.dailyForecasts, this.now, this.lifestyles);

  factory WeatherData.fromJson(Map<String, dynamic> json) =>
      _$WeatherDataFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherDataToJson(this);

  factory WeatherData.empty() {
    return WeatherData(
        List<DailyWeatherData>(),
        NowWeatherData.empty(),
        List<Lifestyle>());
  }
}
