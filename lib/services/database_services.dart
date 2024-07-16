import 'dart:async';

import 'package:chatdo/models/chat_model.dart';
import 'package:chatdo/models/message_model.dart';
import 'package:chatdo/models/user_model.dart';
import 'package:chatdo/setup.dart';
import 'package:chatdo/utils/strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class DatabaseServices {
  DatabaseServices() {
    _setupDb();
  }

  final FirebaseFirestore databaseInstance = FirebaseFirestore.instance;
  CollectionReference? usersCollection;
  CollectionReference? chatsCollection;
  UserModel? _activeUser;
  UserModel? get activeUser => _activeUser;

  void _setupDb() {
    usersCollection = databaseInstance
        .collection('Users')
        .withConverter<UserModel>(
          fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
          toFirestore: (user, _) => user.toJson(),
        );

    chatsCollection = databaseInstance
        .collection("Chats")
        .withConverter<ChatModel>(
          fromFirestore: (snapshot, _) => ChatModel.fromJson(snapshot.data()!),
          toFirestore: (model, _) => model.toJson(),
        );
  }

  Future<void> createUser(UserModel newUser) async {
    try {
      await usersCollection?.doc(newUser.uid).set(newUser);
    } catch (e) {
      rethrow;
    }
  }

  Stream<QuerySnapshot<UserModel>> getUsersWith(String currentUserId) {
    try {
      final usersStream = usersCollection
          ?.where('uid', isNotEqualTo: currentUserId)
          .snapshots() as Stream<QuerySnapshot<UserModel>>;

      return usersStream;
    } catch (e) {
      Logger().i("$error:$e ");
      rethrow;
    }
  }

/*
  // Future<Stream<QuerySnapshot<UserModel>>> getChatPartipants(String currentUserId) async {
  //   final controller = StreamController<QuerySnapshot<UserModel>>();
  //   try {
  //     final chatQuerySnapshots = await chatsCollection
  //         ?.where('participantIds', arrayContains: currentUserId)
  //         .get();
  //     final chatDocSnasphots = chatQuerySnapshots?.docs;
  //     final userChats =
  //         chatDocSnasphots as List<QueryDocumentSnapshot<ChatModel>>;

  //     final values = userChats
  //         .map((chat) => chat
  //             .data()
  //             .participantIds
  //             ?.firstWhere((chatdId) => chatdId != currentUserId))
  //         .toList();

  //   final userStream =  usersCollection?.where('uid', whereIn: values).snapshots() as Stream<QuerySnapshot<UserModel>>;
  // await for (var snapshot in userStream) {
  //         controller.add(snapshot);
  //       }
    
  //   } catch (e) {
  //     Logger().i('$error: $e');
  //     controller.addError(e);
  //     rethrow;
  //   }finally {
  //       await controller.close();
  //     }
  // }
*/
  Stream<QuerySnapshot<UserModel>> getChatsWithUsers(String currentUserId) {
    final controller = StreamController<QuerySnapshot<UserModel>>();
    (() async {
      try {
        final chatQuerySnapshots = await chatsCollection
            ?.where('participantIds', arrayContains: currentUserId)
            .get();

        final chatDocSnapshots = chatQuerySnapshots?.docs;
        final userChats =
            chatDocSnapshots as List<QueryDocumentSnapshot<ChatModel>>;

        final values = userChats
            .map((chat) => chat
                .data()
                .participantIds
                ?.firstWhere((chatId) => chatId != currentUserId))
            .toList();

        final userStream = usersCollection
            ?.where('uid', whereIn: values)
            .snapshots() as Stream<QuerySnapshot<UserModel>>;

        await for (var snapshot in userStream) {
          controller.add(snapshot);
        }
      } catch (e) {
        Logger().i('Error: $e');
        controller.addError(e);
      } finally {
        await controller.close();
      }
    })();

    return controller.stream;
  }

  Future<QuerySnapshot<UserModel>> getUsers(String currentUserId) async {
    try {
      return usersCollection?.where('uid', isNotEqualTo: currentUserId).get()
          as Future<QuerySnapshot<UserModel>>;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> checkIfChatExists({
    required String uid1,
    required String uid2,
  }) async {
    try {
      String chatId = generateChatId(uid1: uid1, uid2: uid2);

      final docRef = await chatsCollection?.doc(chatId).get();

      if (docRef?.exists ?? false) {
        return true;
      }
    } catch (e) {
      rethrow;
    }

    return false;
  }

  Future<void> createNewChat({
    required String signInUserId,
    required String otherUserId,
  }) async {
    try {
      final String uids = generateChatId(uid1: signInUserId, uid2: otherUserId);
      final ChatModel newChat = ChatModel(
        id: uids,
        participantIds: [signInUserId, otherUserId],
        messages: [],
      );

      await chatsCollection?.doc(newChat.id).set(newChat);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateChatMessage({
    required String uid1,
    required String uid2,
    required MessageModel message,
  }) async {
    try {
      final String chatId = generateChatId(uid1: uid1, uid2: uid2);
      final chatReference = chatsCollection?.doc(chatId);
      await chatReference?.update({
        "messages": FieldValue.arrayUnion([message.toJson()])
      });
    } catch (e) {
      rethrow;
    }
  }

  Stream<DocumentSnapshot<ChatModel>> readChatMessages({
    required String uid1,
    required String uid2,
  }) {
    try {
      final String chatId = generateChatId(uid1: uid1, uid2: uid2);
      return chatsCollection?.doc(chatId).snapshots()
          as Stream<DocumentSnapshot<ChatModel>>;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getCurrentUser(String uid) async {
    try {
      final userQuery =
          await usersCollection?.doc(uid).get() as DocumentSnapshot<UserModel>;
      _activeUser = userQuery.data();
    } catch (e) {
      rethrow;
    }
  }
}
