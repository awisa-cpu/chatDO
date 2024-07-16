import 'package:chatdo/services/auth_services.dart';
import 'package:chatdo/services/database_services.dart';
import 'package:chatdo/setup.dart';
import 'package:chatdo/utils/extensions/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class UserStatusView extends StatelessWidget {
  const UserStatusView({
    super.key,
    required this.dbService,
    required this.authService,
  });

  final DatabaseServices dbService;
  final AuthServices authService;

  //
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: osHeight(context) * 0.10,
      child: FutureBuilder(
        future: dbService.getUsers(authService.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            final users = snapshot.data;

            return ListView.separated(
              itemCount: users!.docs.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final user = users.docs[index].data();

                return Column(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      child: CircleAvatar(
                        radius: 27,
                        backgroundImage: NetworkImage(user.pfp),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(user.name.getInitialCharacters())
                  ],
                );
              },
              separatorBuilder: (_, __) => const SizedBox(
                width: 6.5,
              ),
            );
          }
          //todo: handle the shimmer to display properly
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, index) => CircleAvatar(
                      backgroundColor: Colors.grey.shade300,
                      radius: 30,
                    ),
                separatorBuilder: (_, index) => const SizedBox(
                      width: 6,
                    ),
                itemCount: 5),
          );
        },
      ),
    );
  }
}
