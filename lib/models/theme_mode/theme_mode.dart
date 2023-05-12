import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'theme_mode.freezed.dart';
part 'theme_mode.g.dart';

@freezed
class SThemeMode with _$SThemeMode {
  const SThemeMode._();

  ThemeMode get flutterThemeMode => when(
        system: () => ThemeMode.system,
        light: () => ThemeMode.light,
        dark: () => ThemeMode.dark,
      );

  const factory SThemeMode.system() = _SThemeModeSystem;
  const factory SThemeMode.light() = _SThemeModeLight;
  const factory SThemeMode.dark() = _SThemeModeDark;

  factory SThemeMode.fromJson(Map<String, dynamic> json) =>
      _$SThemeModeFromJson(json);
}
