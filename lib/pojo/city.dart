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

  factory City.fromJson(Map<String, dynamic> json) {
    City city = _$CityFromJson(json);

    if(city.parentCity == null) {
      city.parentCity = city.name;
    }

    if(city.adminArea == null) {
      city.adminArea = "";
    }

    return city;
  }

  Map<String, dynamic> toJson() => _$CityToJson(this);

  @override
  String toString() {
    return 'City{name: $name, cid: $cid, parentCity: $parentCity, adminArea: $adminArea, cnty: $cnty}';
  }

  City.fromMap(Map<String, dynamic> map) {
    name = map["name"];
    cid = map["cid"];
    parentCity = map["parent_city"];
    adminArea = map["admin_area"];
    cnty = map["cnty"];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "name": name,
      "cid": cid,
      "parent_city": parentCity,
      "admin_area": adminArea,
      "cnty": cnty
    };

    return map;
  }
}
