import 'dart:convert';
import 'package:http/http.dart' as http;

import 'model.dart';

Future<Map<String, dynamic>> fetchUsers(String search, int page, int pageSize, String apiPrefix) async {
  final url = Uri.parse('$apiPrefix/it5023e/search_account');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'search': search,
      'pageable_request': {'page': page.toString(), 'page_size': pageSize.toString()},
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(utf8.decode(response.bodyBytes))['data'];
    final pageContent = (data['page_content'] as List).map((json) => UserSearch.fromJson(json)).toList();
    final pageInfo = PageInfoSearch.fromJson(data['page_info']);
    return {'pageContent': pageContent, 'pageInfo': pageInfo};
  } else {
    throw Exception('Failed to load users');
  }
}
