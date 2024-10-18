import 'package:dartz/dartz.dart';
import 'package:qldt/data/model/class.dart';
import 'package:qldt/data/remote/api_service.dart';
import 'package:qldt/helper/failure.dart';

abstract class ClassRepository{
  Future<Either<Failure, List<Class>>> getAllClass();
  void updateNumberClass();
}
class ClassRepositoryImpl extends ClassRepository {
  final ApiService api;
  ClassRepositoryImpl(this.api);
  @override
  Future<Either<Failure, List<Class>>> getAllClass() {
    return api.getAllWeather();
  }

  @override
  void updateNumberClass() {
    // TODO: implement updateNumberClass
  }
}
