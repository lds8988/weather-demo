import 'package:weather_demo/pojo/city.dart';
import 'package:json_annotation/json_annotation.dart';

part 'city_list.g.dart';

@JsonSerializable()
class CityList {
  @JsonKey(name: "basic")
  List<City> cityList;

  CityList({this.cityList});

  factory CityList.fromJson(Map<String, dynamic> json) => _$CityListFromJson(json);

  Map<String, dynamic> toJson() => _$CityListToJson(this);

  @override
  String toString() {
    return 'CityList{cityList: $cityList}';
  }


}