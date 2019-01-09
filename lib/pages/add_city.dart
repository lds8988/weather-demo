import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:dio/dio.dart';
import 'package:weather_demo/pojo/city.dart';
import 'package:weather_demo/pojo/city_list.dart';
import 'package:weather_demo/remote/hot_city_api.dart';
import 'package:weather_demo/remote/search_city_api.dart';

class AddCity extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchState();
  }
}

class SearchState extends State<AddCity> {
  SearchBar searchBar;

  var dio = new Dio();

  Future<Response> _future;

  List<Widget> _hotCityWidgets = [];

  @override
  void initState() {
    super.initState();

    searchBar = SearchBar(
        inBar: false,
        hintText: "输入城市名称",
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        onSubmitted: onSubmitted,
        onClosed: () {
          print("closed");
        });

    HotCityApi hotCityApi = HotCityApi();
    hotCityApi.send().then((Response response) {
      List<City> cityList = CityList.fromJson(response.data).cityList;

      for (int i = 0; i < cityList.length; i++) {
        _hotCityWidgets.add(ActionChip(
          onPressed: (() {
            Navigator.pop(context, cityList[i]);
          }),
          label: Text(cityList[i].name),
        ));
      }
      setState(() {
        _hotCityWidgets = _hotCityWidgets;
      });
    });
  }

  void onSubmitted(String value) {
    setState(() {
      SearchCityApi searchCityApi = SearchCityApi();
      searchCityApi.getParams()["location"] = value;
      _future = searchCityApi.send();
    });
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
        title: Text("添加城市"), actions: [searchBar.getSearchAction(context)]);
  }

  Widget _showBody(snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 0, 0),
              child: Text("热门城市："),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Wrap(
                spacing: 13,
                children: _hotCityWidgets,
              ),
            )
          ],
        );
        break;
      case ConnectionState.waiting:
        return Center(
          child: Container(
            alignment: AlignmentDirectional.center,
            decoration: BoxDecoration(
              color: Colors.white70,
            ),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(10.0)),
              width: 300.0,
              height: 200.0,
              alignment: AlignmentDirectional.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child: CircularProgressIndicator(
                        value: null,
                        strokeWidth: 7.0,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 25.0),
                    child: Center(
                      child: Text(
                        "数据加载中...",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        break;
      default:
        if (snapshot.hasError) {
          print("get city data error: ${snapshot.error}");
          return Center(child: Text("加载失败！"));
        } else {
          Response response = snapshot.data;

          List<City> cityList =
              CityList.fromJson(response.data).cityList;

          print(cityList);

          return Container(
            child: ListView.separated(
              itemCount: cityList.length,
              separatorBuilder: (BuildContext context, int index) => Divider(),
              itemBuilder: (context, index) => CityItem(cityList[index]),
            ),
          );
        }

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Response>(
      future: _future,
      builder: (context, snapshot) {
        print(snapshot.connectionState);

        return Scaffold(
          appBar: searchBar.build(context),
          body: _showBody(snapshot),
        );
      },
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
        title: Text(genContent(city)),
      ),
    );
  }

  String genContent(City city) {
    String content;
    content = city.name == city.parentCity
        ? "${city.name}市"
        : "${city.parentCity}市${city.name}";

    if(city.adminArea.isEmpty) {
      content += ", ${city.cnty}";
    } else {
      content += ", ${city.adminArea}, ${city.cnty}";
    }

    return content;
  }
}
