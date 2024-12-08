import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:qldt/data/model/class.dart';
import 'package:qldt/data/repo/class_repository.dart';
import 'package:qldt/data/request/get_class_list_request.dart';
import 'package:qldt/presentation/pref/get_shared_preferences.dart';
import 'package:qldt/presentation/pref/user_preferences.dart';

class ClassListProvider extends ChangeNotifier {
  List<Class>? classes;
  final ClassRepo repo;
  ClassListProvider({required this.repo});

  Future<List<Class>?> getClassList() async {
    Logger().d("getClassList started");

    final result = await repo.getAllClass(GetClassListRequest(
        token: UserPreferences.getToken(),
        role: UserPreferences.getRole(),
        accountId: UserPreferences.getId(),
        pageableRequest: {
          'page': "0",
          'page_size': "1"
        })
    );
    result.fold(
      (left) {
        Logger().e(left);
      },
      (right) {
        classes = right;
        notifyListeners();
      }
    );
    return classes;
  }
}