import 'package:flutter_start/model/person.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class PersonHelperSqlite {
  late Future<Database> database;

  PersonHelperSqlite() {
    database = getDatabase();
  }

  Future<Database> getDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'person.db'),
      onCreate: (database, version) {
        String sqlCreate = """
        Create Table person (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          code TEXT NOT NULL,
          name TEXT NOT NULL,
          gender INTEGER,
          homeTown TEXT,
          mark REAL
         );
      """;
        return database.execute(sqlCreate);
      },
      version: 1,
    );
  }

  Future<List<Person>> getPersons() async {
    final db = await database;
    final List<Map<String, dynamic>> personMap = await db.query('person');

    return personMap
        .map((map) => Person(
              code: map['code'],
              name: map['name'],
              gender: map['gender'] == 1 ? true : false,
              homeTown: map['homeTown'],
              mark: map['mark'],
              id: map['id'],
            ))
        .toList();
  }

  Future<int> insertPerson(Person person) async {
    final db = await database;

    return await db.insert(
      'person',
      person.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updatePerson(Person person) async {
    final db = await database;

    await db.update(
      'person',
      person.toMap(),
      where: "id = ?",
      whereArgs: [person.id],
    );
  }

  Future<void> deletePerson(int id) async {
    final db = await database;

    await db.delete(
      'person',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
