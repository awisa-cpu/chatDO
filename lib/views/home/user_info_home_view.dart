import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatdo/models/user_model.dart';
import 'package:chatdo/services/auth_services.dart';
import 'package:chatdo/services/database_services.dart';
import 'package:chatdo/services/navigation_services.dart';
import 'package:chatdo/utils/app_colors.dart';
import 'package:chatdo/utils/strings.dart';
import 'package:chatdo/views/chats/user_chat_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logger/logger.dart';

class UserInfoHomeView extends StatelessWidget {
  const UserInfoHomeView(
      {super.key,
      required this.user,
      required this.dbService,
      required this.authService,
      required this.navService});
  final UserModel user;
  final DatabaseServices dbService;
  final AuthServices authService;
  final NavigationServices navService;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: false,
      leading: Container(
        height: 60,
        width: 55,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(200),
          child: CachedNetworkImage(
            imageUrl: user.pfp,
            placeholder: (context, url) => SpinKitFadingCircle(
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            errorWidget: (_, __, ___) => const Icon(Icons.person),
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(user.name),
      trailing: IconButton(
        enableFeedback: false,
        onPressed: () => _createOrOpenChat(user),
        icon: Icon(
          Icons.message,
          color: AppColors.appColorMain.withOpacity(0.5),
        ),
      ),
    );
  }

  Future<bool> _checkIfChatExistOrNot(UserModel activeUser) async {
    try {
      final bool response = await dbService.checkIfChatExists(
        uid1: authService.currentUser!.uid,
        uid2: activeUser.uid,
      );
      return response;
    } catch (e) {
      Logger().i('$error: $e');
    }
    return false;
  }

  void _createOrOpenChat(UserModel activeUser) async {
    try {
      final bool response = await _checkIfChatExistOrNot(activeUser);
      //if no chat exist then create a new chat otherwise navigative to the chat page
      if (!response) {
        await dbService.createNewChat(
          signInUserId: authService.currentUser!.uid,
          otherUserId: activeUser.uid,
        );
      } else {
        navService.pushRoute(
          MaterialPageRoute(
            builder: (context) => UserChatView(activeUser: activeUser),
          ),
        );
      }
    } catch (e) {
      Logger().i("$error: $e");
    }
  }
}
