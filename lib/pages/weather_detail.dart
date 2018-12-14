import 'package:flutter/material.dart';
import 'package:amap_location/amap_location.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:easy_alert/easy_alert.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.city.isEmpty ? '$_tittle' : widget.city,
          style: TextStyle(color: Colors.black45),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black45),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Weather Demo",
            ),
          ],
        ),
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
                  print(value);
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

      _tittle = loc.city.isEmpty ? "定位失败..." : loc.city;

      print("tittle:" + _tittle);
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
