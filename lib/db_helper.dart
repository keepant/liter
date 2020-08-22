import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> initDb() async {
  final database = openDatabase(
    join(await getDatabasesPath(), 'doggie_database.db'),
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE dogs(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age INTEGER)",
      );
    },
    version: 1,
  );
  return database;
}

Future<void> insertDog(Dog dog) async {
  final Database db = await initDb();
  await db.insert(
    'dogs',
    dog.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<Dog>> dogs() async {
  final Database db = await initDb();
  final List<Map<String, dynamic>> maps = await db.query('dogs');
  return List.generate(maps.length, (i) {
    return Dog(
      id: maps[i]['id'],
      name: maps[i]['name'],
      age: maps[i]['age'],
    );
  });
}

Future<void> updateDog(Dog dog) async {
  final db = await initDb();

  await db.update(
    'dogs',
    dog.toMap(),
    where: "id = ?",
    whereArgs: [dog.id],
  );
}

Future<void> deleteDog(int id) async {
  final db = await initDb();

  await db.delete(
    'dogs',
    where: "id = ?",
    whereArgs: [id],
  );
}

var fido = Dog(
  id: 0,
  name: 'Fido',
  age: 35,
);

class Dog {
  final int id;
  final String name;
  final int age;

  Dog({this.id, this.name, this.age});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }
}
