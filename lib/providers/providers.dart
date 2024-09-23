import 'package:birthday_beacon/core/enums/filter.dart';
import 'package:birthday_beacon/core/enums/relationship.dart';
import 'package:birthday_beacon/core/utils/helper_functions.dart';
import 'package:birthday_beacon/data/local/database.dart';
import 'package:birthday_beacon/providers/birthdays_notifier.dart';
import 'package:birthday_beacon/services/image_picker_service.dart';
import 'package:birthday_beacon/services/local_notification_service.dart';
import 'package:birthday_beacon/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final appStartUpProvider = FutureProvider.autoDispose<void>((ref) async {
  ref.onDispose(() {
    ref.invalidate(sharedPreferencesProvider);
  });
  await ref.watch(sharedPreferencesProvider.future);
  await ref.watch(localNotificationServiceProvider).init();
});

final navigatorKeyProvider = Provider.autoDispose((ref) => GlobalKey<NavigatorState>());

final navigationServiceProvider = Provider.autoDispose((ref) {
  final navigatorKey = ref.watch(navigatorKeyProvider);
  return NavigationService(navigatorKey: navigatorKey);
});

final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async => await SharedPreferences.getInstance());

final localNotificationServiceProvider = Provider.autoDispose((ref) => LocalNotificationService());

final databaseHelperProvider = Provider.autoDispose((ref) => DatabaseHelper());

final helperFunctionsProvider = Provider.autoDispose((ref) {
  final navigatorKey = ref.watch(navigatorKeyProvider);
  return HelperFunctions(navigatorKey: navigatorKey);
});

final imagePickerServiceProvider = Provider.autoDispose((ref) => ImagePickerService());

final fabVisibilityProvider = StateProvider.autoDispose<bool>((ref) => true);

final filterProvider = StateProvider.autoDispose<Filter>((ref) => Filter.all);

final filteredBirthdaysProvider = FutureProvider.autoDispose((ref) async {
  final birthdays = await ref.watch(birthdaysNotifierProvider.future);
  final filter = ref.watch(filterProvider);
  switch (filter) {
    case Filter.all:
      return birthdays;
    case Filter.family:
      return birthdays.where((birthday) => birthday.relationship == Relationship.family).toList();
    case Filter.friends:
      return birthdays.where((birthday) => birthday.relationship == Relationship.friend).toList();
    case Filter.work:
      return birthdays.where((birthday) => birthday.relationship == Relationship.work).toList();
    case Filter.other:
      return birthdays.where((birthday) => birthday.relationship == Relationship.other).toList();
  }
});
