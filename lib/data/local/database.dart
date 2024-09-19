import 'dart:async';
import 'dart:io';
import 'package:birthday_beacon/data/models/birthday.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const String _databaseName = 'birthdays.db';
  static const String _tableName = 'birthdays_table';

  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  DatabaseHelper._();

  factory DatabaseHelper() {
    _databaseHelper ??= DatabaseHelper._();
    return _databaseHelper!;
  }

  Future<Database> _initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, _databaseName);
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  FutureOr<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName(
        id INTEGER PRIMARY KEY,
        firstName TEXT,
        lastName TEXT, 
        imagePath TEXT, 
        birthdate INTEGER,
        relationship TEXT, 
        notifyOnBirthday INTEGER, 
        notifyOneDayBeforeBirthday INTEGER, 
        notifyTwoDaysBeforeBirthday INTEGER, 
        notifyOneWeekBeforeBirthday INTEGER,
        color INTEGER
      )
    ''');
  }

  // CRUD operations

  Future<List<Birthday>> getBirthdays() async {
    try {
      final database = await this.database;
      final result = await database.query(_tableName);
      List<Birthday> birthdays = result.isNotEmpty ? result.map((x) => Birthday.fromDatabase(x)).toList() : [];
      return birthdays;
    } on DatabaseException catch (_) {
      return [];
    }
  }

  Future<int> addBirthday(Birthday birthday) async {
    try {
      final database = await this.database;
      return database.insert(_tableName, birthday.toDatabase(), conflictAlgorithm: ConflictAlgorithm.replace);
    } on DatabaseException catch (_) {
      return 0;
    }
  }

  Future<int> removeBirthday(Birthday birthday) async {
    try {
      final database = await this.database;
      return database.delete(_tableName, where: 'id = ?', whereArgs: [birthday.id]);
    } on DatabaseException catch (_) {
      return 0;
    }
  }
}
