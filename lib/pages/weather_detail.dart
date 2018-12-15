import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:amap_location/amap_location.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:easy_alert/easy_alert.dart';
import 'package:weather_demo/pojo/city.dart';
import 'package:weather_demo/pojo/weather_data.dart';

class WeatherDetail extends StatefulWidget {
  final String city;

  WeatherDetail({Key key, this.city}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return WeatherState();
  }
}

class WeatherState extends State<WeatherDetail> {
  AMapLocation _loc;

  String _tittle = "正在定位...";

  WeatherData _weatherData = WeatherData.empty();

  var _dio = new Dio();

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  void _getWeatherData(String location) async {
    Response response = await _dio.get(
        "https://free-api.heweather.com/s6/weather/now?key=340cfb442d9a454a8d5e8f36a6382886&location=" +
            location);

    setState(() {
      print(response.data);

      _tittle = response.data["HeWeather6"][0]["basic"]["location"];

      _weatherData =
          WeatherData.fromJson(response.data["HeWeather6"][0]["now"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            "images/bg_weather_detail.jpg",
            fit: BoxFit.cover,
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(
                    0, MediaQuery.of(context).padding.top, 0, 0),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.menu, color: Colors.grey),
                      onPressed: () {
                        _scaffoldKey.currentState.openDrawer();
                      },
                    ),
                    Text(_tittle,
                        style: TextStyle(color: Colors.grey, fontSize: 20)),
                  ],
                ),
              ),
              Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(16, 80, 16, 0),
                  child: Column(
                    children: <Widget>[
                      Text(_weatherData.tmp + "℃",
                          style: TextStyle(color: Colors.grey, fontSize: 80.0)),
                      Text(_weatherData.cond,
                          style: TextStyle(color: Colors.grey, fontSize: 45.0)),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 280, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Image.asset("images/ic_wind_dir.png",
                                      width: 47, height: 47),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                      child: Text(_weatherData.windSc + "级",
                                          style: TextStyle(
                                              color: Colors.black45,
                                              fontSize: 20.0))),
                                  Text(_weatherData.windDir,
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 18.0))
                                ],
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Image.asset("images/ic_hum.png",
                                      width: 48, height: 48),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                                      child: Text(_weatherData.hum + "%",
                                          style: TextStyle(
                                              color: Colors.black45,
                                              fontSize: 20.0))),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 6, 0, 0),
                                    child: Text("相对湿度",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 18.0)),
                                  )
                                ],
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Image.asset("images/ic_tem.png",
                                      width: 48, height: 48),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                                      child: Text(_weatherData.fl + "℃",
                                          style: TextStyle(
                                              color: Colors.black45,
                                              fontSize: 20.0))),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 6, 0, 0),
                                    child: Text("体感温度",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 18.0)),
                                  )

                                ],
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Image.asset("images/ic_press.png",
                                      width: 48, height: 48),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                                      child: Text(_weatherData.pres + "hPa",
                                          style: TextStyle(
                                              color: Colors.black45,
                                              fontSize: 20.0))),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 6, 0, 0),
                                    child: Text("大气压强",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 18.0)),
                                  )

                                ],
                              ),
                              flex: 1,
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
            ],
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: ExactAssetImage("images/header.jpeg"),
                        fit: BoxFit.fill)),
                child: Stack(
                  alignment: const Alignment(-0.8, 0.8),
                  children: <Widget>[
                    Text(
                      "添加的城市",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    )
                  ],
                )),
            ListTile(
              title: Text("添加城市"),
              leading: CircleAvatar(
                child: Icon(Icons.add_location),
              ),
              onTap: () {
                Navigator.pushNamed(context, "addCity").then((value) {
                  City city = value;
                  _getWeatherData(city.cid);
                });
              },
            )
          ],
        ),
      ),
    );
  }

  void _checkPermission() async {
    bool hasPermission =
        await SimplePermissions.checkPermission(Permission.WhenInUseLocation);

    if (!hasPermission) {
      PermissionStatus requestPermissionResult =
          await SimplePermissions.requestPermission(
              Permission.WhenInUseLocation);
      if (requestPermissionResult != PermissionStatus.authorized) {
        Alert.alert(context, title: "申请定位权限失败");
        return;
      }
    }

    AMapLocation loc = await AMapLocationClient.getLocation(true);
    setState(() {
      _loc = loc;

      if (loc.city.isEmpty) {
        _tittle = "定位失败...";
      } else {
        _getWeatherData(
            loc.longitude.toString() + "," + loc.latitude.toString());
      }
    });
  }

  @override
  void initState() {
    if (widget.city.isEmpty) {
      _checkPermission();
    }

    super.initState();
  }

  @override
  void dispose() {
    // 停止定位
    AMapLocationClient.stopLocation();

    super.dispose();
  }
}
