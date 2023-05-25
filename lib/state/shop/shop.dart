import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commercio/models/shop/shop.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'shop.g.dart';

@riverpod
class ShopStream extends _$ShopStream {
  @override
  Stream<SShop> build(String shopId) async* {
    final db = FirebaseFirestore.instance;

    final stream = db
        .collection('/shops')
        .withConverter<SShop>(
            fromFirestore: (json, _) => SShop.fromJson(json.data()!),
            toFirestore: (shop, _) => shop.toJson())
        .doc(shopId)
        .snapshots();

    await for (final event in stream) {
      if (!event.exists) continue;
      yield event.data()!;
    }
  }
}
