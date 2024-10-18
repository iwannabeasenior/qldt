import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:qldt/data/model/class.dart';
import 'package:qldt/data/model/lecture.dart';
import 'package:qldt/data/model/student.dart';
import 'package:qldt/helper/failure.dart';
import 'package:http/http.dart' as http;

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


//==============================================================
//api_service 2.0 by Hoang<3
//student
abstract class DataSource {
  Future<List<T>?> loadData<T>(String source); // Load danh sách dữ liệu từ source (remote hoặc local)

  // Triển khai sẵn getOne trong abstract class
  Future<T?> getOne<T>(String source, String id) async {
    List<T>? dataList = await loadData<T>(source);
    if (dataList != null) {
      return dataList.firstWhere(
            (item) => (item as dynamic).id == id,
      );
    }
    return null;
  }
}

//call tu api
class RemoteDataSource extends DataSource {
  @override
  Future<List<T>?> loadData<T>(String source) async{
    const url = "https://example.com/api/"; //api
    final uri = Uri.parse(url + "$source");
    //Lay du lieu tu api
    try {
      final response = await http.get(uri);
      if(response.statusCode == 200){
        final bodyContent = utf8.decode(response.bodyBytes);
        var dataWrapper = jsonDecode(bodyContent) as Map;
        var dataList = dataWrapper[source] as List;
        //Thêm đối tượng mong muốn
        switch (T) {
          case Student:
            return dataList.map((item) => Student.fromJson(item)).toList() as List<T>;
          case Lecture:
            return dataList.map((item) => Lecture.fromJson(item)).toList() as List<T>;
        }
      }
    }
    catch(error) {
      debugPrint('Xảy ra lỗi: $error');
    }
    return null;
  }
}

class LocalDataSource extends DataSource {
  @override
  Future<List<T>?> loadData<T>(String source) async{
    final String response = await rootBundle.loadString('assets/mock_data/local_data.json');
    final jsonBody = jsonDecode(response) as Map;
    //Lấy danh sách tương ứng
    final List<dynamic> dataList = jsonBody[source] ?? [];
    // Thêm đối tượng mong muốn
    switch (T) {
      case Student:
        return dataList.map((item) => Student.fromJson(item)).toList() as List<T>;
      case Lecture:
        return dataList.map((item) => Lecture.fromJson(item)).toList() as List<T>;
    }
    return null;
  }
}

