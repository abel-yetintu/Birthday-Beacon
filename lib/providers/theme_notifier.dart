import 'package:birthday_beacon/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeNotifierProvider = NotifierProvider<ThemeNotifier, ThemeMode>(() => ThemeNotifier());

class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final SharedPreferences prefs = ref.watch(sharedPreferencesProvider).requireValue;
    if (prefs.getBool('isDark') == null) {
      return ThemeMode.dark;
    } else {
      if (prefs.getBool('isDark')!) {
        return ThemeMode.dark;
      }
      return ThemeMode.light;
    }
  }

  void toggleTheme() {
    if (state == ThemeMode.dark) {
      state = ThemeMode.light;
      ref.read(sharedPreferencesProvider).requireValue.setBool('isDark', false);
    } else {
      state = ThemeMode.dark;
      ref.read(sharedPreferencesProvider).requireValue.setBool('isDark', true);
    }
  }
}
