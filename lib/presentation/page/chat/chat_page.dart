import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:qldt/helper/constant.dart';
import 'package:qldt/helper/string_constant.dart';
import 'package:qldt/helper/utils.dart';
import 'package:qldt/presentation/pref/user_preferences.dart';
import 'package:qldt/presentation/theme/color_style.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  late Future<List<Conversation>> _futureConversations;

  @override
  void initState() {
    super.initState();
    // Example token, index, and count values
    try  {
      _futureConversations = fetchConversations(
        token: UserPreferences.getToken() ?? "",
        index: 0,
        count: 5,
      );
    } catch(e) {
      Logger().d("Fetch converstation error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: QLDTColor.grey,
      child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: StringConstant.hint_search_chat,
                      hintStyle: TextStyle(
                          color: QLDTColor.grey
                      )
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  flex: 1,
                  child: FutureBuilder<List<Conversation>>(
                    future: _futureConversations,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        final conversations = snapshot.data!;
                        return ListView.builder(
                          itemCount: conversations.length,
                          itemBuilder: (context, index) {
                            final conversation = conversations[index];
                            return ChatUnit(conversation: conversation);
                          },
                        );
                      } else {
                        return Center(child: Text('No data found.'));
                      }
                    },
                  ),
                ),
              ],
            ),
          )
      ),
    );

  }
}

class ChatUnit extends StatelessWidget {
  Conversation conversation;
  ChatUnit({super.key, required this.conversation});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context,
            "/ChatDetail",
            arguments: conversation
        );
      },
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 12),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: QLDTColor.white
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                child: ClipOval(
                  child: Container(
                      height: 52,
                      width: 52,
                      child: conversation.partnerAvatar != null ? Image.network(conversation.partnerAvatar!) : Image.asset("assets/images/default.jpg")
                  ),
                ),
                radius: 26,
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(conversation.partnerName, style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      )),
                      Text(conversation.lastMessage ?? "Tin nhắn đã được thu hồi", overflow: TextOverflow.ellipsis, style: TextStyle(color: conversation.unreadCount == 1 ? QLDTColor.lightBlack : Colors.black, fontSize: 12))
                    ]
                  ),
                ),
              ),
              Row(
                children: [
                  Text(Utils.formatDateTime(conversation.lastMessageTime), style: TextStyle(color: QLDTColor.lightBlack, fontSize: 12)),
                ],
              )
            ]),
      ),
    );
  }
}


class Conversation {
  final int id;
  final int partnerId;
  final String partnerName;
  final String? partnerAvatar;
  final String? lastMessage;
  final String lastMessageTime;
  final int unreadCount;

  Conversation({
    required this.id,
    required this.partnerId,
    required this.partnerName,
    this.partnerAvatar,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      partnerId: json['partner']['id'],
      partnerName: json['partner']['name'],
      partnerAvatar: json['partner']['avatar'],
      lastMessage: json['last_message']['message'],
      lastMessageTime: json['last_message']['created_at'],
      unreadCount: json['last_message']['unread'],
    );
  }
}

Future<List<Conversation>> fetchConversations({
  required String token,
  required int index,
  required int count,
}) async {
  const String apiUrl = "${Constant.BASEURL}/it5023e/get_list_conversation";

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'token': token,
      'index': index.toString(),
      'count': count.toString(),
    }),
  );

  final Map<String, dynamic> responseBody = jsonDecode(response.body);

  if (response.statusCode == 200 && responseBody['meta']['code'] == '1000') {
    final List<dynamic> conversationsJson = responseBody['data']['conversations'];
    return conversationsJson.map((json) => Conversation.fromJson(json)).toList();
  } else {
    final errorMessage = responseBody['meta']['message'];
    throw Exception('Failed to fetch conversations: $errorMessage');
  }
}

