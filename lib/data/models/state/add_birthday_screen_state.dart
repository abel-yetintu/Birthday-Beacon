import 'package:birthday_beacon/core/enums/relationship.dart';
import 'package:flutter/material.dart';

class AddBirthdayScreenState {
  final String? firstName;
  final String? lastName;
  final DateTime? birthdate;
  final String? tempImagePath;
  final Relationship relationship;
  final bool notifyOnBirthday;
  final bool notifyOneDayBeforeBirthday;
  final bool notifyTwoDaysBeforeBirthday;
  final bool notifyOneWeekBeforeBirthday;
  final TimeOfDay reminderTime;

  AddBirthdayScreenState({
    this.firstName,
    this.lastName,
    this.birthdate,
    this.tempImagePath,
    required this.relationship,
    required this.notifyOnBirthday,
    required this.notifyOneDayBeforeBirthday,
    required this.notifyTwoDaysBeforeBirthday,
    required this.notifyOneWeekBeforeBirthday,
    required this.reminderTime,
  });

  AddBirthdayScreenState.initial()
      : relationship = Relationship.family,
        firstName = null,
        lastName = null,
        birthdate = null,
        tempImagePath = null,
        notifyOnBirthday = true,
        notifyOneDayBeforeBirthday = false,
        notifyTwoDaysBeforeBirthday = false,
        notifyOneWeekBeforeBirthday = false,
        reminderTime = const TimeOfDay(hour: 9, minute: 0);

  AddBirthdayScreenState copyWith({
    String? firstName,
    String? lastName,
    DateTime? birthdate,
    String? tempImagePath,
    Relationship? relationship,
    bool? notifyOnBirthday,
    bool? notifyOneDayBeforeBirthday,
    bool? notifyTwoDaysBeforeBirthday,
    bool? notifyOneWeekBeforeBirthday,
    TimeOfDay? reminderTime,
  }) {
    return AddBirthdayScreenState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthdate: birthdate ?? this.birthdate,
      tempImagePath: tempImagePath ?? this.tempImagePath,
      relationship: relationship ?? this.relationship,
      notifyOnBirthday: notifyOnBirthday ?? this.notifyOnBirthday,
      notifyOneDayBeforeBirthday: notifyOneDayBeforeBirthday ?? this.notifyOneDayBeforeBirthday,
      notifyTwoDaysBeforeBirthday: notifyTwoDaysBeforeBirthday ?? this.notifyTwoDaysBeforeBirthday,
      notifyOneWeekBeforeBirthday: notifyOneWeekBeforeBirthday ?? this.notifyOneWeekBeforeBirthday,
      reminderTime: reminderTime ?? this.reminderTime,
    );
  }
}
