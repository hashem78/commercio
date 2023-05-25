import 'package:commercio/models/product_entry/product_entry.dart';
import 'package:commercio/screens/shared/drawer/drawer.dart';
import 'package:commercio/screens/shared/utility_widgets.dart';
import 'package:commercio/screens/shop/widget/product_card.dart';
import 'package:commercio/state/auth.dart';
import 'package:commercio/state/locale.dart';
import 'package:commercio/state/product/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LikedProductsScreen extends ConsumerWidget {
  const LikedProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authedUser = ref.watch(authStreamProvider).valueOrNull!;
    final t2 = ref.watch(translationProvider).translations.likedProducts;

    return Scaffold(
      drawer: const SDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: Text(t2.title),
          ),
          FirestoreSliverList(
            collectionPath: '/users/${authedUser.uid}/likedProducts',
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
        ],
      ),
    );
  }
}
