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
    required this.children,
    this.title,
    this.appBarSize,
    this.actions,
    this.floatingActionButton,
  }) : _showDrawer = true;

  const SScaffold.drawerLess({
    super.key,
    required this.children,
    this.title,
    this.appBarSize,
    this.actions,
    this.floatingActionButton,
  }) : _showDrawer = false;

  final AppBarSize? appBarSize;
  final bool _showDrawer;
  final Widget? title;
  final List<Widget>? actions;
  final List<Widget> children;
  final Widget? floatingActionButton;

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
        SliverList.builder(
          itemCount: children.length,
          itemBuilder: (context, index) => children[index],
        ),
      ],
    );

    if (_showDrawer) {
      return Scaffold(
        floatingActionButton: floatingActionButton,
        drawer: const SDrawer(),
        body: scaffoldBody,
      );
    }
    return Scaffold(
      floatingActionButton: floatingActionButton,
      body: scaffoldBody,
    );
  }
}
