import 'package:flutter/material.dart';
import 'package:weather_demo/pages/weather_detail.dart';
import 'package:amap_location/amap_location.dart';

void main() {

  // 初始化定位Client
  AMapLocationClient.startup(new AMapLocationOption(
      desiredAccuracy: CLLocationAccuracy.kCLLocationAccuracyHundredMeters));

  // 设置ios定位的高德key
  AMapLocationClient.setApiKey("895e0a7fec321145cd13316d3102702a");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WeatherDetail(city: ""),
    );
  }
}

