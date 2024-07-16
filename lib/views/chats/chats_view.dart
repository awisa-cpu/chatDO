import 'package:chatdo/common/styles/custom_layout_view.dart';
import 'package:chatdo/common/widgets/custom_rounded_container.dart';
import 'package:chatdo/common/widgets/custom_user_tile.dart';
import 'package:chatdo/models/user_model.dart';
import 'package:chatdo/services/auth_services.dart';
import 'package:chatdo/services/database_services.dart';
import 'package:chatdo/services/navigation_services.dart';
import 'package:chatdo/setup.dart';
import 'package:chatdo/utils/app_colors.dart';
import 'package:chatdo/utils/strings.dart';
import 'package:chatdo/views/chats/user_chat_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logger/logger.dart';

class ChatsView extends StatelessWidget {
  const ChatsView(
      {super.key,
      required this.dbService,
      required this.authService,
      required this.navService});

  final DatabaseServices dbService;
  final AuthServices authService;
  final NavigationServices navService;

  @override
  Widget build(BuildContext context) {
    return _buildChatsViewBody(context);
  }

  Widget _buildChatsViewBody(BuildContext context) {
    return CustomLayoutView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildChatAppBar(context),
          const SizedBox(height: 15),

          _buildSearchBar(context),
          const SizedBox(height: 15),
          //
          StreamBuilder(
            stream: dbService.getChatsWithUsers(authService.currentUser!.uid),
            builder: (context, snapshot) {
              if (snapshot.hasError || !snapshot.hasData) {
                return Container();
              }

              if (snapshot.data != null) {
                final users = snapshot.data;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: users!.docs.length,
                  itemBuilder: (_, index) {
                    final activeUser = users.docs[index].data();
                    return CustomUserTile(
                      activeUser: activeUser,
                      onTap: () => _createOrOpenChat(activeUser),
                    );
                  },
                );
              }

              return const Center(
                child: SpinKitWanderingCubes(
                  size: 50,
                  shape: BoxShape.circle,
                  color: AppColors.appColorMain,
                  duration: Duration(milliseconds: 1000),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return CustomRoundedContainer(
      height: 53,
      width: osWidth(context),
      color: AppColors.appColorGreyOp,
      radius: 25,
      imageUrl: '',
      isImage: false,
      padding: const EdgeInsets.all(9),
      child: Row(
        children: [
          Icon(
            Icons.search,
            size: 30,
            color: AppColors.appColorGrey,
          ),
          const SizedBox(width: 5),
          Expanded(
            child: TextFormField(
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Search',
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildChatAppBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Messages',
          style: Theme.of(context)
              .textTheme
              .headlineLarge!
              .apply(fontWeightDelta: 2),
        ),

        //notification
        Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              Icons.mail_outline_rounded,
              size: 35,
              color: Colors.black.withOpacity(0.6),
            ),
            const Positioned(
              right: -5,
              top: -6,
              child: CustomRoundedContainer(
                height: 25,
                width: 25,
                color: Colors.blue,
                radius: 100,
                imageUrl: '',
                isImage: false,
                child: Center(
                  child: Text(
                    '2',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        )
      ],
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
