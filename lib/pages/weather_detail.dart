import 'package:flutter/material.dart';
import 'package:amap_location/amap_location.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:easy_alert/easy_alert.dart';

class WeatherDetail extends StatefulWidget {
  final String city;

  WeatherDetail({Key key, this.city}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new WeatherState();
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
          style: new TextStyle(color: Colors.black45),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: new IconThemeData(color: Colors.black45),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Weather Demo',
            ),
          ],
        ),
      ),
      drawer: Drawer(),
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
