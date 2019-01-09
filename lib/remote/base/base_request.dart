import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:weather_demo/constants.dart';

abstract class BaseRequest {
  /// 服务器路径
  static const String _HOST = 'https://free-api.heweather.net/';
  static const String _BASE_URL = _HOST + '/s6/';

  static const String METHOD_GET = "GET";
  static const String METHOD_POST = "POST";

  static const String KEY = "340cfb442d9a454a8d5e8f36a6382886";

  ///  基础信息配置
  final Dio _dio =
      Dio(Options(baseUrl: _BASE_URL, responseType: ResponseType.JSON));

  Map<String, dynamic> _params = new Map();

  String getMethod();

  String getPath();

  Map<String, dynamic> getParams() {
    return _params;
  }

  Future<Response> send() {
    String path = getPath();

    String method = getMethod();

    if (method == METHOD_GET) {
      path += "?key=$KEY";

      _params.forEach((key, value) {
        path += "&$key=$value";
      });
    }

    Options op = Options(method: getMethod());

    _dio.interceptor.request.onSend = (Options options) {
      if (Constants.IS_DEBUG) {
        String path = "";

        if(!options.path.contains("http")) {
          path = options.baseUrl + options.path;
        } else {
          path = options.path;
        }

        print("url:$path");
        print("params:${options.data}");
        print("response type:${options.responseType}");
      }

      return options;
    };

    _dio.interceptor.response.onSuccess = (Response response) {
      if (Constants.IS_DEBUG) {
        print("content type:${response.headers.contentType}");
        print("data:${response.data}");
      }

      if (response.data.runtimeType.toString() == "String") {
        response.data = json.decode(response.data);
      }

      response.data = response.data["HeWeather6"][0];

      return response;
    };

    return _dio.request(path, data: method == METHOD_GET ? null : _params, options: op);
  }
}
