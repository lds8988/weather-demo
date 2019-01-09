import 'package:json_annotation/json_annotation.dart';

part 'lifestyle.g.dart';

@JsonSerializable()
class Lifestyle {
  String brf;
  String txt;
  String type;

  Map<String, String> _typeTitleMap = {
    "comf": "舒适度指数",
    "cw": "洗车指数",
    "drsg": "穿衣指数",
    "flu": "感冒指数",
    "sport": "运动指数",
    "trav": "旅游指数",
    "uv": "紫外线指数",
    "air": "空气污染指数",
    "ac": "空调开启指数",
    "ag": "过敏指数",
    "gl": "太阳镜指数",
    "mu": "化妆指数",
    "airc": "晾晒指数",
    "ptfc": "交通指数",
    "fsh": "钓鱼指数",
    "spi": "防晒指数"
  };

  Map<String, String> _iconMap = {
    "comf": "images/ic_comfort.png",
    "cw": "images/ic_wash_car.png",
    "drsg": "images/ic_clothes.png",
    "flu": "images/ic_flu.png",
    "sport": "images/ic_sport.png",
    "trav": "images/ic_travel.png",
    "uv": "images/ic_uv.png",
    "air": "images/ic_air.png",
  };

  Lifestyle(this.brf, this.txt, this.type);

  factory Lifestyle.fromJson(Map<String, dynamic> json) =>
      _$LifestyleFromJson(json);

  Map<String, dynamic> toJson() => _$LifestyleToJson(this);

  String getIcon(String type) {
    return _iconMap[type];
  }

  String getTypeTitle(String type) {
    return _typeTitleMap[type];
  }
}
