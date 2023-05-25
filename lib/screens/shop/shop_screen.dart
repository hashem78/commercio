import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:commercio/models/location/location.dart';
import 'package:commercio/models/product/product.dart';
import 'package:commercio/models/shop/shop.dart';
import 'package:commercio/router/router.dart';
import 'package:commercio/screens/shared/utility_widgets.dart';
import 'package:commercio/screens/shop/widget/product_card.dart';
import 'package:commercio/state/auth.dart';
import 'package:commercio/state/editing/editing.dart';
import 'package:commercio/state/locale.dart';
import 'package:commercio/state/shop/shop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ShopScreen extends HookConsumerWidget {
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
    final t = ref.watch(translationProvider).translations;
    final isMounted = useIsMounted();

    return shopAsyncValue.when(
      data: (shop) {
        return Scaffold(
          floatingActionButton: switch (isEditing) {
            true => FloatingActionButton.extended(
                onPressed: () => AddProductRoute(shopId).push(context),
                label: Row(
                  children: [
                    const Icon(Icons.add),
                    Text(t.shop.addProductFABTitle),
                  ],
                ),
              ),
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
                    EditingIconButton(
                      onEditingComplete: () {
                        return true;
                      },
                    ),
                  if (isEditing)
                    TextButton(
                      onPressed: () async {
                        final func = FirebaseFunctions.instance;
                        await func.httpsCallable('deleteShop').call({
                          'shopId': shop.id,
                        });
                        // ignore: use_build_context_synchronously
                        if (isMounted()) context.pop();
                      },
                      child: Text(
                        t.shop.deleteIconButtonText,
                        style: const TextStyle(color: Colors.red),
                      ),
                    )
                ],
              ),
              SliverToBoxAdapter(
                child: ShopOwnerCard(shop: shop),
              ),
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

class ShopOwnerCard extends HookConsumerWidget {
  final SShop shop;
  const ShopOwnerCard({
    super.key,
    required this.shop,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final owner = ref.watch(userStreamProvider(shop.ownerId));
    final isEditing = ref.watch(editingProvider);
    final locationText = useState(shop.location?.address);
    final t = ref.watch(translationProvider).translations.general;

    return owner.when(
      data: (owner) {
        return Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: CircleAvatar(
                  foregroundImage: CachedNetworkImageProvider(
                    owner.profilePicture.link,
                  ),
                ),
                onTap: () {
                  ProfileRoute(userId: owner.id).push(context);
                },
                title: Text(owner.name),
              ),
              const Divider(),
              ListTile(
                title: Text(t.location),
                subtitle: switch (locationText.value) {
                  null => null,
                  _ => Text(locationText.value!),
                },
                onTap: switch (isEditing) {
                  true => () async {
                      final location =
                          await PickLocationRoute($extra: shop.location)
                              .push<SLocation>(context);

                      if (location == null) return;

                      locationText.value = location.address;

                      final db = FirebaseFirestore.instance;
                      await db
                          .doc('/shops/${shop.id}')
                          .update({'location': location.toJson()});
                    },
                  false => switch (shop.location) {
                      null => null,
                      _ => () {
                          if (shop.location == null) return;
                          LocationRoute($extra: shop.location!).push(context);
                        },
                    }
                },
              ),
            ],
          ),
        );
      },
      loading: () => loadingWidget(Size(double.infinity, 0.3.sh)),
      error: errorWidget,
    );
  }
}
