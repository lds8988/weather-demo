import 'package:weather_demo/remote/base/base_request.dart';

class SearchCityApi extends BaseRequest {
  @override
  String getMethod() {
    return BaseRequest.METHOD_GET;
  }

  @override
  String getPath() {
    return "https://search.heweather.com/find";
  }

}