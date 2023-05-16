import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commercio/models/product/product.dart';
import 'package:commercio/models/shop/shop.dart';
import 'package:commercio/router/router.dart';
import 'package:commercio/screens/shared/drawer/drawer.dart';
import 'package:commercio/screens/shared/utility_widgets.dart';
import 'package:commercio/state/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authedUser = ref.watch(authStreamProvider).value!;

    return Scaffold(
      drawer: const SDrawer(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => CreateShopDialogRoute().push(context),
        label: const Row(
          children: [
            Icon(Icons.add),
            Text('Create Shop'),
          ],
        ),
      ).animate(),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, isBoxScrolled) {
            return [
              SliverAppBar(
                title: const Text('Shops'),
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: Badge.count(
                      count: 1,
                      child: const FaIcon(FontAwesomeIcons.cartShopping),
                    ),
                  ),
                ],
                forceElevated: true,
                bottom: const TabBar(
                  tabs: [
                    Tab(
                      text: 'My Shops',
                      icon: Icon(Icons.person),
                    ),
                    Tab(
                      text: 'Shops',
                      icon: FaIcon(FontAwesomeIcons.globe),
                    ),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              ShopList(
                ownerId: authedUser.uid,
                isAuthedList: true,
              ),
              const ShopList(),
            ],
          ),
        ),
      ),
    );
  }
}

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

class SShopListWidget extends ConsumerWidget {
  final SShop shop;
  final bool isInAuthedList;
  const SShopListWidget(
    this.shop, {
    super.key,
    this.isInAuthedList = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final owner = ref.watch(userStreamProvider(shop.ownerId));
    return owner.when(
      data: (owner) {
        return ListTile(
          leading: switch (!isInAuthedList) {
            true => CircleAvatar(
                foregroundImage: CachedNetworkImageProvider(
                  owner.profilePicture.link,
                ),
              ),
            false => null,
          },
          title: Text(shop.name),
          subtitle: switch (!isInAuthedList) {
            true => Text(owner.name),
            false => null,
          },
          onTap: () => ShopRoute(shop.id).push(context),
        );
      },
      error: errorWidget,
      loading: loadingWidget,
    );
  }
}

class ProductList extends ConsumerWidget {
  final String ownerId;
  final String shopId;
  const ProductList({
    super.key,
    required this.ownerId,
    required this.shopId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FirestoreListView<SProduct>(
      pageSize: 20,
      itemBuilder: (context, snap) => SProductListWidget(snap.data()),
      query: FirebaseFirestore.instance
          .collection(
            '/products',
          )
          .where(
            'shopId',
            isEqualTo: shopId,
          )
          .where(
            'ownerId',
            isEqualTo: ownerId,
          )
          .withConverter<SProduct>(
            fromFirestore: (snapshot, _) => SProduct.fromJson(snapshot.data()!),
            toFirestore: (product, _) => product.toJson(),
          ),
    );
  }
}

class SProductListWidget extends StatelessWidget {
  final SProduct product;
  const SProductListWidget(
    this.product, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 100,
      child: Card(),
    );
  }
}
