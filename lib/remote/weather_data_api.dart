import 'package:weather_demo/remote/base/base_request.dart';

class WeatherDataApi extends BaseRequest {
  @override
  String getMethod() {
    return BaseRequest.METHOD_GET;
  }

  @override
  String getPath() {
    return "weather/now";
  }

}