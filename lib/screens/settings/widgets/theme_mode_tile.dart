import 'package:commercio/dialogs/change_theme_dialog.dart';
import 'package:commercio/state/locale.dart';
import 'package:commercio/state/theme_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeModeTile extends ConsumerWidget {
  const ThemeModeTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late String subTitle;
    final themeState = ref.watch(themeModeProvider);
    final translations = ref.watch(translationProvider).translations;
    themeState.when(
      system: () => subTitle = translations.settings.themeSystem,
      light: () => subTitle = translations.settings.themeLight,
      dark: () => subTitle = translations.settings.themeDark,
    );

    return ListTile(
      leading: const Icon(Icons.colorize),
      title: Text(translations.settings.themeTitle),
      subtitle: Text(subTitle),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => const ChangeThemeDialog(),
        );
      },
    );
  }
}