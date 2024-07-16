import 'package:chatdo/services/auth_services.dart';
import 'package:chatdo/services/database_services.dart';
import 'package:chatdo/services/navigation_services.dart';
import 'package:flutter/material.dart';

import '../../common/widgets/custom_async_loader.dart';
import 'user_info_home_view.dart';

class AllUsersHomeView extends StatelessWidget {
  const AllUsersHomeView({
    super.key,
    required this.dbService,
    required this.currentUserId,
    required this.authService,
    required this.navService,
  });
  final DatabaseServices dbService;
  final AuthServices authService;
  final NavigationServices navService;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: dbService.getUsers(
        currentUserId,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CustomAsyncLoader(loadingText: 'Fetching users ');
        }

        //
        if (snapshot.data != null &&
            (snapshot.data?.docs.isNotEmpty ?? false)) {
          final users = snapshot.data!.docs;

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index].data();
              return UserInfoHomeView(
                user: user,
                authService: authService,
                dbService: dbService,
                navService: navService,
              );
            },
            separatorBuilder: (_, __) => const SizedBox(
              height: 12,
            ),
          );
        }

        return Container();
      },
    );
  }
}
