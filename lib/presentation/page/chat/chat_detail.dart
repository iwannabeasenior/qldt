import 'package:flutter/material.dart';
import 'package:qldt/helper/string_constant.dart';
import 'package:qldt/presentation/theme/color_style.dart';

class ChatDetail extends StatefulWidget {
  const ChatDetail({super.key});

  @override
  State<ChatDetail> createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: QLDTColor.grey,
      body: SafeArea(
          child: Column(
            children: [
              const Header(),
              Expanded(
                child: ListView(
                  children: const [
                    TextRight(),
                    TextLeft(),
                  ],
                )
              ),
              const TextRight(),
              const Footer(),

            ],
          )
      ),
    );
  }
}
class Header extends StatelessWidget {
  const Header({super.key});

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
          const Icon(Icons.chevron_left, size: 30,),
          const SizedBox(width: 20),
          const CircleAvatar(
            backgroundImage: AssetImage("assets/images/kaka.jpg"),
            radius: 26
          ),
          const SizedBox(width: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween ,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Quỳnh Anh", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
              Text("Online", style: TextStyle(fontSize: 14, color: QLDTColor.green))
            ],
          )
        ],
      )
    );
  }
}

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        decoration: BoxDecoration(
            color: QLDTColor.white,
            borderRadius: const BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))
        ),
        child: TextField(
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
          ),
        )
    );
  }
}




class TextLeft extends StatelessWidget {
  const TextLeft({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      padding: const EdgeInsets.only(left: 17, top: 11, bottom: 11),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
            topLeft: Radius.circular(20)
        )
      ),
      child: const Text("Hi, Thanh! How are you?")
    );
  }
}
class TextRight extends StatelessWidget {
  const TextRight({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 240,
      ),
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 11),
          decoration: BoxDecoration(
              color: QLDTColor.green,
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20)
              )
          ),
          child: Text("I'm good, how are you, Quynh Anh?", style: TextStyle(color: QLDTColor.white),)
      ),
    );
  }
}
