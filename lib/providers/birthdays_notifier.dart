import 'dart:async';
import 'dart:io';
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
    if (birthday.imagePath != null) {
      var imagePath = await _saveImage(birthday.imagePath!);
      if (imagePath == null) {
        var newBirthday = birthday.copyWith(setImagePathToNull: true);
        var result = database.addBirthday(newBirthday);
        ref.invalidateSelf();
        return result;
      }
      var newBirthday = birthday.copyWith(imagePath: imagePath);
      var result = database.addBirthday(newBirthday);
      ref.invalidateSelf();
      return result;
    }
    var result = database.addBirthday(birthday);
    ref.invalidateSelf();
    return result;
  }

  Future<int> editBirthday({required Birthday oldBirthday, required Birthday newBirthday}) async {
    final database = ref.read(databaseHelperProvider);
    if (newBirthday.imagePath != null && newBirthday.imagePath != oldBirthday.imagePath) {
      if (oldBirthday.imagePath != null) {
        var deleteResult = await _deleteImage(oldBirthday.imagePath!);
        if (!deleteResult) return 0;
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
    var result = database.removeBirthday(birthday);
    ref.invalidateSelf();
    return result;
  }
}
