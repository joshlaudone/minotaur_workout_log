import 'dart:io';
import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'muscle_group.dart';
import 'exercise.dart';

class DatabaseManager {
  DatabaseManager._privateConstructor();
  static final DatabaseManager instance = DatabaseManager._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'minotaur_log.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE muscle_group(
        id   INTEGER                            PRIMARY KEY,
        name TEXT CHECK( LENGTH(name) <= 100 )  NOT NULL DEFAULT ''
      );
    ''');
    await db.execute('''
      CREATE TABLE exercise(
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

  Future<List<MuscleGroup>> getMuscleGroups() async {
    Database db = await instance.database;
    var muscleGroups = await db.query('muscle_group', orderBy: 'name');
    List<MuscleGroup> muscleGroupList = muscleGroups.isNotEmpty
        ? muscleGroups.map((c) => MuscleGroup.fromMap(c)).toList()
        : [];
    return muscleGroupList;
  }

  Future<List<Exercise>> getExercises() async {
    Database db = await instance.database;
    var exercises = await db.query('exercise', orderBy: 'name');
    List<Exercise> exerciseList = exercises.isNotEmpty
        ? exercises.map((c) => Exercise.fromMap(c)).toList()
        : [];
    return exerciseList;
  }

  Future<int> add(Exercise exercise) async {
    Database db = await instance.database;
    return await db.insert('exercise', exercise.toMap());
  }
}
