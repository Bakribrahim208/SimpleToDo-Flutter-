import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:to_do_app/model/todo.dart';


class DbHelper {
  static final DbHelper dbHelper = DbHelper._internal();

  String tableTODO = "ToDo";
  String colID = "id";
  String colTitle = "title";
  String colDescription = "description";
  String colProiorty = "proiority";
  String colDate = "date";


  static Database? _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await initailzeDB();
    }
    return _db!;
  }


  DbHelper._internal();

  factory DbHelper(){
    return dbHelper;
  }


  Future<Database> initailzeDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "todo.db";
    var dbTodo = await openDatabase(path, version: 1, onCreate: _createDB);
    return dbTodo;
  }


  void _createDB(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tableTODO ($colID INTEGER PRIMARY KEY, $colTitle TEXT, $colDescription TEXT, $colProiorty INTEGER,$colDate TEXT)');
  }


  Future<int> insert(ToDo toDo) async {
    Database db = await this.db;
    var result = db.insert(tableTODO, toDo.toMap());

    return result;
  }
  Future<int> update(ToDo toDo) async {
    Database db = await this.db;
    var result = db.update(tableTODO, toDo.toMap(),
    where: "$colID = ?",whereArgs: [toDo.id]);

    return result;
  }

  Future<int> delete(int id) async {
    Database db = await this.db;
    var result = db.rawDelete("DELETE  FROM  $tableTODO WHERE $colID=$id");

    return result ;
  }


  Future<List> getToDo() async {
    Database db = await this.db;
    var result = db.rawQuery("SELECT * FROM $tableTODO order by $colProiorty ASC");

    return result;
  }


  Future<int> getCount() async {
    Database db = await this.db;
    var result =  Sqflite.firstIntValue(
      await db.rawQuery("SELECT count (*) FROM $tableTODO")
    );

    return result!;
  }


}