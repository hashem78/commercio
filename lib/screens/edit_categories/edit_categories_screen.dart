import 'package:commercio/models/product_category/product_category.dart';
import 'package:commercio/repositories/generic_repository.dart';
import 'package:commercio/router/router.dart';
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
      floatingActionButton: FloatingActionButton.extended(
        label: Row(
          children: [
            const Icon(Icons.add),
            Text(t.createCategoryFABText),
          ],
        ),
        onPressed: () {
          CreateCategoryRoute(shopId: shopId).push(context);
        },
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(t.title),
          ),
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

class EditCategoryListTile extends StatelessWidget {
  const EditCategoryListTile({
    super.key,
    required this.category,
    required this.shopId,
    this.showBorder = true,
  });

  final ProductCategory category;
  final String shopId;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: showBorder
          ? Border(
              bottom: BorderSide(
                color: Theme.of(context).hintColor,
              ),
            )
          : null,
      title: Text(category.category),
      trailing: IconButton(
        icon: const Icon(
          Icons.close,
          color: Colors.red,
        ),
        onPressed: () async {
          final db = FireStoreContext(
            collectionPath: '/shops/$shopId/categories',
          );
          await db.delete(category.id);
        },
      ),
    );
  }
}
