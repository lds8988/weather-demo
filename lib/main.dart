import 'package:easy_alert/easy_alert.dart';
import 'package:flutter/material.dart';
import 'package:weather_demo/pages/add_city.dart';
import 'package:weather_demo/pages/weather_detail.dart';
import 'package:amap_location/amap_location.dart';

void main() {
  // 初始化定位Client
  AMapLocationClient.startup(new AMapLocationOption(
      desiredAccuracy: CLLocationAccuracy.kCLLocationAccuracyHundredMeters));

  // 设置ios定位的高德key
  AMapLocationClient.setApiKey("895e0a7fec321145cd13316d3102702a");

  runApp(AlertProvider(
    child: MyApp(),
    config: AlertConfig(
        ok: "确定",
        cancel: "取消"),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WeatherDetail(city: ""),
      routes: {"addCity": (BuildContext context) => AddCity()},
    );
  }
}
