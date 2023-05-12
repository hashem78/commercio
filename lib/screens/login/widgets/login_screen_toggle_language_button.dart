import 'package:commercio/state/locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreenToggleLanguageButton extends ConsumerWidget {
  const LoginScreenToggleLanguageButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final translations = ref.watch(translationProvider).translations;
    return IconButton(
      tooltip: translations.login.changeLanguage,
      onPressed: () async {
        final notifier = ref.read(translationProvider.notifier);
        await notifier.toggle();
      },
      icon: const Icon(Icons.translate),
    );
  }
}
