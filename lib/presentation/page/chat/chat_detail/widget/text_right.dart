import 'package:flutter/material.dart';
import 'package:qldt/presentation/page/chat/chat_detail/message.dart';
import 'package:qldt/presentation/theme/color_style.dart';

import '../../../../../helper/utils.dart';

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
              crossAxisAlignment: CrossAxisAlignment.end,
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
                    child: Text(message.messageContent ?? "Tin nhắn đã được thu hồi", style: TextStyle(color: QLDTColor.white),)
                ),
                Text(Utils.formatDateTime(message.createdAt), style: TextStyle(fontSize: 10),)
              ],
            ),
          ),
        ],
      )],
    );
  }
}
