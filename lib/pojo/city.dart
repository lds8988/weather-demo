import 'package:json_annotation/json_annotation.dart';

part 'city.g.dart';

@JsonSerializable()
class City {
  @JsonKey(name: "location")
  String name;

  String cid;
  @JsonKey(name: "parent_city")

  String parentCity;

  @JsonKey(name: "admin_area")
  String adminArea;

  String cnty;

  
  City({this.name, this.cid, this.parentCity, this.adminArea, this.cnty});

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);

  Map<String, dynamic> toJson() => _$CityToJson(this);

  @override
  String toString() {
    return 'City{name: $name, cid: $cid, parentCity: $parentCity, adminArea: $adminArea, cnty: $cnty}';
  }


}