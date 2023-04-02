import 'dart:io';
import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'muscle.dart';
import 'exercise.dart';
import 'workout_set.dart';
import 'session.dart';

class DatabaseManager {
  DatabaseManager._privateConstructor();
  static final DatabaseManager instance = DatabaseManager._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  static const String databaseFile = 'minotaur_log.db';
  static const String muscleTable = 'muscle';
  static const String exerciseTable = 'exercise';
  static const String exerciseMuscleTable = 'exerciseMuscle';
  static const String sessionTable = 'session';
  static const String setTable = 'workoutSet';

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
        name TEXT CHECK( LENGTH(name) <= 100 )  NOT NULL DEFAULT '' UNIQUE
      );
    ''');
    await db.execute('''
      CREATE TABLE $exerciseTable(
        id          INTEGER                                    PRIMARY KEY,
        name        TEXT CHECK( LENGTH(name) <= 100 )          NOT NULL DEFAULT '' UNIQUE,
        description TEXT CHECK( LENGTH(description) <= 1000 )  NOT NULL DEFAULT '',
        units       TEXT CHECK( units IN ('lbs', 'kilos') )    NOT NULL DEFAULT 'lbs',
        increment   REAL                                       NOT NULL DEFAULT 5
      );
    ''');
    await db.execute('''
      CREATE TABLE $exerciseMuscleTable(
        id         INTEGER   PRIMARY KEY,
        muscleRole INTEGER   NOT NULL DEFAULT '1',
        exerciseId INTEGER   NOT NULL,
        muscleId   INTEGER   NOT NULL,
        FOREIGN KEY(exerciseId) REFERENCES $exerciseTable(id),
        FOREIGN KEY(muscleId)   REFERENCES $muscleTable(id),
        UNIQUE(exerciseId, muscleId)
      );
    ''');
    await db.execute('''
      CREATE TABLE $sessionTable(
        id         INTEGER   PRIMARY KEY,
        date       TEXT      NOT NULL,
        duration   TEXT,
        comment    TEXT
      );
    ''');
    await db.execute('''
      CREATE TABLE $setTable(
        id  INTEGER  PRIMARY KEY,
        sessionId   INTEGER                                 NOT NULL,
        exerciseId  INTEGER                                 NOT NULL,
        setNumber   INTEGER                                 NOT NULL,
        setType     INTEGER                                 NOT NULL,
        weight      REAL,
        reps        INTEGER,
        distance    INTEGER,
        duration    TEXT,
        restTime    TEXT,
        rpe         REAL,
        comment     TEXT CHECK ( LENGTH(comment) <= 1000 ),
        UNIQUE(sessionId, setNumber)
      );
    ''');
    //FOREIGN KEY(sessionId) REFERENCES $sessionTable(id),
    //FOREIGN KEY(exerciseId) REFERENCES $exerciseTable(id),
  }

  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<bool> initializeDatabase() async {
    List<Exercise> exerciseList = await readExercises();
    if (exerciseList.isEmpty) {
      await createExercise(Exercise(
          name: "Squat",
          description: "SKWAAT",
          units: Unit.pounds,
          increment: 5.0));
      await createExercise(Exercise(
          name: "Bench",
          description: "BANCH",
          units: Unit.pounds,
          increment: 5.0));
      await createExercise(Exercise(
          name: "Deadlift",
          description: "Diddly-do",
          units: Unit.kilos,
          increment: 5.0));

      await createMuscle(Muscle(name: "Neck"));
      await createMuscle(Muscle(name: "Shoulders"));
      await createMuscle(Muscle(name: "Biceps"));
      await createMuscle(Muscle(name: "Triceps"));
      await createMuscle(Muscle(name: "Forearms"));
      await createMuscle(Muscle(name: "Back"));
      await createMuscle(Muscle(name: "Chest"));
      await createMuscle(Muscle(name: "Abs"));
      await createMuscle(Muscle(name: "Hips"));
      await createMuscle(Muscle(name: "Quads"));
      await createMuscle(Muscle(name: "Hamstrings"));
      await createMuscle(Muscle(name: "Calves"));
      await createMuscle(Muscle(name: "Olympic"));
      await createMuscle(Muscle(name: "Plyometric"));
      await createMuscle(Muscle(name: "Cardio"));
      await createMuscle(Muscle(name: "Conditioning"));

      //await createSession(Session(name: 'test'));
      return true;
    }
    return false;
  }

  Future<int> createExercise(Exercise exercise) async {
    Database db = await instance.database;
    return await db.insert(exerciseTable, exercise.toMap());
  }

  Future<List<Exercise>> readExercises() async {
    Database db = await instance.database;
    var exercises = await db.query(exerciseTable, orderBy: 'name');
    List<Exercise> exerciseList = exercises.isNotEmpty
        ? exercises.map((c) => Exercise.fromMap(c)).toList()
        : [];
    return exerciseList;
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

  Future<int> deleteExercise(int id) async {
    Database db = await instance.database;
    return await db.delete(exerciseTable, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> createMuscle(Muscle muscle) async {
    Database db = await instance.database;
    return await db.insert(muscleTable, muscle.toMap());
  }

  Future<List<Muscle>> readMuscles() async {
    Database db = await instance.database;
    var muscles = await db.query(muscleTable, orderBy: 'name');
    List<Muscle> muscleList = muscles.isNotEmpty
        ? muscles.map((c) => Muscle.fromMap(c)).toList()
        : [];
    return muscleList;
  }

  Future<int> updateMuscle(Muscle muscle) async {
    Database db = await instance.database;
    return await db.update(
      muscleTable,
      muscle.toMap(),
      where: 'id = ?',
      whereArgs: [muscle.id],
    );
  }

  Future<int> deleteMuscle(int id) async {
    Database db = await instance.database;
    return await db.delete(muscleTable, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> createSet(WorkoutSet set) async {
    Database db = await instance.database;
    if (set.setNumber == null) {
      var sets = await db.query(setTable);
      // TODO make this only grab for the session when that's implemented
      set.setNumber = sets.length;
    }
    return await db.insert(setTable, set.toMap());
  }

  Future<List<WorkoutSet>> readSets() async {
    Database db = await instance.database;
    var sets = await db.query(setTable, orderBy: 'id');
    List<WorkoutSet> setList =
        sets.isNotEmpty ? sets.map((c) => WorkoutSet.fromMap(c)).toList() : [];
    return setList;
  }

  Future<int> updateSet(WorkoutSet set) async {
    Database db = await instance.database;
    return await db.update(
      setTable,
      set.toMap(),
      where: 'id = ?',
      whereArgs: [set.id],
    );
  }

  Future<int> deleteSet(int id) async {
    Database db = await instance.database;
    return await db.delete(setTable, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> createSession(Session session) async {
    Database db = await instance.database;
    return await db.insert(sessionTable, session.toMap());
  }

  Future<List<Session>> readSessions() async {
    Database db = await instance.database;
    var sessions = await db.query(sessionTable, orderBy: 'id');
    List<Session> sessionList = sessions.isNotEmpty
        ? sessions.map((c) => Session.fromMap(c)).toList()
        : [];
    return sessionList;
  }

  Future<int> updateSession(Session session) async {
    Database db = await instance.database;
    return await db.update(
      sessionTable,
      session.toMap(),
      where: 'id = ?',
      whereArgs: [session.id],
    );
  }

  Future<int> deleteSession(int id) async {
    Database db = await instance.database;
    return await db.delete(sessionTable, where: 'id = ?', whereArgs: [id]);
  }
}
