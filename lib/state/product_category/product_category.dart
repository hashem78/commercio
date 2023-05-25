import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commercio/models/product_category/product_category.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_category.g.dart';

@riverpod
Stream<List<ProductCategory>> productCategoryStream(
  ProductCategoryStreamRef ref,
  String shopId,
) async* {
  final db = FirebaseFirestore.instance;
  final stream = db
      .collection('/shops/$shopId/categories')
      .withConverter(
        fromFirestore: (json, _) => ProductCategory.fromJson(json.data()!),
        toFirestore: (cat, _) => cat.toJson(),
      )
      .snapshots();

  final categories = <ProductCategory>[];
  await for (final snapshot in stream) {
    categories.clear();
    final documents = snapshot.docs;
    for (final doc in documents) {
      final category = doc.data();
      categories.add(category);
    }
    yield categories;
  }
}
