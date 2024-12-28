class Message {
  final String messageId;
  final String? messageContent;
  final int senderId;
  final String senderName;
  final String? senderAvatar;
  final String createdAt;
  final int unread;

  Message({
    required this.messageId,
    required this.messageContent,
    required this.senderId,
    required this.senderName,
    this.senderAvatar,
    required this.createdAt,
    required this.unread,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      messageId: json['message_id'],
      messageContent: json['message'],
      senderId: json['sender']['id'],
      senderName: json['sender']['name'],
      senderAvatar: json['sender']['avatar'],
      createdAt: json['created_at'],
      unread: json['unread'],
    );
  }
}
