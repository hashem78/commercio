import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commercio/models/product/product.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product.g.dart';

@riverpod
Stream<SProduct> productStream(
  ProductStreamRef ref,
  String shopId,
  String productId,
) async* {
  final db = FirebaseFirestore.instance;

  final snapshots = db
      .doc('/shops/$shopId/products/$productId')
      .withConverter(
        fromFirestore: (json, _) => SProduct.fromJson(json.data()!),
        toFirestore: (product, _) => product.toJson(),
      )
      .snapshots();
  await for (final snapshot in snapshots) {
    if (!snapshot.exists) continue;

    yield snapshot.data()!;
  }
}
