import 'package:commercio/models/product_entry/product_entry.dart';
import 'package:commercio/screens/cart/widgets/continue_purchase_card.dart';
import 'package:commercio/screens/shared/drawer/drawer.dart';
import 'package:commercio/screens/shared/utility_widgets.dart';
import 'package:commercio/screens/shop/widget/product_card.dart';
import 'package:commercio/state/auth.dart';
import 'package:commercio/state/locale.dart';
import 'package:commercio/state/product/product.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CartScreen extends ConsumerWidget {
  final bool showDrawer;
  const CartScreen({
    super.key,
    required this.showDrawer,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authedUser = ref.watch(authStreamProvider).valueOrNull!;
    final t = ref.watch(translationProvider).translations.cart;

    return Scaffold(
      drawer: showDrawer ? const SDrawer() : null,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(title: Text(t.title)),
          FirestoreSliverList(
            collectionPath: '/users/${authedUser.uid}/cart',
            fromJson: ProductEntry.fromJson,
            builder: (_, index, entities) {
              final entity = entities[index];
              return Consumer(
                builder: (context, ref, child) {
                  final productAsyncValue = ref.watch(
                    productStreamProvider(entity.shopId, entity.id),
                  );
                  return productAsyncValue.when(
                    data: (product) => ProductCard(
                      product: product,
                    ),
                    error: errorWidget,
                    loading: () => loadingWidget(
                      const Size(double.infinity, 200),
                    ),
                  );
                },
              );
            },
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ContinuePurchaseCard(uid: authedUser.uid),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
