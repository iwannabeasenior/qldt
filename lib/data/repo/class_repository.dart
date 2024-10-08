import 'package:qldt/data/model/class.dart';
import 'package:qldt/data/remote/api_service.dart';

abstract class ClassRepository{
  List<Class> getAllClass();
  void updateNumberClass();
}
class ClassRepositoryImpl extends ClassRepository {
  final ApiService api;
  ClassRepositoryImpl(this.api);
  @override
  List<Class> getAllClass() {
    return api.getAllWeather();
  }

  @override
  void updateNumberClass() {
    // TODO: implement updateNumberClass
  }
}
