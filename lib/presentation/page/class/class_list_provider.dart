import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:qldt/data/model/class.dart';
import 'package:qldt/data/repo/class_repository.dart';
import 'package:qldt/data/request/get_class_list_request.dart';
import 'package:qldt/presentation/pref/user_preferences.dart';

class ClassListProvider extends ChangeNotifier {
  List<Class>? classes;
  final ClassRepo repo;

  int currentPage = 0;
  final int pageSize = 5;
  bool hasNextPage = true; //kiểm tra có trang tiếp theo hay không

  ClassListProvider({required this.repo});

  Future<List<Class>?> getClassList({int? page}) async {
    Logger().d("getClassList started");

    // Nếu page được cung cấp, kiểm tra trước khi thay đổi
    int newPage = page ?? currentPage;

    final result = await repo.getAllClass(GetClassListRequest(
      token: UserPreferences.getToken(),
      role: UserPreferences.getRole(),
      accountId: UserPreferences.getId(),
      pageableRequest: {
        'page': newPage.toString(),
        'page_size': pageSize.toString()
      },
    ));

    result.fold(
          (left) {
        Logger().e(left);
      },
          (right) {
        if (right.isNotEmpty) {
          // Cập nhật dữ liệu nếu có dữ liệu
          currentPage = newPage;
          classes = right;
          hasNextPage = right.length == pageSize; // Kiểm tra có trang tiếp theo hay không
        } else {
          hasNextPage = false; // Không có dữ liệu cho trang tiếp theo
          Logger().d("No data available for page $newPage");
        }
        notifyListeners();
      },
    );

    return classes;
  }
}


