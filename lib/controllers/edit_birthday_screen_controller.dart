import 'dart:async';
import 'dart:io';
import 'package:birthday_beacon/core/enums/relationship.dart';
import 'package:birthday_beacon/data/models/birthday.dart';
import 'package:birthday_beacon/providers/birthdays_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final editBirthdayScreenControllerProvider = NotifierProvider.autoDispose.family<EditBirthdayScreenController, Birthday, Birthday>(() {
  return EditBirthdayScreenController();
});

class EditBirthdayScreenController extends AutoDisposeFamilyNotifier<Birthday, Birthday> {
  Timer? _firstNameDebouncer;
  Timer? _lastNameDebouncer;

  @override
  Birthday build(Birthday arg) {
    ref.onDispose(() {
      _firstNameDebouncer?.cancel();
      _lastNameDebouncer?.cancel();
    });
    return arg;
  }

  void setFirstName(String value) {
    if (_firstNameDebouncer != null) {
      _firstNameDebouncer!.cancel();
    }
    _firstNameDebouncer = Timer(const Duration(milliseconds: 500), () {
      state = state.copyWith(firstName: value.trim());
    });
  }

  void setLastName(String value) {
    if (_lastNameDebouncer != null) {
      _lastNameDebouncer!.cancel();
    }
    _lastNameDebouncer = Timer(const Duration(milliseconds: 500), () {
      if (value.trim() == '') {
        state = state.copyWith(setLastNameToNull: true);
      } else {
        state = state.copyWith(lastName: value.trim());
      }
    });
  }

  void setBirthDate(DateTime dateTime) {
    state = state.copyWith(birthdate: dateTime);
  }

  void changeRelationship(Relationship relationship) {
    state = state.copyWith(relationship: relationship);
  }

  void changeNotifyOnBirthday(bool value) {
    state = state.copyWith(notifyOnBirthday: value);
  }

  void changeNotifyOneDayBeforeBirthday(bool value) {
    state = state.copyWith(notifyOneDayBeforeBirthday: value);
  }

  void changeNotifiyTwoDaysBeforeBirthday(bool value) {
    state = state.copyWith(notifyTwoDaysBeforeBirthday: value);
  }

  void changeNotifiyOneWeekBeforeBirthday(bool value) {
    state = state.copyWith(notifyOneWeekBeforeBirthday: value);
  }

  void setReminderTime(TimeOfDay reminderTime) {
    state = state.copyWith(
      reminderHour: reminderTime.hour,
      reminderMinute: reminderTime.minute,
    );
  }

  void setImage(File? file) {
    if (file != null) {
      state = state.copyWith(imagePath: file.path);
    }
  }

  void removeImage() {
    state = state.copyWith(setImagePathToNull: true);
  }

  Future<int> editBirthday(Birthday oldBirthday) async {
    if (state.firstName == '') {
      return Future.value(0);
    } else {
      final birthday = Birthday(
        id: state.id,
        firstName: state.firstName,
        lastName: state.lastName,
        imagePath: state.imagePath,
        birthdate: state.birthdate,
        relationship: state.relationship,
        notifyOnBirthday: state.notifyOnBirthday,
        notifyOneDayBeforeBirthday: state.notifyOneDayBeforeBirthday,
        notifyTwoDaysBeforeBirthday: state.notifyTwoDaysBeforeBirthday,
        notifyOneWeekBeforeBirthday: state.notifyOneWeekBeforeBirthday,
        reminderHour: state.reminderHour,
        reminderMinute: state.reminderMinute,
        color: state.color,
      );
      if (birthday == oldBirthday) {
        return 1;
      }
      var result = await ref.read(birthdaysNotifierProvider.notifier).editBirthday(oldBirthday: oldBirthday, newBirthday: birthday);
      return result;
    }
  }
}
