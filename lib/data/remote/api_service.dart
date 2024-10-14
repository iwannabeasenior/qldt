import 'package:dartz/dartz.dart';
import 'package:qldt/data/model/class.dart';
import 'package:qldt/helper/failure.dart';

abstract class ApiService {
  Future<Either<Failure, List<Class>>> getAllWeather();
}
class ApiServiceImpl extends ApiService {
  @override
  Future<Either<Failure, List<Class>>> getAllWeather() async {
    try {
       // base url + request
    } catch (e) {

    }
    return Left(Failure(code: 1001, message: 'Check something wrong it your code'));
    // get, post, put, ...
  }
}