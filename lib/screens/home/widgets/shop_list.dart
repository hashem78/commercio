import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commercio/models/shop/shop.dart';
import 'package:commercio/screens/home/widgets/shop_list_widget.dart';
import 'package:commercio/state/auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';

class ShopList extends HookConsumerWidget {
  final String? ownerId;
  final bool isAuthedList;
  const ShopList({
    super.key,
    this.ownerId,
    this.isAuthedList = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authedUser = ref.watch(authStreamProvider).valueOrNull;
    return FirestoreListView<SShop>(
      pageSize: 20,
      itemBuilder: (context, snap) => SShopListWidget(
        snap.data(),
        isInAuthedList: isAuthedList,
      ),
      emptyBuilder: (context) {
        return Center(
          child: Lottie.asset('assets/lottiefiles/empty.json'),
        );
      },
      query: FirebaseFirestore.instance
          .collection(
            'shops',
          )
          .where(
            'ownerId',
            isEqualTo: ownerId,
          )
          .where(
            'ownerId',
            isNotEqualTo: isAuthedList ? null : authedUser?.uid,
          )
          .withConverter<SShop>(
            fromFirestore: (snapshot, _) => SShop.fromJson(snapshot.data()!),
            toFirestore: (product, _) => product.toJson(),
          ),
    );
  }
}
