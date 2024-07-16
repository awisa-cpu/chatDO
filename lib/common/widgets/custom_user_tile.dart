import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatdo/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomUserTile extends StatelessWidget {
  const CustomUserTile({
    super.key,
    required this.activeUser,
    required this.onTap,
  });

  final UserModel activeUser;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      enableFeedback: false,
      splashColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(horizontal: 5),
      onTap: onTap,
      dense: false,
      leading: Container(
        height: 60,
        width: 55,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(200),
          child: CachedNetworkImage(
            imageUrl: activeUser.pfp,
            placeholder: (context, url) => SpinKitFadingCircle(
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            errorWidget: (_, __, ___) => const Icon(Icons.person),
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(activeUser.name),
      subtitle: Text(activeUser.email),
      isThreeLine: true,
    );
  }
}
