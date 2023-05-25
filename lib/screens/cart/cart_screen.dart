import 'package:commercio/models/location/location.dart';
import 'package:commercio/models/product_entry/product_entry.dart';
import 'package:commercio/router/router.dart';
import 'package:commercio/screens/shared/drawer/drawer.dart';
import 'package:commercio/screens/shared/utility_widgets.dart';
import 'package:commercio/screens/shop/widget/product_card.dart';
import 'package:commercio/state/auth.dart';
import 'package:commercio/state/locale.dart';
import 'package:commercio/state/product/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../state/cart_details/cart_details.dart';

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

class ContinuePurchaseCard extends HookConsumerWidget {
  final String uid;
  const ContinuePurchaseCard({
    super.key,
    required this.uid,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartDetailsAsyncValue = ref.watch(cartDetailsStreamProvider);
    final t = ref.watch(translationProvider).translations.cart;
    final isMounted = useIsMounted();
    return cartDetailsAsyncValue.when(
      data: (details) {
        if (details.itemCount == 0) return const SizedBox();
        return Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                leading: const FaIcon(FontAwesomeIcons.bagShopping),
                title: Text('${details.itemCount} items'),
              ),
              ListTile(
                leading: const Icon(Icons.money),
                title: Text('JOD ${details.totalPrice.toStringAsFixed(2)}'),
              ),
              const Divider(),
              TextButton(
                onPressed: () async {
                  final location =
                      await PickDeliveryLocationRoute().push<SLocation?>(
                    context,
                  );
                  if (location == null) {
                    if (!isMounted()) return;

                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                      const SnackBar(
                        content: Text(
                          'You need to pick a location!',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    );
                    return;
                  }

                  if (!isMounted()) return;

                  // ignore: use_build_context_synchronously
                  await LoadingRoute(
                    $extra: const Duration(seconds: 1),
                  ).push(context);

                  if (!isMounted()) return;

                  // ignore: use_build_context_synchronously
                  await PurchaseCompleteRoute((
                    uid: uid,
                    location: location,
                  )).push(context);
                },
                child: Text(t.continueButtonText),
              ),
            ],
          ),
        );
      },
      error: errorWidget,
      loading: () => loadingWidget(const Size(double.infinity, 75)),
    );
  }
}
