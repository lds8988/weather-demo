import 'package:weather_demo/remote/base/base_request.dart';

class HotCityApi extends BaseRequest {

  HotCityApi() {
    getParams()["group"] = "cn";
  }

  @override
  String getMethod() {
    return BaseRequest.METHOD_GET;
  }

  @override
  String getPath() {
    return "https://search.heweather.net/top";
  }

}