import 'package:flutter/material.dart';
import 'package:qldt/helper/string_constant.dart';
import 'package:qldt/presentation/theme/color_style.dart';


// fake data
class ChatUser {
  String avatar;
  String name;
  String message;
  String time;
  ChatUser({required this.avatar, required this.name, required this.message, required this.time});
}

var chatUsers = [
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
                        List.generate(10, (index) {
                          return const ChatUnit();
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
  const ChatUnit({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/ChatDetail");
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
              const CircleAvatar(
                backgroundImage: AssetImage("assets/images/kaka.jpg", ),
                radius: 26,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text("Quỳnh Anh", style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
                    Text("Sáng chủ nhật đi hồ gươm với tớ nha", overflow: TextOverflow.ellipsis, style: TextStyle(color: QLDTColor.lightBlack, fontSize: 12))
                  ]
                ),
              ),
              Row(
                children: [
                  Text("12:04 AM", style: TextStyle(color: QLDTColor.lightBlack, fontSize: 12)),
                ],
              )
            ]),
      ),
    );
  }
}
