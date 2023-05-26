import 'package:commercio/router/router.dart';
import 'package:commercio/state/locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditCategoriesScreenFAB extends ConsumerWidget {
  const EditCategoriesScreenFAB({
    super.key,
    required this.shopId,
  });

  final String shopId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationProvider).translations.editCategories;
    return FloatingActionButton.extended(
      icon: const Icon(Icons.add),
      label: Text(t.createCategoryFABText),
      onPressed: () {
        CreateCategoryRoute(shopId: shopId).push(context);
      },
    );
  }
}
