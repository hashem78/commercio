import 'package:commercio/i18n/translations.g.dart';
import 'package:commercio/state/locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocaleChangeDialog extends ConsumerWidget {
  const LocaleChangeDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(
      translationProvider.select((value) => value.locale),
    );
    final translations = ref.watch(
      translationProvider.select((value) => value.translations),
    );

    return AlertDialog(
      title: Text(translations.settings.chooseLanguageTitle),
      actions: [
        RadioListTile<AppLocale>(
          value: AppLocale.en,
          title: Text(translations.settings.languageEnglish),
          groupValue: locale,
          onChanged: (val) {
            if (val != null) {
              ref.read(translationProvider.notifier).setTranslations(val);
            }
          },
        ),
        RadioListTile<AppLocale>(
          value: AppLocale.ar,
          title: Text(translations.settings.languageArabic),
          groupValue: locale,
          onChanged: (val) {
            if (val != null) {
              ref.read(translationProvider.notifier).setTranslations(val);
            }
          },
        ),
      ],
    );
  }
}
