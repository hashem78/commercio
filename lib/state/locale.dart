import 'package:commercio/i18n/translations.g.dart';
import 'package:commercio/state/shared_perfernces_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A simple wrapper class to hold the state of the notifier.
class TranslationsContainer {
  final TranslationsEn translations;
  final AppLocale locale;

  const TranslationsContainer(this.translations, this.locale);
}

final _english = TranslationsContainer(
  TranslationsEn.build(),
  AppLocale.en,
);
final _arabic = TranslationsContainer(
  TranslationsAr.build(),
  AppLocale.ar,
);

/// The notifier responsible for translation changes, locale changes are
/// persisted to storage on change.
class TranslationsNotifier extends StateNotifier<TranslationsContainer> {
  TranslationsNotifier(TranslationsContainer state, this.ref) : super(state) {
    final window = WidgetsBinding.instance.platformDispatcher;
    window.onLocaleChanged = () async {
      final locale = AppLocaleUtils.findDeviceLocale();
      await setTranslations(locale);
    };
  }
  final Ref ref;
  Future<void> setTranslations(AppLocale other) async {
    switch (other) {
      case AppLocale.en:
        state = _english;
        break;
      case AppLocale.ar:
        state = _arabic;
        break;
    }
    final prefs = ref.read(sharedPerferencesProvider);

    // Save the current locale to SharedPreferneces for persistance.
    await prefs.setString("locale", other.name);
  }

  Future<void> toggle() async {
    switch (state.locale) {
      case AppLocale.en:
        state = _arabic;
        break;
      case AppLocale.ar:
        state = _english;
        break;
    }
    final prefs = ref.read(sharedPerferencesProvider);

    // Save the current locale to SharedPreferneces for persistance.
    await prefs.setString("locale", state.locale.name);
  }
}

/// Provides the current/persisted locale to the widget tree
/// and the current locale is loaded form storage.
///
/// Usage example:
/// ``` dart
///  class PDrawer extends ConsumerWidget {
///  const PDrawer({
///    Key? key,
///  }) : super(key: key);
///
///  @override
///  Widget build(BuildContext context, WidgetRef ref) {
///    final translations = ref.watch(translationProvider).translations;
///    // you can obtain the approriate translation for the widget
///    // from the translations object.
///    ...
/// }
/// ```
final translationProvider =
    StateNotifierProvider<TranslationsNotifier, TranslationsContainer>(
  (ref) {
    final prefs = ref.read(sharedPerferencesProvider);
    late AppLocale locale;
    if (prefs.containsKey("locale")) {
      locale = AppLocaleUtils.parse(prefs.getString("locale")!);
    } else {
      // Default to the devices locale if this is the first
      // time the application is lanched
      final defaultLocale = AppLocaleUtils.findDeviceLocale();
      prefs.setString("locale", defaultLocale.name);
      locale = defaultLocale;
    }

    // return the correct translation based on the persisted locale
    // in SharedPereferences.
    switch (locale) {
      case AppLocale.en:
        return TranslationsNotifier(_english, ref);
      case AppLocale.ar:
        return TranslationsNotifier(_arabic, ref);
    }
  },
);
