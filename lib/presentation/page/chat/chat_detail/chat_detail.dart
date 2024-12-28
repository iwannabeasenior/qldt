import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:qldt/presentation/page/chat/chat_detail/chat_detail_controller.dart';
import 'package:qldt/presentation/page/chat/chat_detail/widget/footer.dart';
import 'package:qldt/presentation/page/chat/chat_detail/widget/header.dart';
import 'package:qldt/presentation/page/chat/chat_detail/widget/text_left.dart';
import 'package:qldt/presentation/page/chat/chat_detail/widget/text_right.dart';
import 'package:qldt/presentation/page/chat/chat_page.dart';
import 'package:qldt/presentation/pref/user_preferences.dart';
import 'package:qldt/presentation/theme/color_style.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stomp_dart_client/stomp_dart_client.dart';


import 'message.dart';


class ChatDetail extends StatelessWidget {
  final Conversation conversation;
  const ChatDetail({super.key, required this.conversation});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ChatDetailProvider(),
        child: ChatDetailView(conversation: conversation)
    );
  }
}


class ChatDetailView extends StatefulWidget {
  final Conversation conversation;
  const ChatDetailView({super.key, required this.conversation});

  @override
  State<ChatDetailView> createState() => _ChatDetailViewState();
}

class _ChatDetailViewState extends State<ChatDetailView> implements ChatDetailCallBack {
  // late CameraController controller;
  late TextEditingController textController;
  late ScrollController scrollController;
  late Future<List<Message>> _futureMessages;
  late ChatDetailProvider controller;
  late StompClient stompClient;
  String? selectedMessageId;
  bool isSelectionMode = false;

  void onConnect(StompFrame frmae) {
    Logger().d("connected");
    stompClient.subscribe(
        destination: '/user/${UserPreferences.getId()}/inbox',
        callback: (frame) {
          Logger().d('has message: + ${frame.body}');
          var msg = jsonDecode(frame.body!);
          var message = Message(messageId: msg['id'].toString(), messageContent: msg['content'], senderId: msg['sender']['id'], senderName: msg['sender']['name'], createdAt: msg['created_at'], unread: msg['message_status']);
          controller.addMessage(message);
        }
    );
  }

  @override
  void initState() {

    stompClient = StompClient(
      config: StompConfig.sockJS(
        url: 'http://157.66.24.126:8080/ws',
        onConnect: onConnect,
        beforeConnect: () async => print('connectting'),
        stompConnectHeaders: {'Authorization': 'Bearer ${UserPreferences.getToken()}'},
        webSocketConnectHeaders: {'Authorization': 'Bearer ${UserPreferences.getToken()}'},
        onWebSocketError: (e) => print('error' + e.toString()),
        onStompError: (d) => print('error stomp'),
        onDisconnect: (f) => print('disconnected'),
        onWebSocketDone: () => print("done")
      ),
    );
    stompClient.activate();

    textController = TextEditingController();

    textController.addListener(() {
      setState(() {});
    });

    scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<ChatDetailProvider>().fetchConversation(
        token: UserPreferences.getToken() ?? "",
        index: 0,
        count: 10,
        partnerId: widget.conversation.partnerId,
        conversationId: widget.conversation.id,
        markAsRead: true,
      );
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        _scrollDown();
      });
    });
    super.initState();
  }


  @override
  void dispose() {
    controller.dispose();
    textController.dispose();
    stompClient.deactivate();
    super.dispose();
  }


  void _scrollDown() {
    setState(() {
      scrollController.animateTo(scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 200), curve: Curves.bounceIn);
    });
  }

  void _sendMessage(int receiverId, String content) {
    Logger().d("send");
    final message = {
      'receiver': { 'id': receiverId.toString() },
      'content': content,
      'sender': UserPreferences.getEmail(),
      'token': UserPreferences.getToken(),
    };
    stompClient.send(destination: '/chat/message', body: jsonEncode(message));
  }

  void onLongPressMessage(String messageId) {
    setState(() {
      selectedMessageId = messageId;
      isSelectionMode = true;
    });
  }

  void onReset() {
    setState(() {
      isSelectionMode = false;
      selectedMessageId = null;
    });
  }

  @override
  Widget build(BuildContext context) {

    controller = context.watch<ChatDetailProvider>();

    controller.callback = this;

    return Scaffold(
      backgroundColor: QLDTColor.grey,
      body: GestureDetector(
        onTap: onReset,
        child: SafeArea(
            child: Column(
              children: [
                Header(conversation: widget.conversation),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(top: 35, left: 10, right: 10),
                      child: controller.isLoading
                          ? Center(child: CircularProgressIndicator())
                          : ListView.separated(
                              controller: scrollController,
                              itemCount: controller.messages.length,
                              itemBuilder: (context, index) {
                                return controller.messages[index].senderId != widget.conversation.partnerId
                                    ? GestureDetector(
                                          onLongPress: () {
                                            onLongPressMessage(controller.messages[index].messageId);
                                          },
                                          child: TextRight(message: controller.messages[index])
                                      )
                                    : GestureDetector(
                                          onLongPress: () {
                                            onLongPressMessage(controller.messages[index].messageId);
                                          },
                                          child: TextLeft(message: controller.messages[index],)
                                      );
                              },
                              separatorBuilder: (context, index) => const SizedBox(height: 10),
                              shrinkWrap: true,
                            )
                  )
                ),

                Footer(textController: textController, callBack: () { setState(() {_scrollDown.call();}); }, sendMessage: _sendMessage, receiverId: widget.conversation.partnerId),
              ],
            )
        ),
      ),
      floatingActionButton: isSelectionMode
        ? FloatingActionButton(
          onPressed: () {
            if (selectedMessageId != null) {
              controller.deleteMessage(selectedMessageId ?? "", widget.conversation.id.toString(), context);
              onReset();
            }
          },
          backgroundColor: Colors.red,
          child: Icon(Icons.delete),
        )
        : null
    );
  }

  @override
  void scrollDown() {
    _scrollDown();
  }

}





