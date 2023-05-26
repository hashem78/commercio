import 'package:commercio/router/router.dart';
import 'package:commercio/state/locale.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ShopScreenFAB extends HookConsumerWidget {
  const ShopScreenFAB({
    super.key,
    required this.shopId,
  });
  final String shopId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationProvider).translations;

    return FloatingActionButton.extended(
      onPressed: () => AddProductRoute(shopId).push(context),
      label: Row(
        children: [
          const Icon(Icons.add),
          Text(t.shop.addProductFABTitle),
        ],
      ),
    );
  }
}
