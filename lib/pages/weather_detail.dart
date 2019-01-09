import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:amap_location/amap_location.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:easy_alert/easy_alert.dart';
import 'package:weather_demo/db/city_dao.dart';
import 'package:weather_demo/pojo/city.dart';
import 'package:weather_demo/pojo/daily_weather_data.dart';
import 'package:weather_demo/pojo/lifestyle.dart';
import 'package:weather_demo/pojo/weather_data.dart';
import 'package:weather_demo/pojo/now_weather_data.dart';
import 'package:weather_demo/remote/weather_data_api.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  List<City> _cityList = List();

  String _curLocation = "";

  Future _getWeatherData(String location) async {
    WeatherDataApi weatherDataApi = WeatherDataApi();
    weatherDataApi.getParams()["location"] = location;
    Response response = await weatherDataApi.send();

    setState(() {
      _tittle = response.data["basic"]["location"];

      _weatherData = WeatherData.fromJson(response.data);
    });
  }

  Widget genDailyWeatherWidget(DailyWeatherData dailyWeatherData) {
    return Padding(
      padding: EdgeInsets.only(top: dp(30)),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(dailyWeatherData.date.substring(5),
                style: TextStyle(color: Colors.grey, fontSize: dp(36))),
            flex: 4,
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Image.asset("images/cond_icon/${dailyWeatherData.condCode}.png",
                    width: dp(64), height: dp(64)),
                Text(dailyWeatherData.cond,
                    style: TextStyle(color: Colors.grey, fontSize: dp(36)))
              ],
            ),
            flex: 3,
          ),
          Expanded(
            child: Text(
                "${dailyWeatherData.tmpMin}℃~${dailyWeatherData.tmpMax}℃",
                style: TextStyle(color: Colors.grey, fontSize: dp(36)),
                textAlign: TextAlign.right),
            flex: 3,
          ),
        ],
      ),
    );
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
            child: CustomScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              slivers: <Widget>[
                SliverList(
//                  physics: AlwaysScrollableScrollPhysics(),
//                  padding: EdgeInsets.fromLTRB(dp(16), dp(180), dp(16), 0),
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: EdgeInsets.only(top: dp(180)),
                      child: Text(_weatherData.now.tmp + "℃",
                          style:
                              TextStyle(color: Colors.grey, fontSize: dp(130)),
                          textAlign: TextAlign.center),
                    ),
                    Text(_weatherData.now.cond,
                        style: TextStyle(color: Colors.grey, fontSize: dp(80)),
                        textAlign: TextAlign.center),
                    Padding(
                      padding: EdgeInsets.fromLTRB(dp(16), dp(150), dp(16), 0),
                      child: Column(
                        children: _weatherData.dailyForecasts
                            .map((DailyWeatherData dailyWeatherData) {
                          return genDailyWeatherWidget(dailyWeatherData);
                        }).toList(),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Color(
                        0x66ffffff,
                      )),
                      padding: EdgeInsets.fromLTRB(dp(16), dp(20), dp(16), 0),
                      margin: EdgeInsets.only(top: dp(180)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                              "日出：${_weatherData.dailyForecasts.isEmpty ? "" : _weatherData.dailyForecasts[0].sunrise}",
                              style: TextStyle(
                                  fontSize: dp(24), color: Colors.black54)),
                          Text(
                              "日落：${_weatherData.dailyForecasts.isEmpty ? "" : _weatherData.dailyForecasts[0].sunset}",
                              style: TextStyle(
                                  fontSize: dp(24), color: Colors.black54))
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Color(
                        0x66ffffff,
                      )),
                      padding: EdgeInsets.fromLTRB(0, dp(30), 0, dp(30)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Image.asset("images/ic_wind_dir.png",
                                    width: dp(80), height: dp(80)),
                                Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(0, dp(15), 0, 0),
                                    child: Text(_weatherData.now.windSc + "级",
                                        style: TextStyle(
                                            color: Colors.black45,
                                            fontSize: dp(36)))),
                                Padding(
                                  padding: EdgeInsets.only(top: dp(4)),
                                  child: Text(_weatherData.now.windDir,
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: dp(24))),
                                )
                              ],
                            ),
                            flex: 1,
                          ),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Image.asset("images/ic_hum.png",
                                    width: dp(80), height: dp(80)),
                                Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(0, dp(15), 0, 0),
                                    child: Text(_weatherData.now.hum + "%",
                                        style: TextStyle(
                                            color: Colors.black45,
                                            fontSize: dp(36)))),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                                  child: Text("相对湿度",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: dp(24))),
                                )
                              ],
                            ),
                            flex: 1,
                          ),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Image.asset("images/ic_tem.png",
                                    width: dp(80), height: dp(80)),
                                Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(0, dp(15), 0, 0),
                                    child: Text(_weatherData.now.fl + "℃",
                                        style: TextStyle(
                                            color: Colors.black45,
                                            fontSize: dp(36)))),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, dp(4), 0, 0),
                                  child: Text("体感温度",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: dp(24))),
                                )
                              ],
                            ),
                            flex: 1,
                          ),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Image.asset("images/ic_press.png",
                                    width: dp(80), height: dp(80)),
                                Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(0, dp(15), 0, 0),
                                    child: Text(_weatherData.now.pres + "hPa",
                                        style: TextStyle(
                                            color: Colors.black45,
                                            fontSize: dp(36)))),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, dp(4), 0, 0),
                                  child: Text("大气压强",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: dp(24))),
                                )
                              ],
                            ),
                            flex: 1,
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
                SliverPadding(
                    padding: EdgeInsets.fromLTRB(0, dp(30), 0, 0),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: dp(5),
                          crossAxisSpacing: dp(5),
                          childAspectRatio: 0.7,
                          crossAxisCount: 4),
                      delegate: SliverChildListDelegate(
                          _weatherData.lifestyles.map((Lifestyle lifestyle) {
                        return Container(
                          decoration: BoxDecoration(
                              color: Color(
                            0x50ffffff,
                          )),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(lifestyle.getIcon(lifestyle.type),
                                  width: dp(80), height: dp(80)),
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(0, dp(20), 0, dp(10)),
                                child: Text(lifestyle.brf,
                                    style: TextStyle(
                                        color: Colors.black45,
                                        fontSize: dp(24))),
                              ),
                              Text(lifestyle.getTypeTitle(lifestyle.type),
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: dp(24)))
                            ],
                          ),
                        );
                      }).toList()),
                    ))
              ],
            ),
            onRefresh: _loadData,
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top,
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.menu, color: Colors.grey),
                  onPressed: () {
                    _scaffoldKey.currentState.openDrawer();
                  },
                ),
                Text(_tittle,
                    style: TextStyle(color: Colors.grey, fontSize: dp(38))),
              ],
            ),
          )
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
                        style: TextStyle(color: Colors.white, fontSize: dp(38)),
                      )
                    ],
                  ));
            } else if (index == _cityList.length + 1) {
              return ListTile(
                title: Text("添加城市", style: TextStyle(fontSize: dp(28))),
                leading: CircleAvatar(
                  child: Icon(Icons.add_location),
                ),
                trailing: Icon(Icons.keyboard_arrow_right),
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
  }

  double dp(int px) {
    return ScreenUtil.instance.setWidth(px);
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

  Widget genLifeStyelItem(Lifestyle lifestyle) {}
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
          style: TextStyle(fontSize: ScreenUtil.instance.setWidth(28)),
        ),
      ),
    );
  }
}

class HourlyItem extends StatelessWidget {
  final NowWeatherData _weatherDataDetail;

  const HourlyItem(this._weatherDataDetail);

  @override
  Widget build(BuildContext context) {
    return Text(_weatherDataDetail.cond);
  }
}
