import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:amap_location/amap_location.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:easy_alert/easy_alert.dart';
import 'package:weather_demo/db/city_dao.dart';
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
  String _tittle = "正在定位...";

  WeatherData _weatherData = WeatherData.empty();

  var _dio = new Dio();

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  List<City> _cityList = List();

  String _curLocation = "";

  Future _getWeatherData(String location) async {
    Response response = await _dio.get(
        "https://free-api.heweather.com/s6/weather/now?key=340cfb442d9a454a8d5e8f36a6382886&location=$location");

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
          RefreshIndicator(
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.menu, color: Colors.grey),
                          onPressed: () {
                            _scaffoldKey.currentState.openDrawer();
                          },
                        ),
                        Text(_tittle,
                            style:
                            TextStyle(color: Colors.grey, fontSize: 20)),
                      ],
                    ),
                    Container(
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(16, 80, 16, 0),
                        child: Column(
                          children: <Widget>[
                            Text(_weatherData.tmp + "℃",
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 80.0)),
                            Text(_weatherData.cond,
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 45.0)),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 280, 0, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Image.asset("images/ic_wind_dir.png",
                                            width: 47, height: 47),
                                        Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 10, 0, 0),
                                            child: Text(
                                                _weatherData.windSc + "级",
                                                style: TextStyle(
                                                    color: Colors.black45,
                                                    fontSize: 20.0))),
                                        Text(_weatherData.windDir,
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 18.0))
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
                                            padding: EdgeInsets.fromLTRB(
                                                0, 15, 0, 0),
                                            child: Text(_weatherData.hum + "%",
                                                style: TextStyle(
                                                    color: Colors.black45,
                                                    fontSize: 20.0))),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 4, 0, 0),
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
                                            padding: EdgeInsets.fromLTRB(
                                                0, 15, 0, 0),
                                            child: Text(_weatherData.fl + "℃",
                                                style: TextStyle(
                                                    color: Colors.black45,
                                                    fontSize: 20.0))),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 4, 0, 0),
                                          child: Text("体感温度",
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
                                        Image.asset("images/ic_press.png",
                                            width: 48, height: 48),
                                        Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 15, 0, 0),
                                            child: Text(
                                                _weatherData.pres + "hPa",
                                                style: TextStyle(
                                                    color: Colors.black45,
                                                    fontSize: 20.0))),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 4, 0, 0),
                                          child: Text("大气压强",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 18.0)),
                                        )
                                      ],
                                    ),
                                    flex: 1,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ))
                  ],
                )
              ],
            ),
            onRefresh: _loadData,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: _cityList.length + 2,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              // return the header
              return DrawerHeader(
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
                  ));
            } else if (index == _cityList.length + 1) {
              return ListTile(
                title: Text("添加城市"),
                leading: CircleAvatar(
                  child: Icon(Icons.add_location),
                ),
                trailing: new Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  Navigator.pushNamed(context, "addCity").then((value) async {
                    City city = value;

                    if (city != null) {
                      CityDao cityDao = CityDao();
                      await cityDao.open();
                      bool isInsert = await cityDao.insert(city);

                      if (isInsert) {
                        setState(() {
                          _cityList.add(city);
                        });
                      } else {
                        Alert.toast(_scaffoldKey.currentContext, "城市已在列表中！",
                            position: ToastPosition.center,
                            duration: ToastDuration.long);
                      }

                      cityDao.close();
                    }

                    //_getWeatherData(city.cid);
                  });
                },
              );
            } else {
              return CityItem(_cityList[index - 1], (cid) {
                setState(() {
                  _curLocation = cid;
                });

                _getWeatherData(cid);

                Navigator.pop(context);
              }, (cid) {
                showTip(cid);
              });
            }
          },
        ),
      ),
    );
  }

  Future _loadData() async {
    await _getWeatherData(_curLocation);

    setState(() {});
  }

  void showTip(String cid) {
    Alert.confirm(context, title: "系统提示", content: "确定删除城市？")
        .then((int ret) async {
      if (ret == Alert.OK) {
        CityDao cityDao = CityDao();
        await cityDao.open();
        int count = await cityDao.delete(cid);

        if (count == 1) {
          for (int i = 0; i < _cityList.length; i++) {
            City city = _cityList[i];
            if (city.cid == cid) {
              setState(() {
                _cityList.removeAt(i);
              });
              break;
            }
          }
          Alert.toast(context, "删除成功！");
        } else {
          Alert.toast(context, "删除失败！");
        }
      }
    });
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
      if (loc.city.isEmpty) {
        _tittle = "定位失败...";
      } else {
        _curLocation = loc.longitude.toString() + "," + loc.latitude.toString();
        _getWeatherData(_curLocation);
      }
    });
  }

  @override
  void initState() {
    if (widget.city.isEmpty) {
      _checkPermission();
    }

    initData();

    super.initState();
  }

  void initData() async {
    CityDao cityDao = CityDao();
    await cityDao.open();

    List<City> cities = await cityDao.getAll();

    setState(() {
      _cityList = cities;
    });
  }

  @override
  void dispose() {
    // 停止定位
    AMapLocationClient.stopLocation();

    super.dispose();
  }
}

class CityItem extends StatelessWidget {
  final City city;

  final onItemPressed;

  final onItemLongPressed;

  CityItem(this.city, this.onItemPressed, this.onItemLongPressed);

  bool _isLongPressed = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (() {
        if (_isLongPressed) {
          _isLongPressed = false;
        } else {
          onItemPressed(city.cid);
        }
      }),
      onLongPress: () {
        onItemLongPressed(city.cid);
        _isLongPressed = true;
      },
      child: ListTile(
        title: Text(
          city.name == city.parentCity
              ? "${city.name}市"
              : "${city.parentCity}市${city.name}",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
