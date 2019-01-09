// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'now_weather_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NowWeatherData _$NowWeatherDataFromJson(Map<String, dynamic> json) {
  return NowWeatherData(
      fl: json['fl'] as String,
      tmp: json['tmp'] as String,
      condCode: json['cond_code'] as String,
      cond: json['cond_txt'] as String,
      windDir: json['wind_dir'] as String,
      windSc: json['wind_sc'] as String,
      hum: json['hum'] as String,
      pres: json['pres'] as String);
}

Map<String, dynamic> _$NowWeatherDataToJson(NowWeatherData instance) =>
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
