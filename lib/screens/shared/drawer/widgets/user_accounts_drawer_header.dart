import 'package:cached_network_image/cached_network_image.dart';
import 'package:commercio/models/user/user_model.dart';
import 'package:flutter/material.dart';

class SUserAccountsDrawerHeader extends StatelessWidget {
  const SUserAccountsDrawerHeader({
    super.key,
    required this.user,
  });

  final SUser user;

  @override
  Widget build(BuildContext context) {
    return UserAccountsDrawerHeader(
      accountEmail: Text(user.email),
      accountName: Text(user.name),
      currentAccountPicture: CircleAvatar(
        foregroundImage: CachedNetworkImageProvider(user.profilePicture.link),
      ),
    );
  }
}
