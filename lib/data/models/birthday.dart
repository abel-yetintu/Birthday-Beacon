import 'package:flutter/material.dart';
import 'package:birthday_beacon/core/constants/background_colors.dart';
import 'package:birthday_beacon/core/enums/relationship.dart';

class Birthday {
  final int? id;
  final String firstName;
  final String? lastName;
  final String? imagePath;
  final DateTime birthdate;
  final Relationship relationship;
  final bool notifyOnBirthday;
  final bool notifyOneDayBeforeBirthday;
  final Color color;
  final int reminderHour;
  final int reminderMinute;

  String get initials {
    if (lastName != null) {
      return '${firstName[0].toUpperCase()}${lastName![0].toUpperCase()}';
    } else {
      return firstName[0].toUpperCase();
    }
  }

  Birthday({
    this.id,
    required this.firstName,
    this.lastName,
    this.imagePath,
    required this.birthdate,
    required this.relationship,
    required this.notifyOnBirthday,
    required this.notifyOneDayBeforeBirthday,
    required this.reminderHour,
    required this.reminderMinute,
    Color? color,
  }) : this.color = color ?? BackgroundColors.color;

  Birthday copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? imagePath,
    DateTime? birthdate,
    Relationship? relationship,
    bool? notifyOnBirthday,
    bool? notifyOneDayBeforeBirthday,
    Color? color,
    int? reminderHour,
    int? reminderMinute,
    bool setLastNameToNull = false,
    bool setImagePathToNull = false,
  }) {
    return Birthday(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: setLastNameToNull ? null : lastName ?? this.lastName,
      imagePath: setImagePathToNull ? null : imagePath ?? this.imagePath,
      birthdate: birthdate ?? this.birthdate,
      relationship: relationship ?? this.relationship,
      notifyOnBirthday: notifyOnBirthday ?? this.notifyOnBirthday,
      notifyOneDayBeforeBirthday: notifyOneDayBeforeBirthday ?? this.notifyOneDayBeforeBirthday,
      color: color ?? this.color,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
    );
  }

  Map<String, dynamic> toDatabase() {
    return <String, dynamic>{
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'imagePath': imagePath,
      'birthdate': birthdate.millisecondsSinceEpoch,
      'relationship': relationship.toMap(),
      'notifyOnBirthday': notifyOnBirthday ? 1 : 0,
      'notifyOneDayBeforeBirthday': notifyOneDayBeforeBirthday ? 1 : 0,
      'color': color.value,
      'reminderHour': reminderHour,
      'reminderMinute': reminderMinute
    };
  }

  factory Birthday.fromDatabase(Map<String, dynamic> map) {
    return Birthday(
      id: map['id'] != null ? map['id'] as int : null,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] != null ? map['lastName'] as String : null,
      imagePath: map['imagePath'] != null ? map['imagePath'] as String : null,
      birthdate: DateTime.fromMillisecondsSinceEpoch(map['birthdate'] as int),
      relationship: Relationship.fromString(map['relationship']),
      notifyOnBirthday: map['notifyOnBirthday'] == 1,
      notifyOneDayBeforeBirthday: map['notifyOneDayBeforeBirthday'] == 1,
      color: Color(map['color'] as int),
      reminderHour: map['reminderHour'] as int,
      reminderMinute: map['reminderMinute'] as int,
    );
  }

  @override
  bool operator ==(covariant Birthday other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.imagePath == imagePath &&
        other.birthdate == birthdate &&
        other.relationship == relationship &&
        other.notifyOnBirthday == notifyOnBirthday &&
        other.notifyOneDayBeforeBirthday == notifyOneDayBeforeBirthday &&
        other.color == color &&
        other.reminderHour == reminderHour &&
        other.reminderMinute == reminderMinute;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        imagePath.hashCode ^
        birthdate.hashCode ^
        relationship.hashCode ^
        notifyOnBirthday.hashCode ^
        notifyOneDayBeforeBirthday.hashCode ^
        color.hashCode ^
        reminderHour.hashCode ^
        reminderMinute.hashCode;
  }

  int remainingDaystillBirthday() {
    var now = DateTime.now();
    var today = DateTime(now.year, now.month, now.day);
    var nextBirthday = DateTime(now.year, birthdate.month, birthdate.day);
    if (nextBirthday.isBefore(today)) {
      nextBirthday = DateTime(nextBirthday.year + 1, nextBirthday.month, nextBirthday.day);
    }
    return (nextBirthday.difference(today).inHours / 24).round();
  }

  int calculateNextAge() {
    var now = DateTime.now();
    int nextAge = now.year - birthdate.year;
    if (now.month > birthdate.month) {
      nextAge++;
    } else if (now.month == birthdate.month) {
      if (now.day > birthdate.day) {
        nextAge++;
      }
    }
    return nextAge;
  }

  int calculateAge() {
    var now = DateTime.now();
    int age = now.year - birthdate.year;
    if (birthdate.month > now.month) {
      age--;
    } else if (now.month == birthdate.month) {
      if (birthdate.day > now.day) {
        age--;
      }
    }
    return age;
  }
}
