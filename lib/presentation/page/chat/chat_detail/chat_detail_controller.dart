import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:qldt/presentation/pref/user_preferences.dart';
import '../../../../helper/constant.dart';
import 'message.dart';
import 'package:http/http.dart' as http;


class ChatDetailProvider extends ChangeNotifier {
  List<Message> messages = [];

  bool isLoading = true;

  late ChatDetailCallBack callback;

  void addMessage(Message newMessage) {
    messages.add(newMessage);
    notifyListeners();
  }

  void removeMessage(String id) {
    messages.removeWhere((msg) => msg.messageId == id);
    notifyListeners();
  }

  Future<List<Message>> fetchConversation({
    required String token,
    required int index,
    required int count,
    required int partnerId,
    required int conversationId,
    required bool markAsRead,
  }) async {
    const String apiUrl = "${Constant.BASEURL}/it5023e/get_conversation";

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'token': token,
        'index': index.toString(),
        'count': count.toString(),
        'partner_id': partnerId.toString(),
        'conversation_id': conversationId.toString(),
        'mark_as_read': markAsRead.toString(),
      }),
    );

    final Map<String, dynamic> responseBody = jsonDecode(response.body);

    if (response.statusCode == 200 && responseBody['meta']['code'] == '1000') {

      final List<dynamic> messagesJson = responseBody['data']['conversation'];

      messages = messagesJson.map((json) => Message.fromJson(json)).toList();

      messages.removeWhere((message) => message.messageContent == null);

      messages.sort((m1, m2) => DateTime.parse(m1.createdAt).isAfter(DateTime.parse(m2.createdAt)) == true ? 1 : 0);

      isLoading = false;

      notifyListeners();

      callback.scrollDown();

      return messages;
    } else {

      final errorMessage = responseBody['meta']['message'];

      throw Exception('Failed to fetch conversation: $errorMessage');
    }
  }


  Future<void> deleteMessage(String messageId, String conversationId, BuildContext context) async {
    final url = Uri.parse('${Constant.BASEURL}/it5023e/delete_message');

    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          "token": UserPreferences.getToken(),
          "message_id": messageId,
          "conversation_id": conversationId,
        }),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['meta']['code'] == "1000") {
          // Message deleted successfully
          removeMessage(messageId);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Message deleted successfully!")),
          );
        } else {
          // Handle failed case
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['meta']['message'])),
          );
        }
      } else {
        throw Exception("Failed to delete message. Status code: ${response.statusCode}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

}
abstract class ChatDetailCallBack {
  void scrollDown();
}
