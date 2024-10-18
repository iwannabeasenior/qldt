import 'package:flutter/cupertino.dart';
import 'package:qldt/data/model/student.dart';
import 'package:qldt/data/remote/api_service.dart';

abstract interface class StudentRepository {
Future<List<Student>?> loadData();
}

class DefaultStudentRepository implements StudentRepository {
  final _remoteDataSource = RemoteDataSource();
  final _localDataSource = LocalDataSource();

  @override
  Future<List<Student>?> loadData() async {
    String source = "students";

    List<Student> students = [];
    await _remoteDataSource.loadData<Student>(source).then((remoteStudents) async {
      if (remoteStudents == null) {
        await _localDataSource.loadData<Student>(source).then((localStudents) {
          if (localStudents != null) {
            students.addAll(localStudents);
          }
        });
      } else {
        students.addAll(remoteStudents);
      }
    });
    return students;
  }

  Future<Student?> getOne(String id) async {
    String source = "students";
    Student? student = await _remoteDataSource.getOne<Student>(source, id);
    student ??= await _localDataSource.getOne<Student>(source, id);
    return student;
  }
}

