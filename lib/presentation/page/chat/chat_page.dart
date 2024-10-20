import 'package:flutter/material.dart';
import 'package:qldt/helper/string_constant.dart';
import 'package:qldt/presentation/theme/color_style.dart';


// fake data
class ChatUser {
  String id;
  Partner partner;
  LastMessage lastMessage;
  ChatUser({required this.id, required this.partner, required this.lastMessage});
}

class LastMessage {
  String message;
  String created;
  bool unread;
  LastMessage({required this.message, required this.created, required this.unread});
}

class Partner {
  String id;
  String username;
  String avatar;
  Partner({required this.id, required this.username, required this.avatar});
}

var users = [
  ChatUser(
    id: '123',
    partner: Partner(id: '1231', username: 'Thanh', avatar: 'assets/images/kaka.jpg'),
    lastMessage: LastMessage(message: 'Say hello!', created: '10/10', unread: true)
  ),
  ChatUser(
    id: '1',
    partner: Partner(id: '123', username: 'Nam', avatar: 'assets/images/kaka.jpg'),
    lastMessage: LastMessage(message: 'Say hello!', created: '10/10', unread: true)
  ),
  ChatUser(
    id: '12',
    partner: Partner(id: '123', username: 'Dat', avatar: 'assets/images/kaka.jpg'),
    lastMessage: LastMessage(message: 'Say hello!', created: '10/10', unread: true)
  ),
  ChatUser(
    id: '1234',
    partner: Partner(id: '1231', username: 'Lan Anh', avatar: 'assets/images/kaka.jpg'),
    lastMessage: LastMessage(message: 'Say hello!', created: '10/10', unread: true)
  ),
];

//
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
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
                  child: Center(
                    child: ListView(
                        scrollDirection: Axis.vertical,
                        children:
                        List.generate(users.length, (index) {
                          return ChatUnit(user: users[index]);
                        })

                    ),
                  ),
                )
              ],
            ),
          )
      ),
    );

  }
}

class ChatUnit extends StatelessWidget {
  ChatUser user;
  ChatUnit({super.key, required this.user});

  @override 
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context,
            "/ChatDetail",
            arguments: Partner (
              username: user.partner.username,
              id: user.partner.id,
              avatar: user.partner.avatar
            )
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
                backgroundImage: AssetImage(user.partner.avatar),
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
                      Text(user.partner.username, style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      )),
                      Text(user.lastMessage.message, overflow: TextOverflow.ellipsis, style: TextStyle(color: QLDTColor.lightBlack, fontSize: 12))
                    ]
                  ),
                ),
              ),
              Row(
                children: [
                  Text(user.lastMessage.created, style: TextStyle(color: QLDTColor.lightBlack, fontSize: 12)),
                ],
              )
            ]),
      ),
    );
  }
}
