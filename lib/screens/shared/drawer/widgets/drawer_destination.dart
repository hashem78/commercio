import 'package:flutter/material.dart';

class SDrawerDestionation extends StatelessWidget {
  const SDrawerDestionation({
    super.key,
    required this.title,
    required this.leading,
  });

  final String title;
  final Widget leading;

  @override
  Widget build(BuildContext context) {
    return NavigationDrawerDestination(
      icon: leading,
      label: Text(title),
      selectedIcon: leading,
    );
  }
}
