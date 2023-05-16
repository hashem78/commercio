import 'package:commercio/screens/shared/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShopScreen extends ConsumerWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const SScaffold.drawerLess(
      title: Text(''),
      children: [],
    );
  }
}
