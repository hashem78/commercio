import 'package:commercio/router/router.dart';
import 'package:commercio/screens/home/widgets/cart_icon_button.dart';
import 'package:commercio/screens/home/widgets/shop_list.dart';
import 'package:commercio/screens/shared/drawer/drawer.dart';
import 'package:commercio/state/auth.dart';
import 'package:commercio/state/locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authedUser = ref.watch(authStreamProvider).value!;
    final t = ref.watch(translationProvider).translations.home;

    return Scaffold(
      drawer: const SDrawer(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => CreateShopDialogRoute().push(context),
        label: Row(
          children: [
            const Icon(Icons.add),
            Text(t.createShopFABTitle),
          ],
        ),
      ).animate(),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, isBoxScrolled) {
            return [
              SliverAppBar(
                title: Text(t.title),
                actions: const [
                  CartIconButton(),
                ],
                forceElevated: true,
                bottom: TabBar(
                  tabs: [
                    Tab(
                      text: t.myShopsTabTitle,
                      icon: const Icon(Icons.person),
                    ),
                    Tab(
                      text: t.shopsTabTitle,
                      icon: const FaIcon(FontAwesomeIcons.globe),
                    ),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              ShopList(ownerId: authedUser.uid, isAuthedList: true),
              const ShopList(),
            ],
          ),
        ),
      ),
    );
  }
}
