import 'package:commercio/router/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'drawer_destinations.g.dart';

class SDrawerDestionation extends NavigationDrawerDestination {
  final String routeName;

  const SDrawerDestionation({
    super.key,
    required this.routeName,
    required Icon icon,
    required Widget label,
  }) : super(icon: icon, label: label);
}

@Riverpod(keepAlive: true)
List<SDrawerDestionation> drawerDestinations(Ref ref) {
  return const [
    SDrawerDestionation(
      icon: Icon(Icons.home),
      label: Text('Home'),
      routeName: kHomeRouteName,
    ),
    SDrawerDestionation(
      icon: Icon(Icons.settings),
      label: Text('Settings'),
      routeName: kSettingsRouteName,
    ),
  ];
}
