// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherData _$WeatherDataFromJson(Map<String, dynamic> json) {
  return WeatherData(
      fl: json['fl'] as String,
      tmp: json['tmp'] as String,
      condCode: json['cond_code'] as String,
      cond: json['cond_txt'] as String,
      windDir: json['wind_dir'] as String,
      windSc: json['wind_sc'] as String,
      hum: json['hum'] as String,
      pres: json['pres'] as String);
}

Map<String, dynamic> _$WeatherDataToJson(WeatherData instance) =>
    <String, dynamic>{
      'fl': instance.fl,
      'tmp': instance.tmp,
      'cond_code': instance.condCode,
      'cond_txt': instance.cond,
      'wind_dir': instance.windDir,
      'wind_sc': instance.windSc,
      'hum': instance.hum,
      'pres': instance.pres
    };
