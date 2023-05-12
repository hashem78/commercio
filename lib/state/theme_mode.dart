import 'dart:convert';

import 'package:commercio/models/theme_mode/theme_mode.dart';
import 'package:commercio/state/shared_perfernces_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notifier for thememode chagnes, after every state change
/// we persist to SharedPereferences.
class SThemeModeNotifier extends StateNotifier<SThemeMode> {
  /// To be able to access the SharedPereferences instance
  final Ref _ref;
  void handleSystemTheme() {
    final window = WidgetsBinding.instance.platformDispatcher;
    window.onPlatformBrightnessChanged = () {
      WidgetsBinding.instance.handlePlatformBrightnessChanged();
      print('Platform brightness changed!');
      // We ignore the const here because const instances are all the same
      // And since rebuilds happen on state changes, the new state has to be
      // non const for a rebuild to happen.
      // ignore: prefer_const_constructors
      state = SThemeMode.system();
    };
  }

  void handleDarkAndLightThemes() {
    final window = WidgetsBinding.instance.platformDispatcher;
    window.onPlatformBrightnessChanged =
        WidgetsBinding.instance.handlePlatformBrightnessChanged;
  }

  SThemeModeNotifier(SThemeMode state, this._ref) : super(state) {
    // Registers the platform change handeler if the initial state
    // is SThemeMode.system
    state.whenOrNull(
      system: handleSystemTheme,
    );
  }

  Future<void> chageTo(SThemeMode other) async {
    state = other;
    state.when(
      system: handleSystemTheme,
      light: handleDarkAndLightThemes,
      dark: handleDarkAndLightThemes,
    );
    final prefs = _ref.read(sharedPerferencesProvider);
    await prefs.setString('themeMode', jsonEncode(state));
  }
}

/// Provides the widget tree with the current theme, initially we load the current
/// theme type from storage then pass it to the notifier.
final themeModeProvider = StateNotifierProvider<SThemeModeNotifier, SThemeMode>(
  (ref) {
    final prefs = ref.read(sharedPerferencesProvider);
    if (prefs.containsKey("themeMode")) {
      final state = jsonDecode(prefs.getString("themeMode")!);
      return SThemeModeNotifier(SThemeMode.fromJson(state), ref);
    } else {
      const state = SThemeMode.system();
      prefs.setString("themeMode", jsonEncode(state));
      return SThemeModeNotifier(state, ref);
    }
  },
);
