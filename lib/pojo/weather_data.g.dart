// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherData _$WeatherDataFromJson(Map<String, dynamic> json) {
  return WeatherData(
      (json['daily_forecast'] as List)
          ?.map((e) => e == null
              ? null
              : DailyWeatherData.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['now'] == null
          ? null
          : NowWeatherData.fromJson(json['now'] as Map<String, dynamic>),
      (json['lifestyle'] as List)
          ?.map((e) =>
              e == null ? null : Lifestyle.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$WeatherDataToJson(WeatherData instance) =>
    <String, dynamic>{
      'daily_forecast': instance.dailyForecasts,
      'now': instance.now,
      'lifestyle': instance.lifestyles
    };
