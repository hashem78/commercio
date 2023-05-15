import 'package:commercio/screens/shared/drawer/drawer_destinations.dart';

import 'package:commercio/screens/shared/drawer/widgets/user_accounts_drawer_header.dart';
import 'package:commercio/state/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'drawer.g.dart';

@Riverpod(keepAlive: true)
class DrawerIndex extends _$DrawerIndex {
  @override
  int build() => 0;
  void change(int newIndex) => state = newIndex;
}

class SDrawer extends ConsumerWidget {
  const SDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(drawerIndexProvider);
    final destinations = ref.watch(drawerDestinationsProvider);
    final user = ref.watch(authStreamProvider).value!;

    return NavigationDrawer(
      onDestinationSelected: (index) {
        if (selectedIndex == index) return;
        final drawerIndexNotifier = ref.read(drawerIndexProvider.notifier);
        drawerIndexNotifier.change(index);
        context.goNamed(destinations[index].routeName);
      },
      selectedIndex: selectedIndex,
      children: [
        SUserAccountsDrawerHeader(userId: user.uid),
        ...destinations.map((e) => e),
      ],
    );
  }
}
