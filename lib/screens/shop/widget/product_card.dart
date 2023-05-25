import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commercio/router/router.dart';
import 'package:commercio/screens/shared/utility_widgets.dart';
import 'package:commercio/state/editing/editing.dart';
import 'package:commercio/state/locale.dart';
import 'package:commercio/state/product_is_in_cart/product_is_in_cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:commercio/models/product/product.dart';
import 'package:commercio/models/product_entry/product_entry.dart';
import 'package:commercio/screens/shop/widget/product_like_button.dart';
import 'package:commercio/state/auth.dart';

class ProductCard extends ConsumerWidget {
  final SProduct product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isInCartAsyncValue = ref.watch(
      productIsInCartStreamProvider(product.id),
    );
    final isEditing = ref.watch(editingProvider);

    return isInCartAsyncValue.when(
      data: (isInCart) {
        return Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ProductCardTappableArea(
                product: product,
                showLikeButton: true,
              ),
              const Divider(),
              switch (isInCart) {
                true => RemoveFromCartButton(
                    productId: product.id,
                    productPrice: product.price,
                  ),
                false => AddToCartButton(
                    productId: product.id,
                    shopId: product.shopId,
                    productPrice: product.price,
                  ),
              },
              ...switch (isEditing) {
                true => [
                    EditProductButton(product: product),
                    DeleteProductButton(product: product)
                  ],
                false => [],
              }
            ],
          ),
        );
      },
      loading: () => loadingWidget(const Size(double.infinity, 200)),
      error: errorWidget,
    );
  }
}

class AddToCartButton extends ConsumerWidget {
  final String shopId;
  final String productId;
  final double productPrice;
  const AddToCartButton({
    super.key,
    required this.shopId,
    required this.productId,
    required this.productPrice,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authedUser = ref.watch(authStreamProvider).valueOrNull!;
    final t = ref.watch(translationProvider).translations.shop;

    return TextButton.icon(
      onPressed: () async {
        final db = FirebaseFirestore.instance;
        await db.runTransaction(
          (transaction) async {
            final userRef = db.doc('/users/${authedUser.uid}');
            final userCartProductEntryRef = db.doc(
              '/users/${authedUser.uid}/cart/$productId',
            );
            transaction.set(
              userRef,
              {
                'cartDetails': {
                  'itemCount': FieldValue.increment(1),
                  'totalPrice': FieldValue.increment(productPrice),
                },
              },
              SetOptions(merge: true),
            );
            transaction.set(
              userCartProductEntryRef,
              ProductEntry(id: productId, shopId: shopId).toJson(),
            );
          },
        );
      },
      icon: const FaIcon(FontAwesomeIcons.cartPlus),
      label: Text(t.addToCartButtonText),
    );
  }
}

class RemoveFromCartButton extends ConsumerWidget {
  final String productId;
  final double productPrice;
  const RemoveFromCartButton({
    super.key,
    required this.productId,
    required this.productPrice,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authedUser = ref.watch(authStreamProvider).valueOrNull!;
    final t = ref.watch(translationProvider).translations.shop;

    return TextButton.icon(
      onPressed: () async {
        final db = FirebaseFirestore.instance;
        await db.runTransaction(
          (transaction) async {
            final userRef = db.doc('/users/${authedUser.uid}');
            final userCartProductEntryRef = db.doc(
              '/users/${authedUser.uid}/cart/$productId',
            );
            transaction.set(
              userRef,
              {
                'cartDetails': {
                  'itemCount': FieldValue.increment(-1),
                  'totalPrice': FieldValue.increment(-productPrice),
                },
              },
              SetOptions(merge: true),
            );
            transaction.delete(userCartProductEntryRef);
          },
        );
      },
      icon: const FaIcon(
        FontAwesomeIcons.cartArrowDown,
        color: Colors.red,
      ),
      label: Text(
        t.removeFromCartButtonText,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}

class EditProductButton extends ConsumerWidget {
  final SProduct product;
  const EditProductButton({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationProvider).translations.shop;

    return TextButton.icon(
      onPressed: () {
        EditProductRoute(product).push(context);
      },
      icon: const Icon(Icons.edit),
      label: Text(t.editProductButtonText),
    );
  }
}

class DeleteProductButton extends ConsumerWidget {
  final SProduct product;
  const DeleteProductButton({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationProvider).translations.shop;

    return TextButton.icon(
      onPressed: () async {
        final db = FirebaseFirestore.instance;
        await db
            .doc('/shops/${product.shopId}/products/${product.id}')
            .delete();
      },
      icon: const Icon(Icons.delete, color: Colors.red),
      label: Text(
        t.deleteProductButtonText,
        style: const TextStyle(
          color: Colors.red,
        ),
      ),
    );
  }
}

class _ProductCardTappableArea extends StatelessWidget {
  const _ProductCardTappableArea({
    // ignore: unused_element
    super.key,
    required this.product,
    required this.showLikeButton,
  });

  final SProduct product;
  final bool showLikeButton;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 12.0,
        ),
        child: Row(
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(
                    product.pictures.first.link,
                  ),
                ),
              ),
            ),
            70.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: switch (showLikeButton) {
                      true => [
                          Expanded(
                            flex: 2,
                            child: Text(
                              product.name,
                              style: TextStyle(
                                fontSize: 45.sp,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Spacer(),
                          Expanded(
                            child: ProductLikeButton(product: product),
                          ),
                        ],
                      false => [
                          Text(
                            product.name,
                            style: TextStyle(
                              fontSize: 45.sp,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            product.likeCount.toString(),
                          ),
                        ]
                    },
                  ),
                  Text(
                    product.description,
                    maxLines: 3,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 35.sp,
                    ),
                  ),
                  Text(
                    product.price.toString(),
                    style: TextStyle(
                      fontSize: 35.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
