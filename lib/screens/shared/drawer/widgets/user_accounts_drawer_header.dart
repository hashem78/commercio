import 'package:cached_network_image/cached_network_image.dart';
import 'package:commercio/router/route_names.dart';
import 'package:commercio/router/router.dart';
import 'package:commercio/screens/shared/utility_widgets.dart';
import 'package:commercio/state/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SUserAccountsDrawerHeader extends ConsumerWidget {
  final String userId;
  const SUserAccountsDrawerHeader({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userStreamProvider(userId));

    return user.when(
      data: (user) {
        return GestureDetector(
          onTap: () {
            final currentLocationName = GoRouterState.of(context).name;
            if (currentLocationName == kProfileRouteName) return;
            ProfileRoute(userId: user.id).push(context);
          },
          child: UserAccountsDrawerHeader(
            accountEmail: Text(user.email),
            accountName: Text(user.name),
            currentAccountPicture: CircleAvatar(
              foregroundImage:
                  CachedNetworkImageProvider(user.profilePicture.link),
            ),
          ),
        );
      },
      error: errorWidget,
      loading: () => loadingWidget(const Size(double.infinity, 150)),
    );
  }
}
