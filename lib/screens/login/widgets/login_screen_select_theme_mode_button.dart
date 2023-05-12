import 'package:commercio/dialogs/change_theme_dialog.dart';
import 'package:commercio/state/locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreenSelectThemeButton extends ConsumerWidget {
  const LoginScreenSelectThemeButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final translations = ref.watch(translationProvider).translations;
    return IconButton(
      tooltip: translations.login.changeTheme,
      onPressed: () async {
        showDialog(context: context, builder: (_) => const ChangeThemeDialog());
      },
      icon: const Icon(Icons.color_lens),
    );
  }
}
