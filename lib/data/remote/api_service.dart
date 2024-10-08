import 'package:qldt/data/model/class.dart';

abstract class ApiService {
  List<Class> getAllWeather();
}
class ApiServiceImpl extends ApiService {
  @override
  List<Class> getAllWeather() {
    return [];
    // get, post, put, ...
  }
}