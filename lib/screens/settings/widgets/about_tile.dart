import 'package:commercio/state/locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AboutTile extends ConsumerWidget {
  const AboutTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final translations = ref.watch(translationProvider).translations;
    return ListTile(
      leading: const Icon(Icons.info),
      title: Text(translations.settings.aboutTitle),
      onTap: () {
        showAboutDialog(
          context: context,
          applicationLegalese: translations.general.applicationLegalese,
          applicationName: translations.general.applicationName,
        );
      },
    );
  }
}
