import 'package:flutter/material.dart';
import 'package:qldt/helper/utils.dart';
import 'package:qldt/presentation/page/chat/chat_detail/message.dart';

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
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  child: Text(message.messageContent ?? "Tin nhắn đã được thu hồi")
              ),
              Text(Utils.formatDateTime(message.createdAt), style: TextStyle(fontSize: 10),)
            ],
          ),
        ),
      ],
    );
  }
}
