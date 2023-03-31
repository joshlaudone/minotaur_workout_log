import 'dart:io';
import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'muscle.dart';
import 'exercise.dart';

class DatabaseManager {
  DatabaseManager._privateConstructor();
  static final DatabaseManager instance = DatabaseManager._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  static const String databaseFile = 'minotaur_log.db';
  static const String muscleTable = 'muscle';
  static const String exerciseTable = 'exercise';
  static const String exercise = 'exercise';

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, databaseFile);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onConfigure: _onConfigure,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $muscleTable(
        id   INTEGER                            PRIMARY KEY,
        name TEXT CHECK( LENGTH(name) <= 100 )  NOT NULL DEFAULT ''
      );
    ''');
    await db.execute('''
      CREATE TABLE $exerciseTable(
        id          INTEGER                                  PRIMARY KEY,
        name        TEXT CHECK( LENGTH(name) <= 100 )        NOT NULL DEFAULT '',
        description TEXT CHECK( LENGTH(name) <= 1000 )       NOT NULL DEFAULT '',
        units       TEXT CHECK( units IN ('lbs', 'kilos') )  NOT NULL DEFAULT 'lbs',
        increment   REAL                                     NOT NULL DEFAULT '5'
      );
    ''');
    await db.insert(
      'exercise',
      Exercise(
              name: "Squat",
              description: "SKWAAT",
              units: Unit.pounds,
              increment: 5.0)
          .toMap(),
    );
    await db.insert(
      'exercise',
      Exercise(
              name: "Bench",
              description: "BANCH",
              units: Unit.pounds,
              increment: 5.0)
          .toMap(),
    );
    await db.insert(
      'exercise',
      Exercise(
              name: "Deadlift",
              description: "Diddly-do",
              units: Unit.kilos,
              increment: 5.0)
          .toMap(),
    );
  }

  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<List<Muscle>> getMuscles() async {
    Database db = await instance.database;
    var muscles = await db.query(muscleTable, orderBy: 'name');
    List<Muscle> muscleList = muscles.isNotEmpty
        ? muscles.map((c) => Muscle.fromMap(c)).toList()
        : [];
    return muscleList;
  }

  Future<List<Exercise>> getExercises() async {
    Database db = await instance.database;
    var exercises = await db.query(exerciseTable, orderBy: 'name');
    List<Exercise> exerciseList = exercises.isNotEmpty
        ? exercises.map((c) => Exercise.fromMap(c)).toList()
        : [];
    return exerciseList;
  }

  Future<int> addMuscleGroup(Muscle muscleGroup) async {
    Database db = await instance.database;
    return await db.insert(muscleTable, muscleGroup.toMap());
  }

  Future<int> addExercise(Exercise exercise) async {
    Database db = await instance.database;
    return await db.insert(exerciseTable, exercise.toMap());
  }

  Future<int> updateExercise(Exercise exercise) async {
    Database db = await instance.database;
    return await db.update(
      exerciseTable,
      exercise.toMap(),
      where: 'id = ?',
      whereArgs: [exercise.id],
    );
  }

  Future<int> removeExercise(int id) async {
    Database db = await instance.database;
    return await db.delete(exerciseTable, where: 'id = ?', whereArgs: [id]);
  }
}
