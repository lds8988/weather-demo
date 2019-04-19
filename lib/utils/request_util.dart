import 'dart:io';

import 'package:dio/dio.dart';
import 'package:weather_demo/constants.dart';

class RequestUtil {
  /// 服务器路径
  static const HOST = 'https://free-api.heweather.net/';
  static const BASE_URL = HOST + '/s6/';

  ///  基础信息配置
  static final Dio _dio = Dio(Options(baseUrl: BASE_URL));

  static final LogicError unknownError = LogicError(-1, "未知异常");

  static Future<Response<Map<String, dynamic>>> _request(
      String method, String path,
      {Map<String, dynamic> data, bool dataIsJson = true}) {
    /// 如果为 get方法，则进行参数拼接
    if (method == "get") {
      dataIsJson = false;
      if (data == null) {
        data = Map<String, dynamic>();
      }
    }

    if (Constants.IS_DEBUG) {
      print('<net url>------$path');
      print('<net params>------$data');
    }

    /// 根据当前 请求的类型来设置 如果是请求体形式则使用json格式
    /// 否则则是表单形式的（拼接在url上）
    Options op;
    if (dataIsJson) {
      op = new Options(contentType: ContentType.parse("application/json"));
    } else {
      op = new Options(
          contentType: ContentType.parse("application/x-www-form-urlencoded"));
    }

    op.method = method;

    return _dio.request<Map<String, dynamic>>(path, data: data, options: op);
  }

  /// 对请求返回的数据进行统一的处理
  /// 如果成功则将我们需要的数据返回出去，否则进异常处理方法，返回异常信息
  static Future<T> logicalErrorTransform<T>(
      Response<Map<String, dynamic>> resp) {
    if (resp.data != null) {
      if (resp.data["code"] == 0) {
        T realData = resp.data["data"];
        return Future.value(realData);
      }
    }

    if (Constants.IS_DEBUG) {
      print('resp--------$resp');
      print('resp.data--------${resp.data}');
    }

    LogicError error;
    if (resp.data != null && resp.data["code"] != 0) {
      if (resp.data['data'] != null) {
        /// 失败时  错误提示在 data中时
        /// 收到token过期时  直接进入登录页面
        Map<String, dynamic> realData = resp.data["data"];
        error = new LogicError(resp.data["code"], realData['codeMessage']);
      } else {
        /// 失败时  错误提示在 message中时
        error = new LogicError(resp.data["code"], resp.data["message"]);
      }
    } else {
      error = unknownError;
    }
    return Future.error(error);
  }
}

/// 统一异常类
class LogicError {
  int errorCode;
  String msg;

  LogicError(errorCode, msg) {
    this.errorCode = errorCode;
    this.msg = msg;
  }
}
