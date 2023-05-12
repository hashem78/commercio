import 'package:commercio/models/theme_mode/theme_mode.dart';
import 'package:commercio/state/locale.dart';
import 'package:commercio/state/theme_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChangeThemeDialog extends ConsumerWidget {
  const ChangeThemeDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeModeProvider);
    final translations = ref.watch(translationProvider).translations;

    return AlertDialog(
      title: Text(translations.settings.chooseThemeTitle),
      actions: [
        RadioListTile<SThemeMode>(
          value: const SThemeMode.system(),
          groupValue: themeState,
          title: Text(translations.settings.themeSystem),
          onChanged: (val) async {
            if (val != null) {
              final notifier = ref.read(themeModeProvider.notifier);
              await notifier.chageTo(val);
            }
          },
        ),
        RadioListTile<SThemeMode>(
          value: const SThemeMode.light(),
          groupValue: themeState,
          title: Text(translations.settings.themeLight),
          onChanged: (val) async {
            if (val != null) {
              final notifier = ref.read(themeModeProvider.notifier);
              await notifier.chageTo(val);
            }
          },
        ),
        RadioListTile<SThemeMode>(
          value: const SThemeMode.dark(),
          groupValue: themeState,
          title: Text(translations.settings.themeDark),
          onChanged: (val) async {
            if (val != null) {
              final notifier = ref.read(themeModeProvider.notifier);
              await notifier.chageTo(val);
            }
          },
        ),
      ],
    );
  }
}
