class UserSearch {
  final String accountId;
  final String firstName;
  final String lastName;
  final String email;

  UserSearch({required this.accountId, required this.firstName, required this.lastName, required this.email});

  factory UserSearch.fromJson(Map<String, dynamic> json) {
    return UserSearch(
      accountId: json['account_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
    );
  }
}

class PageInfoSearch {
  final int totalRecords;
  final int totalPage;
  final int pageSize;
  final int page;
  final int? nextPage;
  final int? previousPage;

  PageInfoSearch({required this.totalRecords, required this.totalPage, required this.pageSize, required this.page, this.nextPage, this.previousPage});

  factory PageInfoSearch.fromJson(Map<String, dynamic> json) {
    return PageInfoSearch(
      totalRecords: int.parse(json['total_records']),
      totalPage: int.parse(json['total_page']),
      pageSize: int.parse(json['page_size']),
      page: int.parse(json['page']),
      nextPage: json['next_page'] != null ? int.parse(json['next_page']) : null,
      previousPage: json['previous_page'] != null ? int.parse(json['previous_page']) : null,
    );
  }
}
