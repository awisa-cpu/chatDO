import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String senderId;
  final String content;
  final MessageType messageType;
  final Timestamp sentAt;
  final String? fileName;

  //
  MessageModel({
    required this.senderId,
    required this.content,
    required this.messageType,
    required this.sentAt,
    this.fileName,
  });

  Map<String, dynamic> toJson() => {
        'senderId': senderId,
        'content': content,
        'messageType': messageType.name,
        'sentAt': sentAt,
        'fileName': fileName ?? ''
      };

  factory MessageModel.fromJson(Map<String, dynamic> data) {
    return MessageModel(
      senderId: data['senderId'] as String,
      content: data['content'] as String,
      messageType: MessageType.values.byName(data['messageType']),
      sentAt: data['sentAt'] as Timestamp,
      fileName: data['fileName'] as String,
    );
  }
}

enum MessageType {
  text,
  image,
  video,
  file,
}
