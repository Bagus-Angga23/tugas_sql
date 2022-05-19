import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'model.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'Toko.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE Toko(
        id INTEGER PRIMARY KEY,
        name TEXT
    )
    ''');
  }

  Future<List<Toko>> getToko() async {
    Database db = await instance.database;
    var toko = await db.query('toko', orderBy: 'name');
    List<Toko> tokoList = toko.isNotEmpty
        ? toko.map((c) => Toko.fromMap(c)).toList()
        : [];
    return tokoList;
  }

  Future<int> add(Toko toko) async {
    Database db = await instance.database;
    return await db.insert('toko', toko.toMap());
  }

  Future<int> remove(int id) async {
    Database db = await instance.database;
    return await db.delete('toko', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(Toko toko) async {
    Database db = await instance.database;
    return await db.update('toko', toko.toMap(),
        where: "id = ?", whereArgs: [toko.id]);
  }
}
