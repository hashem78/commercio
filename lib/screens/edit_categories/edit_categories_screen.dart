import 'package:commercio/models/product_category/product_category.dart';
import 'package:commercio/screens/edit_categories/widgets/edit_categories_list_tile.dart';
import 'package:commercio/screens/edit_categories/widgets/edit_categories_screen_fab.dart';
import 'package:commercio/screens/shared/utility_widgets.dart';
import 'package:commercio/state/locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditCategoriesScreen extends ConsumerWidget {
  const EditCategoriesScreen({
    super.key,
    required this.shopId,
  });

  final String shopId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationProvider).translations.editCategories;

    return Scaffold(
      floatingActionButton: EditCategoriesScreenFAB(shopId: shopId),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(title: Text(t.title)),
          FirestoreSliverList<ProductCategory>(
            collectionPath: '/shops/$shopId/categories',
            fromJson: ProductCategory.fromJson,
            builder: (_, index, entities) {
              return EditCategoryListTile(
                category: entities[index],
                shopId: shopId,
                showBorder: index != entities.length - 1,
              );
            },
          ),
        ],
      ),
    );
  }
}
