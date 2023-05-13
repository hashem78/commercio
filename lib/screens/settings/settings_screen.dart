import 'package:commercio/screens/settings/widgets/about_tile.dart';
import 'package:commercio/screens/settings/widgets/locale_change_tile.dart';
import 'package:commercio/screens/settings/widgets/sign_out_tile.dart';
import 'package:commercio/screens/settings/widgets/theme_mode_tile.dart';
import 'package:commercio/screens/shared/scaffold.dart';
import 'package:commercio/state/locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final translations = ref.watch(translationProvider).translations.settings;
    return SScaffold(
      title: Text(translations.name),
      body: ListView(
        children: const [
          ThemeModeTile(),
          LocaleChangeTile(),
          AboutTile(),
          SignOutTile(),
        ],
      ),
    );
  }
}
