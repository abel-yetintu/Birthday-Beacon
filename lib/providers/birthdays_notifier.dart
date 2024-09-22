import 'dart:async';
import 'dart:io';
import 'package:birthday_beacon/core/utils/helper_functions.dart';
import 'package:birthday_beacon/data/models/birthday.dart';
import 'package:birthday_beacon/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

final birthdaysNotifierProvider = AutoDisposeAsyncNotifierProvider<BirthdaysNotifier, List<Birthday>>(() {
  return BirthdaysNotifier();
});

class BirthdaysNotifier extends AutoDisposeAsyncNotifier<List<Birthday>> {
  @override
  Future<List<Birthday>> build() async {
    final database = ref.watch(databaseHelperProvider);
    return database.getBirthdays();
  }

  Future<int> addBirthday(Birthday birthday) async {
    final database = ref.read(databaseHelperProvider);
    // image provided
    if (birthday.imagePath != null) {
      var imagePath = await _saveImage(birthday.imagePath!);
      // image not saved to local storage
      if (imagePath == null) {
        var newBirthday = birthday.copyWith(setImagePathToNull: true);
        var result = await database.addBirthday(newBirthday);
        // birthday not saved in database
        if (result == 0) {
          return 0;
        }
        // birthday saved in database
        await _addNotifications(newBirthday.copyWith(id: result));
        ref.invalidateSelf();
        return result;
      }
      // image saved to local storage
      var newBirthday = birthday.copyWith(imagePath: imagePath);
      var result = await database.addBirthday(newBirthday);
      // birthday not saved in database
      if (result == 0) {
        return 0;
      }
      // birthday saved in database
      await _addNotifications(newBirthday.copyWith(id: result));
      ref.invalidateSelf();
      return result;
    }

    // image not provided
    var result = await database.addBirthday(birthday);
    // birthday not saved in database
    if (result == 0) {
      return 0;
    }
    await _addNotifications(birthday.copyWith(id: result));
    ref.invalidateSelf();
    return result;
  }

  Future<int> editBirthday({required Birthday oldBirthday, required Birthday newBirthday}) async {
    final database = ref.read(databaseHelperProvider);
    // edit scheduled notifications
    if (oldBirthday.notifyOnBirthday != newBirthday.notifyOnBirthday ||
        oldBirthday.notifyOneDayBeforeBirthday != newBirthday.notifyOneDayBeforeBirthday ||
        oldBirthday.reminderHour != newBirthday.reminderHour ||
        oldBirthday.reminderMinute != newBirthday.reminderMinute ||
        oldBirthday.birthdate != newBirthday.birthdate) {
      await _removeNotifications(oldBirthday);
      await _addNotifications(newBirthday);
    }
    // edit saved image
    if (newBirthday.imagePath != null && newBirthday.imagePath != oldBirthday.imagePath) {
      if (oldBirthday.imagePath != null) {
        await _deleteImage(oldBirthday.imagePath!);
      }
      var imagePath = await _saveImage(newBirthday.imagePath!);
      if (imagePath == null) {
        var birthdayTobeSaved = newBirthday.copyWith(setImagePathToNull: true);
        var result = database.editBirthday(birthdayTobeSaved);
        ref.invalidateSelf();
        return result;
      } else {
        var birthdayTobeSaved = newBirthday.copyWith(imagePath: imagePath);
        var result = database.editBirthday(birthdayTobeSaved);
        ref.invalidateSelf();
        return result;
      }
    } else if (newBirthday.imagePath == null && oldBirthday.imagePath != null) {
      var deleteResult = await _deleteImage(oldBirthday.imagePath!);
      if (deleteResult) {
        var result = database.editBirthday(newBirthday);
        ref.invalidateSelf();
        return result;
      } else {
        return 0;
      }
    }

    var result = database.editBirthday(newBirthday);
    ref.invalidateSelf();
    return result;
  }

  Future<String?> _saveImage(String imagePath) async {
    try {
      final File originalImageFile = File(imagePath);
      final String filePath = (await getApplicationDocumentsDirectory()).path;
      final originalImageName = basename(originalImageFile.path);
      final copyImagePath = (await originalImageFile.copy('$filePath/$originalImageName')).path;
      return copyImagePath;
    } catch (e) {
      return null;
    }
  }

  Future<bool> _deleteImage(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      } else {
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  Future<int> deleteBirthday(Birthday birthday) async {
    final database = ref.read(databaseHelperProvider);
    if (birthday.imagePath != null) {
      _deleteImage(birthday.imagePath!);
    }
    var result = await database.removeBirthday(birthday);
    if (result == 0) {
      return 0;
    }
    await _removeNotifications(birthday);
    ref.invalidateSelf();
    return result;
  }

  // notifications

  Future<void> _addNotifications(Birthday birthday) async {
    final localNotification = ref.read(localNotificationServiceProvider);
    final notificationSchedule = DateTime(
      birthday.birthdate.year,
      birthday.birthdate.month,
      birthday.birthdate.day,
      birthday.reminderHour,
      birthday.reminderMinute,
    );

    // notify on birthday
    if (birthday.notifyOnBirthday) {
      await localNotification.createBirthdayReminderNotification(
        id: HelperFunctions.generateBirthdayNotificationId(birthday.id!, 0),
        title: "🎉 ${birthday.firstName}'s Birthday Today 🎂",
        body: "Don't forget to wish ${birthday.firstName} a happy birthday! 🎁",
        notificationSchedule: notificationSchedule,
      );
    }

    // notify one day before birthday
    if (birthday.notifyOneDayBeforeBirthday) {
      var updatedNotificationSchedule = notificationSchedule.subtract(const Duration(days: 1));
      await localNotification.createBirthdayReminderNotification(
        id: HelperFunctions.generateBirthdayNotificationId(birthday.id!, 1),
        title: "⏳ Tomorrow is ${birthday.firstName}'s Birthday!",
        body: "Get ready to wish ${birthday.firstName} a happy birthday tomorrow!",
        notificationSchedule: updatedNotificationSchedule,
      );
    }
  }

  Future<void> _removeNotifications(Birthday birthday) async {
    final localNotification = ref.read(localNotificationServiceProvider);
    if (birthday.notifyOnBirthday) {
      await localNotification.removeBirthdayReminderNotification(HelperFunctions.generateBirthdayNotificationId(birthday.id!, 0));
    }
    if (birthday.notifyOneDayBeforeBirthday) {
      await localNotification.removeBirthdayReminderNotification(HelperFunctions.generateBirthdayNotificationId(birthday.id!, 1));
    }
  }
}
