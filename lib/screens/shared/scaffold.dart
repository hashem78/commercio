import 'package:commercio/screens/shared/drawer/drawer.dart';
import 'package:commercio/state/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppBarSize {
  medium,
  large,
}

class SScaffold extends ConsumerWidget {
  const SScaffold({
    super.key,
    this.body,
    this.title,
    this.appBarSize,
  }) : _showDrawer = true;

  const SScaffold.drawerLess({
    super.key,
    this.body,
    this.title,
    this.appBarSize,
  }) : _showDrawer = false;

  final AppBarSize? appBarSize;
  final bool _showDrawer;
  final String? title;
  final Widget? body;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaffoldBody = CustomScrollView(
      slivers: [
        switch (appBarSize) {
          AppBarSize.medium => SliverAppBar.medium(title: Text(title ?? '')),
          AppBarSize.large => SliverAppBar(title: Text(title ?? '')),
          null => SliverAppBar(title: Text(title ?? '')),
        },
        SliverFillRemaining(
          child: body,
        ),
      ],
    );

    if (_showDrawer) {
      return Scaffold(
        drawer: SDrawer(user: ref.watch(authProvider)),
        body: scaffoldBody,
      );
    }
    return Scaffold(
      body: scaffoldBody,
    );
  }
}
