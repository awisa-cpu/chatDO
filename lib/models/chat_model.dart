import 'package:chatdo/models/message_model.dart';

class ChatModel {
  final String id;
  final List<String>? participantIds;
  final List<MessageModel>? messages;

  ///
  ChatModel({
    required this.id,
    required this.participantIds,
    required this.messages,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'participantIds': participantIds,
      'messages': messages?.map((m) => m.toJson()).toList() ?? [],
    };
  }

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'] as String,
      participantIds: List<String>.from(json['participantIds']),
      messages: json['messages'] != null
          ? List.from(json['messages'])
              .map((me) => MessageModel.fromJson(me))
              .toList()
          : [],
    );
  }
}
