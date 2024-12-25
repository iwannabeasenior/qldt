import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qldt/main.dart';
import 'package:qldt/presentation/page/chat/chat_detail/chat_detail_controller.dart';
import 'package:qldt/presentation/page/chat/chat_detail/message.dart';

import '../../../../../helper/string_constant.dart';
import '../../../../theme/color_style.dart';
import '../../camera_screen.dart';

class Footer extends StatelessWidget {
  TextEditingController textController;
  Function callBack;
  int receiverId;
  void Function(int, String) sendMessage;
  Footer({super.key, required this.textController, required this.callBack, required this.sendMessage, required this.receiverId});

  @override
  Widget build(BuildContext context) {
    final ChatDetailProvider _controller = context.read<ChatDetailProvider>();

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
                  // GestureDetector(GestureDetector
                  //     onTap: () async {
                  //       var _cameras = await availableCameras();
                  //       Navigator.push(context, MaterialPageRoute(builder: (context) => CameraScreen(camera: _cameras.first)));
                  //     },
                  //     child: Icon(Icons.camera_alt, size: 20)
                  // ),

                  SizedBox(width: 15,),
                  GestureDetector(
                      onTap: () {
                        if (textController.text.trim() != "") {
                          sendMessage(receiverId, textController.text.trim());
                          textController.clear();
                          callBack.call();
                        }
                      },
                      child: Icon(Icons.send, size: 20, color: textController.text.trim().isNotEmpty ? QLDTColor.green : Colors.black)
                  ),
                  SizedBox(width: 20),
                ],
              )
          ),
        )
    );
  }
}
