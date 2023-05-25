import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commercio/models/product_entry/product_entry.dart';
import 'package:commercio/models/product/product.dart';
import 'package:commercio/screens/shared/utility_widgets.dart';
import 'package:commercio/state/auth.dart';
import 'package:commercio/state/product_is_liked/product_is_liked.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:like_button/like_button.dart';

class ProductLikeButton extends ConsumerWidget {
  final SProduct product;
  const ProductLikeButton({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLikedStream = ref.watch(productIsLikedStreamProvider(product.id));
    return isLikedStream.when(
      data: (isLiked) {
        return LikeButton(
          likeCount: product.likeCount,
          isLiked: isLiked,
          onTap: (isLiked) async {
            final authedUser = ref.read(authStreamProvider).valueOrNull!;

            final db = FirebaseFirestore.instance;

            return await db.runTransaction<bool>(
              (transaction) async {
                final likedRef = db.doc(
                  '/users/${authedUser.uid}/likedProducts/${product.id}',
                );
                final productRef = db.doc(
                  '/shops/${product.shopId}/products/${product.id}',
                );

                if (!isLiked) {
                  transaction.set(
                    likedRef,
                    ProductEntry(
                      id: product.id,
                      shopId: product.shopId,
                    ).toJson(),
                  );
                  transaction.update(productRef, {
                    'likeCount': FieldValue.increment(1),
                  });
                  return true;
                } else {
                  transaction.delete(likedRef);
                  transaction.update(productRef, {
                    'likeCount': FieldValue.increment(-1),
                  });
                  return false;
                }
              },
            );
          },
        );
      },
      error: errorWidget,
      loading: loadingWidget,
    );
  }
}
