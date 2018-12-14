// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CityList _$CityListFromJson(Map<String, dynamic> json) {
  return CityList(
      cityList: (json['basic'] as List)
          ?.map((e) =>
              e == null ? null : City.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$CityListToJson(CityList instance) =>
    <String, dynamic>{'basic': instance.cityList};
