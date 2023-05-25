import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commercio/models/product_entry/product_entry.dart';
import 'package:commercio/state/auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_is_in_cart.g.dart';

@riverpod
Stream<bool> productIsInCartStream(
  ProductIsInCartStreamRef ref,
  String productId,
) async* {
  final db = FirebaseFirestore.instance;

  final user = await ref.watch(authStreamProvider.future);
  if (user == null) return;

  final likedDocSnapshots = db
      .collection('/users/${user.uid}/cart')
      .withConverter(
        fromFirestore: (json, _) => ProductEntry.fromJson(json.data()!),
        toFirestore: (product, _) => product.toJson(),
      )
      .doc(productId)
      .snapshots();

  await for (final likedDocSnapshot in likedDocSnapshots) {
    yield likedDocSnapshot.exists;
  }
}
