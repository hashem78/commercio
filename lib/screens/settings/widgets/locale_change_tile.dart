import 'package:commercio/dialogs/locale_change_dialog.dart';
import 'package:commercio/i18n/translations.g.dart';
import 'package:commercio/state/locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocaleChangeTile extends ConsumerWidget {
  const LocaleChangeTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final translations = ref.watch(translationProvider.select(
      (value) => value.translations,
    ));
    final locale = ref.watch(
      translationProvider.select((value) => value.locale),
    );
    late String subTitle;
    switch (locale) {
      case AppLocale.en:
        subTitle = translations.settings.languageEnglish;
        break;
      case AppLocale.ar:
        subTitle = translations.settings.languageArabic;

        break;
    }

    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(translations.settings.languageTitle),
      subtitle: Text(subTitle),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => const LocaleChangeDialog(),
        );
      },
    );
  }
}
