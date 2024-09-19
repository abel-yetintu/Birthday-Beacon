import 'package:birthday_beacon/core/enums/filter.dart';
import 'package:birthday_beacon/core/enums/relationship.dart';
import 'package:birthday_beacon/data/local/database.dart';
import 'package:birthday_beacon/providers/birthdays_notifier.dart';
import 'package:birthday_beacon/services/image_picker_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final databaseHelperProvider = Provider.autoDispose((ref) => DatabaseHelper());

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
