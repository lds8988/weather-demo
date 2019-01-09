// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_weather_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyWeatherData _$DailyWeatherDataFromJson(Map<String, dynamic> json) {
  return DailyWeatherData(
      json['date'] as String,
      json['sr'] as String,
      json['ss'] as String,
      json['tmp_max'] as String,
      json['tmp_min'] as String,
      json['cond_txt_d'] as String,
      json['cond_code_d'] as String);
}

Map<String, dynamic> _$DailyWeatherDataToJson(DailyWeatherData instance) =>
    <String, dynamic>{
      'date': instance.date,
      'sr': instance.sunrise,
      'ss': instance.sunset,
      'tmp_max': instance.tmpMax,
      'tmp_min': instance.tmpMin,
      'cond_txt_d': instance.cond,
      'cond_code_d': instance.condCode
    };
