class GetClassListRequest {
  String? token;
  String? role;
  String? accountId;
  Map<String, String>? pageableRequest;
  GetClassListRequest({required this.token, required this.role, required this.accountId, required this.pageableRequest});
  Map<String, dynamic> toJson() => {
    'token': token,
    'role': role,
    'account_id': accountId,
    'pageable_request': {
      'page': pageableRequest?['page'],
      'page_size': pageableRequest?['page_size']
    }
  };
}