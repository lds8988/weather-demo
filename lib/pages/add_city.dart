import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:dio/dio.dart';
import 'package:weather_demo/pojo/city.dart';
import 'package:weather_demo/pojo/city_list.dart';

class AddCity extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchState();
  }
}

class SearchState extends State<AddCity> {
  SearchBar searchBar;

  var dio = new Dio();

  List<City> cityList = [];

  SearchState() {
    searchBar = SearchBar(
        inBar: false,
        hintText: "输入城市名称",
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        onSubmitted: onSubmitted,
        onClosed: () {
          print("closed");
        });
  }

  Future onSubmitted(String value) async {
    Response response = await dio.get(
        "https://search.heweather.com/find?key=340cfb442d9a454a8d5e8f36a6382886&location=" +
            value);

    setState(() {
      cityList = CityList.fromJson(response.data['HeWeather6'][0]).cityList;
      print(cityList);
    });
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
        title: Text("添加城市"), actions: [searchBar.getSearchAction(context)]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchBar.build(context),
      body: Container(
        child: ListView.separated(
          itemCount: cityList.length,
          separatorBuilder: (BuildContext context, int index) =>
              new Divider(), // 添加分割线
          itemBuilder: (context, index) => CityItem(cityList[index]),
        ),
      ),
    );
  }
}

class CityItem extends StatelessWidget {
  final City city;

  const CityItem(this.city);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (() {
        Navigator.pop(context, city);
      }),
      child: ListTile(
        title: Text((city.name == city.parentCity
                ? city.name + "市"
                : city.parentCity + "市" + city.name) +
            ", " +
            city.adminArea +
            ", " +
            city.cnty),
      ),
    );
  }
}
