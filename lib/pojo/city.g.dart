// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

City _$CityFromJson(Map<String, dynamic> json) {
  return City(
      name: json['location'] as String,
      cid: json['cid'] as String,
      parentCity: json['parent_city'] as String,
      adminArea: json['admin_area'] as String,
      cnty: json['cnty'] as String);
}

Map<String, dynamic> _$CityToJson(City instance) => <String, dynamic>{
      'location': instance.name,
      'cid': instance.cid,
      'parent_city': instance.parentCity,
      'admin_area': instance.adminArea,
      'cnty': instance.cnty
    };
