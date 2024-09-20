import 'dart:async';
import 'dart:io';
import 'package:birthday_beacon/core/enums/relationship.dart';
import 'package:birthday_beacon/data/models/birthday.dart';
import 'package:birthday_beacon/data/models/state/add_birthday_screen_state.dart';
import 'package:birthday_beacon/providers/birthdays_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final addBirthdayScreenControllerProvider = NotifierProvider.autoDispose<AddBirthdayScreenController, AddBirthdayScreenState>(
  () => AddBirthdayScreenController(),
);

class AddBirthdayScreenController extends AutoDisposeNotifier<AddBirthdayScreenState> {
  Timer? _firstNameDebouncer;
  Timer? _lastNameDebouncer;

  @override
  AddBirthdayScreenState build() {
    ref.onDispose(() {
      _firstNameDebouncer?.cancel();
      _lastNameDebouncer?.cancel();
    });
    return AddBirthdayScreenState.initial();
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

  void setBirthDate(DateTime dateTime) {
    state = state.copyWith(birthdate: dateTime);
  }

  void setReminderTime(TimeOfDay reminderTime) {
    state = state.copyWith(reminderTime: reminderTime);
  }

  void setFirstName(String value) {
    if (_firstNameDebouncer != null) {
      _firstNameDebouncer!.cancel();
    }
    _firstNameDebouncer = Timer(const Duration(milliseconds: 500), () {
      if (value.trim() == '') {
        state = state.copyWith(setFirstNameToNull: true);
      } else {
        state = state.copyWith(firstName: value.trim());
      }
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

  void setImage(File? file) {
    if (file != null) {
      state = state.copyWith(tempImagePath: file.path);
    }
  }

  void removeImage() {
    state = state.copyWith(setTempImagePathToNull: true);
  }

  Future<int> addBirthday() async {
    if (state.firstName == null || state.birthdate == null) {
      return Future.value(0);
    } else {
      final birthday = Birthday(
        firstName: state.firstName!,
        lastName: state.lastName,
        imagePath: state.tempImagePath,
        birthdate: state.birthdate!,
        relationship: state.relationship,
        notifyOnBirthday: state.notifyOnBirthday,
        notifyOneDayBeforeBirthday: state.notifyOneDayBeforeBirthday,
        notifyTwoDaysBeforeBirthday: state.notifyTwoDaysBeforeBirthday,
        notifyOneWeekBeforeBirthday: state.notifyOneWeekBeforeBirthday,
        reminderHour: state.reminderTime.hour,
        reminderMinute: state.reminderTime.minute,
      );
      var result = await ref.read(birthdaysNotifierProvider.notifier).addBirthday(birthday);
      return result;
    }
  }
}
