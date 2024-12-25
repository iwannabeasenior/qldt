
import '../../presentation/page/manage_class/open_class_list.dart';


class PageInfo1 {
  final String totalRecords;
  final String totalPage;
  final String pageSize;
  final String page;
  final String? nextPage;
  final String? previousPage;

  PageInfo1({
    required this.totalRecords,
    required this.totalPage,
    required this.pageSize,
    required this.page,
    this.nextPage,
    this.previousPage,
  });

  factory PageInfo1.fromJson(Map<String, dynamic> json) {
    return PageInfo1(
      totalRecords: json['total_records'],
      totalPage: json['total_page'],
      pageSize: json['page_size'],
      page: json['page'],
      nextPage: json['next_page'],
      previousPage: json['previous_page'],
    );
  }
}

class OpenClassResponse {
  final List<ClassModel1> classes;
  final PageInfo1 pageInfo;

  OpenClassResponse({
    required this.classes,
    required this.pageInfo,
  });

  factory OpenClassResponse.fromJson(Map<String, dynamic> json) {
    return OpenClassResponse(
      classes: List<ClassModel1>.from(
        json['data']['page_content'].map((x) => ClassModel1.fromJson(x)),
      ),
      pageInfo: PageInfo1.fromJson(json['data']['page_info']),
    );
  }
}
