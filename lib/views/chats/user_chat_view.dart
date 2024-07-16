import 'dart:io';

import 'package:chatdo/models/chat_model.dart';
import 'package:chatdo/models/message_model.dart';
import 'package:chatdo/models/user_model.dart';
import 'package:chatdo/services/alert_servivces.dart';
import 'package:chatdo/services/auth_services.dart';
import 'package:chatdo/services/database_services.dart';
import 'package:chatdo/services/navigation_services.dart';
import 'package:chatdo/services/storage_services.dart';
import 'package:chatdo/utils/constants.dart';
import 'package:chatdo/utils/strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

class UserChatView extends StatefulWidget {
  const UserChatView({super.key, required this.activeUser});
  final UserModel activeUser;

  @override
  State<UserChatView> createState() => _UserChatViewState();
}

class _UserChatViewState extends State<UserChatView> {
  final GetIt _getIt = GetIt.instance;
  ChatUser? currentUser, otherUser;
  File? pickedImageFile;
  late final AuthServices authService;
  late final NavigationServices navService;
  late final AlertServices alertService;
  late final DatabaseServices dbService;
  late final StorageServices storageService;

  @override
  void initState() {
    super.initState();
    try {
      authService = _getIt.get<AuthServices>();
      navService = _getIt.get<NavigationServices>();
      alertService = _getIt.get<AlertServices>();
      dbService = _getIt.get<DatabaseServices>();
      storageService = _getIt.get<StorageServices>();

      currentUser = ChatUser(
        id: authService.currentUser!.uid,
        firstName: authService.currentUser?.displayName,
      );
      otherUser = ChatUser(
        id: widget.activeUser.uid,
        firstName: widget.activeUser.name,
        profileImage: widget.activeUser.pfp,
      );
    } catch (e) {
      Logger().i('Error while init users and fetching services');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: _buildUserChatTitleWithPfp(),
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return StreamBuilder(
      stream: dbService.readChatMessages(
        uid1: authService.currentUser!.uid,
        uid2: widget.activeUser.uid,
      ),
      builder: (context, snapshot) {
        ChatModel? chat = snapshot.data?.data();

        List<ChatMessage> messages = [];
        if (chat != null && chat.messages != null) {
          messages = _convertToChatMessages(chat.messages!);
        }
        return DashChat(
          messageOptions: const MessageOptions(
              showTime: true,
              showCurrentUserAvatar: true,
              currentUserContainerColor: Colors.amber),
          inputOptions: InputOptions(
            alwaysShowSend: true,
            sendOnEnter: true,
            leading: [_selectImage(), _selectFile()],
          ),
          currentUser: currentUser!,
          onSend: _sendChatMessage,
          messages: messages,
        );
      },
    );
  }

  void _sendChatMessage(ChatMessage chatMessage) async {
    try {
      if (chatMessage.medias != null && chatMessage.medias!.isNotEmpty) {
        //this is to ensure we are handing different type of messages correctly
        if (chatMessage.medias!.first.type == MediaType.image) {
          final MessageModel newMessage = MessageModel(
            senderId: chatMessage.user.id,
            content: chatMessage.medias!.first.url,
            messageType: MessageType.image,
            sentAt: Timestamp.fromDate(chatMessage.createdAt),
          );

          await dbService.updateChatMessage(
            uid1: authService.currentUser!.uid,
            uid2: widget.activeUser.uid,
            message: newMessage,
          );
        } else if (chatMessage.medias!.first.type == MediaType.file) {
          final MessageModel newMessage = MessageModel(
              senderId: chatMessage.user.id,
              content: chatMessage.medias!.first.url,
              messageType: MessageType.file,
              sentAt: Timestamp.fromDate(chatMessage.createdAt),
              fileName: chatMessage.medias!.first.fileName);

          await dbService.updateChatMessage(
            uid1: authService.currentUser!.uid,
            uid2: widget.activeUser.uid,
            message: newMessage,
          );
        }
      } else {
        final MessageModel newMessage = MessageModel(
          senderId: chatMessage.user.id,
          content: chatMessage.text,
          messageType: MessageType.text,
          sentAt: Timestamp.fromDate(chatMessage.createdAt),
        );

        await dbService.updateChatMessage(
          uid1: authService.currentUser!.uid,
          uid2: widget.activeUser.uid,
          message: newMessage,
        );
      }
    } catch (e) {
      Logger().i('$error: $e');
    }
  }

  List<ChatMessage> _convertToChatMessages(List<MessageModel> messages) {
    final List<ChatMessage> chatMessages = messages.map((message) {
      return ChatMessage(
        user: message.senderId != authService.currentUser!.uid
            ? otherUser!
            : currentUser!,
        createdAt: DateTime.timestamp(),
        text: message.messageType == MessageType.text ? message.content : '',
        medias: message.messageType == MessageType.image
            ? [
                ChatMedia(
                  url: message.content,
                  fileName: '',
                  type: MediaType.image,
                )
              ]
            : message.messageType == MessageType.file
                ? [
                    ChatMedia(
                      url: message.content,
                      fileName: message.fileName ?? '',
                      type: MediaType.file,
                    )
                  ]
                : null,
      );
    }).toList();

    chatMessages.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return chatMessages;
  }

  Widget _selectImage() {
    return IconButton(
        enableFeedback: false,
        onPressed: () async {
          try {
            File? imageFile = await storageService.pickImageFromGallery();
            if (imageFile != null) {
              final String? downloadUrl =
                  await storageService.uploadImageInChat(
                uid1: authService.currentUser!.uid,
                uid2: widget.activeUser.uid,
                imageFile: imageFile,
              );
              if (downloadUrl != null) {
                final ChatMessage message = ChatMessage(
                  user: currentUser!,
                  createdAt: DateTime.now(),
                  medias: [
                    ChatMedia(
                      url: downloadUrl,
                      fileName: "",
                      type: MediaType.image,
                    ),
                  ],
                );

                _sendChatMessage(message);
              }
            } else {
              //user cancelled it
              alertService.showToast(text: "Seems you didn't pick any image");
            }
          } catch (e) {
            Logger().i('$error: $e');
          }
        },
        icon: const Icon(Icons.image));
  }

  Widget _selectFile() {
    return IconButton(
      onPressed: () async {
        try {
          final PlatformFile? pickedFile = await storageService.pickFile();
          if (pickedFile != null) {
            final String? downloadUrl = await storageService.uploadFileInChat(
              uid1: authService.currentUser!.uid,
              uid2: otherUser!.id,
              imageFile: pickedFile,
            );

            if (downloadUrl != null) {
              final ChatMessage fileMessage = ChatMessage(
                  user: currentUser!,
                  createdAt: DateTime.now(),
                  medias: [
                    ChatMedia(
                      url: downloadUrl,
                      fileName: pickedFile.name,
                      type: MediaType.file,
                    )
                  ]);

              _sendChatMessage(fileMessage);
            }
          } else {
            alertService.showToast(text: "You didn't pick any file though");
          }
        } catch (e) {
          Logger().i("$error: $e");
        }
      },
      icon: const Icon(Icons.file_present_outlined),
    );
  }

  Row _buildUserChatTitleWithPfp() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: widget.activeUser.pfp.isNotEmpty
              ? NetworkImage(widget.activeUser.pfp)
              : const NetworkImage(placeholderPfp),
        ),
        const SizedBox(width: 10),
        Text(
          widget.activeUser.name,
          style: const TextStyle(overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}
