import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qldt/helper/string_constant.dart';
import 'package:qldt/presentation/page/chat/camera_screen.dart';
import 'package:qldt/presentation/page/chat/chat_page.dart';
import 'package:qldt/presentation/theme/color_style.dart';

class Message {
  String message;
  String message_id;
  bool unread;
  String created;
  Sender sender;
  Message({required this.message, required this.message_id, required this.unread, required this.created, required this.sender});
}

class Sender {
  String id;
  String username;
  String avatar;
  Sender({ required this.id,  required this.username, required this.avatar});
}

var messages = <Message>[
  Message(message: 'Hi', message_id: '123', unread: true, created: '10:23 AM', sender: Sender(id: '1231', username: 'Thanh', avatar: '')),
  Message(message: 'Hello', message_id: '124', unread: true, created: '10:23 AM', sender: Sender(id: '123', username: 'Thanh', avatar: '')),
  Message(message: 'How are you?', message_id: '125', unread: true, created: '10:23 AM', sender: Sender(id: '1231', username: 'Thanh', avatar: '')),
  Message(message: 'Im fine, and u?', message_id: '126', unread: true, created: '10:23 AM', sender: Sender(id: '123', username: 'Thanh', avatar: '')),
  Message(message: 'Im fine too!', message_id: '127', unread: true, created: '10:23 AM', sender: Sender(id: '1231', username: 'Thanh', avatar: '')),
];

class ChatDetail extends StatefulWidget {
  final Partner partner;
  const ChatDetail({super.key, required this.partner});

  @override
  State<ChatDetail> createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetail> {
  late CameraController controller;
  late TextEditingController textController;
  late ScrollController scrollController;
  @override
  void initState() {
    textController = TextEditingController();
    textController.addListener(() {
      setState(() {});
    });
    scrollController = ScrollController();
    super.initState();
  }
  @override
  void dispose() {
    controller.dispose();
    textController.dispose();
    super.dispose();
  }
  void _scrollDown() {
    scrollController.animateTo(scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 200), curve: Curves.bounceIn);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: QLDTColor.grey,
      body: SafeArea(
          child: Column(
            children: [
              Header(partner: widget.partner),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(top: 35, left: 10, right: 10),
                  child: ListView.separated(
                    controller: scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return messages[index].sender.id != widget.partner.id ? TextRight(message: messages[index]) : TextLeft(message: messages[index],);
                    },
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    shrinkWrap: true,
                  ),
                )
              ),
              Footer(textController: textController, callBack: () { setState(() {_scrollDown.call();}); }),
            ],
          )
      ),
    );
  }
}
class Header extends StatelessWidget {
  final Partner partner;
  const Header({super.key, required this.partner});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(30), bottomLeft: Radius.circular(30))
      ),
      padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
      child: Row(
        children: [
          IconButton(icon: Icon(Icons.chevron_left, size: 30), onPressed: () {
            Navigator.pop(context);
          },),
          const SizedBox(width: 20),
          CircleAvatar(
            backgroundImage: AssetImage(partner.avatar),
            radius: 26
          ),
          const SizedBox(width: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween ,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(partner.username, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
              Text("Online", style: TextStyle(fontSize: 14, color: QLDTColor.green))
            ],
          )
        ],
      )
    );
  }
}

class Footer extends StatelessWidget {
  TextEditingController textController;
  Function callBack;
  Footer({super.key, required this.textController, required this.callBack});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        decoration: BoxDecoration(
            color: QLDTColor.white,
            borderRadius: const BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))
        ),
        child: TextField(
          controller: textController,
          maxLines: null,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(30)
            ),
            filled: true,
            fillColor: QLDTColor.grey,
            contentPadding: const EdgeInsets.only(left: 25),
            hintText: StringConstant.hint_text_chat,
            hintStyle: TextStyle(
              color: QLDTColor.lightBlack,
            ),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                    onTap: () async {
                      var _cameras = await availableCameras();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CameraScreen(camera: _cameras.first)));
                    },
                    child: Icon(Icons.camera_alt, size: 20)
                ),

                SizedBox(width: 15,),
                GestureDetector(
                    onTap: () {
                      if (textController.text.trim() != "") {
                        messages.add(Message(message: textController.text, message_id: '127', unread: true, created: '10:23 AM', sender: Sender(id: '1231', username: 'Thanh', avatar: '')));
                        textController.text = "";
                        callBack.call();
                      }
                    },
                    child: Icon(Icons.send, size: 20, color: textController.text.trim().isNotEmpty ? QLDTColor.green : Colors.black)
                ),
                SizedBox(width: 5),
              ],
            )
          ),
        )
    );
  }
}




class TextLeft extends StatelessWidget {
  final Message message;

  const TextLeft({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 240
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 11),
                margin: EdgeInsets.only(bottom: 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                      topLeft: Radius.circular(20)
                  )
                ),
                child: Text(message.message)
              ),
              Text(message.created, style: TextStyle(fontSize: 10),)
            ],
          ),
        ),
      ],
    );
  }
}
class TextRight extends StatelessWidget {
  final Message message;
  const TextRight({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [Wrap(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 240,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 11),
                    decoration: BoxDecoration(
                        color: QLDTColor.green,
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)
                        )
                    ),
                    child: Text(message.message, style: TextStyle(color: QLDTColor.white),)
                ),
                Text(message.created, style: TextStyle(fontSize: 10),)
              ],
            ),
          ),
        ],
      )],
    );
  }
}
