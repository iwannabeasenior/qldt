import 'package:flutter/cupertino.dart';
import 'package:qldt/data/model/lecture.dart';
import 'package:qldt/data/model/student.dart';
import 'package:qldt/data/remote/api_service.dart';

abstract interface class LectureRepository {
  Future<List<Lecture>?> loadData();
}

class DefaultLectureRepository implements LectureRepository {
  final _remoteDataSource = RemoteDataSource();
  final _localDataSource = LocalDataSource();

  @override
  Future<List<Lecture>?> loadData() async {
    String source = "lectures";

    List<Lecture> lectures = [];
    await _remoteDataSource.loadData<Lecture>(source).then((remoteLectures) async {
      if (remoteLectures == null) {
        await _localDataSource.loadData<Lecture>(source).then((localLectures) {
          if (localLectures != null) {
            lectures.addAll(localLectures);
          }
        });
      } else {
        lectures.addAll(remoteLectures);
      }
    });
    return lectures;
  }

  Future<Lecture?> getOne(String id) async {
    String source = "lectures";

    Lecture? lecture = await _remoteDataSource.getOne<Lecture>(source, id);
    lecture ??= await _localDataSource.getOne<Lecture>(source, id);
    return lecture;
  }
}

