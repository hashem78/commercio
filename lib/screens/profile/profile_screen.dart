import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:commercio/screens/shared/scaffold.dart';
import 'package:commercio/screens/shared/utility_widgets.dart';
import 'package:commercio/state/user/user_provider.dart';

class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsyncValue = ref.watch(userProvider(userId: userId));

    final user = userAsyncValue.maybeWhen(
      data: (user) => user,
      orElse: () => null,
    );
    final userName = userAsyncValue.when(
      data: (user) => Text(
        '${user.name}\'s Profile',
        style: Theme.of(context).textTheme.titleMedium,
      ).animate().fadeIn(),
      error: errorWidget,
      loading: loadingWidget,
    );

    return SScaffold.drawerLess(
      title: userName,
      actions: [
        EditingIconButton(
          onEditingComplete: () {
            if (user == null) return false;
            return true;
          },
        ),
      ],
      body: SingleChildScrollView(
        child: Column(
          children: [
            UserAvatar(
              size: 0.35.sw,
            ),
            userName,
          ],
        ),
      ),
    );
  }
}
