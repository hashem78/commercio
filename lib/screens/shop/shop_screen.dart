import 'package:commercio/models/product/product.dart';
import 'package:commercio/screens/shared/utility_widgets.dart';
import 'package:commercio/screens/shop/widget/delete_shop_text_button.dart';
import 'package:commercio/screens/shop/widget/product_card.dart';
import 'package:commercio/screens/shop/widget/shop_owner_card.dart';
import 'package:commercio/screens/shop/widget/shop_screen_fab.dart';
import 'package:commercio/state/editing/editing.dart';
import 'package:commercio/state/shop/shop.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ShopScreen extends ConsumerWidget {
  const ShopScreen({
    super.key,
    required this.shopId,
    required this.allowEditing,
  });

  final String shopId;
  final bool allowEditing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shopAsyncValue = ref.watch(shopStreamProvider(shopId));
    final isEditing = ref.watch(editingProvider);

    return shopAsyncValue.when(
      data: (shop) {
        return Scaffold(
          floatingActionButton: switch (isEditing) {
            true => ShopScreenFAB(shopId: shopId),
            false => null,
          },
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                title: shopAsyncValue.when(
                  data: (shop) => Text(shop.name),
                  error: errorWidget,
                  loading: loadingWidget,
                ),
                actions: [
                  if (allowEditing)
                    EditingIconButton(onEditingComplete: () => true),
                  if (isEditing) DeleteShopTextButton(shopId: shopId)
                ],
              ),
              SliverToBoxAdapter(child: ShopOwnerCard(shop: shop)),
              FirestoreSliverList<SProduct>(
                collectionPath: '/shops/$shopId/products',
                fromJson: SProduct.fromJson,
                builder: (_, index, entities) => ProductCard(
                  product: entities[index],
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: errorWidget,
    );
  }
}
