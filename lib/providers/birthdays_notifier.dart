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
      var newBirthday = birthday.copyWith(imagePath: imagePath);
      var result = database.addBirthday(newBirthday);
      ref.invalidateSelf();
      return result;
    }
    var result = database.addBirthday(birthday);
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

  Future<int> deleteBirthday(Birthday birthday) async {
    final database = ref.read(databaseHelperProvider);
    if (birthday.imagePath != null) {
      try {
        final file = File(birthday.imagePath!);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {}
    }
    var result = database.removeBirthday(birthday);
    ref.invalidateSelf();
    return result;
  }
}
