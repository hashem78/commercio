import 'package:commercio/screens/shared/drawer/drawer.dart';
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
    this.actions,
  }) : _showDrawer = true;

  const SScaffold.drawerLess({
    super.key,
    this.body,
    this.title,
    this.appBarSize,
    this.actions,
  }) : _showDrawer = false;

  final AppBarSize? appBarSize;
  final bool _showDrawer;
  final Widget? title;
  final Widget? body;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appBarTitle = title ?? const Text('');
    final scaffoldBody = CustomScrollView(
      slivers: [
        switch (appBarSize) {
          AppBarSize.medium => SliverAppBar.medium(
              title: appBarTitle,
              actions: actions,
            ),
          AppBarSize.large => SliverAppBar.large(
              title: appBarTitle,
              actions: actions,
            ),
          null => SliverAppBar(
              title: appBarTitle,
              actions: actions,
            ),
        },
        SliverToBoxAdapter(
          child: body,
        ),
      ],
    );

    if (_showDrawer) {
      return Scaffold(
        drawer: const SDrawer(),
        body: scaffoldBody,
      );
    }
    return Scaffold(
      body: scaffoldBody,
    );
  }
}
