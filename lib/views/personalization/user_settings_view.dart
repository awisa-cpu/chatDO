import 'package:chatdo/common/styles/custom_layout_view.dart';
import 'package:chatdo/models/user_model.dart';
import 'package:chatdo/services/auth_services.dart';
import 'package:chatdo/services/database_services.dart';
import 'package:chatdo/services/navigation_services.dart';
import 'package:chatdo/setup.dart';
import 'package:chatdo/utils/constants.dart';
import 'package:chatdo/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../common/styles/custom_list_tile.dart';

class UserSettingsView extends StatefulWidget {
  const UserSettingsView({
    super.key,
    required this.dbService,
    required this.authService,
    required this.navService,
  });
  final DatabaseServices dbService;
  final AuthServices authService;
  final NavigationServices navService;

  @override
  State<UserSettingsView> createState() => _UserSettingsViewState();
}

class _UserSettingsViewState extends State<UserSettingsView> {
  UserModel? user;
  bool isDarkMode = false;
  @override
  void initState() {
    super.initState();
    try {
      user = widget.dbService.activeUser;
    } catch (e) {
      Logger().i('$error : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomLayoutView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: Theme.of(context)
                .textTheme
                .headlineLarge!
                .apply(fontWeightDelta: 2),
          ),

          const SizedBox(height: 10),
          //section : Profile
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(user?.pfp ?? placeholderPfp),
                  onBackgroundImageError: (exception, stackTrace) =>
                      const Icon(Icons.info),
                ),
                const SizedBox(height: 10),
                TextButton(
                    style: const ButtonStyle(enableFeedback: false),
                    onPressed: () {},
                    child: Text(
                      'Upload image',
                      style: Theme.of(context).textTheme.bodyLarge!.apply(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    )),
              ],
            ),
          ),

          //section 2: account
          const SizedBox(height: 30),

          Text(
            'Account',
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .apply(fontWeightDelta: 2),
          ),

          CustomListTile(
            icon: const Icon(
              Icons.person,
              color: Colors.grey,
            ),
            mainText: user?.name ?? '',
            subText: 'Personal Info',
            iconBgColor: Colors.grey.shade300,
            onTap: () {},
          ),

          //app settings
          const SizedBox(height: 30),
          Text(
            'Settings ',
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .apply(fontWeightDelta: 2),
          ),
          const SizedBox(height: 10),

          CustomListTile(
            icon: Icon(
              Icons.notifications,
              color: Colors.blue.shade300,
            ),
            mainText: 'Notifications',
            iconBgColor: Colors.blue.shade100,
            onTap: () {},
          ),
          CustomListTile(
            icon: const Icon(
              Icons.bedtime,
              color: Colors.blue,
            ),
            mainText: 'Dark Mode',
            iconBgColor: Colors.blue.shade50,
            showTrailing: false,
            child: Switch(
                inactiveTrackColor: Colors.grey.withOpacity(0.5),
                value: isDarkMode,
                onChanged: (value) {
                  setState(() {
                    isDarkMode = value;
                  });
                }),
            onTap: () {},
          ),
          CustomListTile(
            icon: const Icon(
              Icons.support,
              color: Colors.pink,
            ),
            mainText: 'Help',
            iconBgColor: Colors.pink.shade50,
            onTap: () {},
          ),

          SizedBox(height: osHeight(context) * 0.08),

          //logout
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _logoutUser,
              child: const Text('Logout'),
            ),
          )
        ],
      )),
    );
  }

  void _logoutUser() async {
    try {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              style: TextButton.styleFrom(enableFeedback: false),
              onPressed: widget.navService.goBack,
              child: const Text('No'),
            ),
            TextButton(
              style: TextButton.styleFrom(enableFeedback: false),
              onPressed: () async {
                await widget.authService.logoutUser();
                widget.navService.pushNamedAndReplace('/login');
              },
              child: const Text('Yes'),
            ),
          ],
        ),
      );
    } catch (e) {
      Logger().i('$error: $e');
    }
  }
}
