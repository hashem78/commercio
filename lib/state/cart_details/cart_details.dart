import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commercio/models/cart_details/cart_details.dart';
import 'package:commercio/models/user/user_model.dart';
import 'package:commercio/state/auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cart_details.g.dart';

@riverpod
Stream<CartDetails> cartDetailsStream(
  CartDetailsStreamRef ref,
) async* {
  final db = FirebaseFirestore.instance;
  final authedUser = await ref.watch(authStreamProvider.future);
  final snapshots = db
      .doc('/users/${authedUser!.uid}')
      .withConverter(
        fromFirestore: (json, _) => SUser.fromJson(json.data()!),
        toFirestore: (user, _) => user.toJson(),
      )
      .snapshots();

  await for (final snapshot in snapshots) {
    if (!snapshot.exists) continue;
    yield snapshot.data()!.cartDetails;
  }
}
