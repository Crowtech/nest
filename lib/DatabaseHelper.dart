//import 'dart:html';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:flutter_test/flutter_test.dart';

DatabaseHelper dbHelper = new DatabaseHelper();

// Path provider: https://pub.dartlang.org/packages/path_provider#-installing-tab-
class DatabaseHelper {
  static const String dbName = "database";
  static const String tokenTable = "tokens";
  //static const String baseEntityTable = "BaseEntity";
   static const String dummytable = "dummytable";


  static final DatabaseHelper instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => instance;

  static Database _db;

  DatabaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) {
      print("Database Online");
      return _db;
    }
    _db = await initDb();
    if (_db != null) {
      print("Database Initialized");
    }
    return _db;
  }

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(
        documentDirectory.path, "$dbName"); //home://directory/files/maindb.db
    return await openDatabase(path, version: 1, onCreate: createGennyTable);
  }

  void createGennyTable(Database db, version) async {
    print("Success");
    print(db);
    print("this is the function createTable ");
    createTokenTables(db, version);
 
    
      }

  void createTokenTables(Database db, int version) async {
    var query =
        "CREATE TABLE '$tokenTable'('id' INTEGER PRIMARY KEY,'token' TEXT)";
    executeQuery(db, query);
  }


  void executeQuery(Database db, query) async {
    await db.execute(query);
    //db.close();
  }

  //CRUD Operations

  
  Future<int> insertInToDB(Map item, tableName) async {
    var dbClient = await db;
    int result = await dbClient.insert("$tableName", item);
    return result;
  }

/* fetching all values from database */

  Future<List<Map<String, dynamic>>> retrievedummy(constraints) {
    return retrieveFromDB("$dummytable", constraints);
  }

  Future<List<Map<String, dynamic>>> retrieveFromDB(
      String tableName, String constraints) async {
    var dbClient = await db;
    var result;
    String query;

    if (constraints != null) {
      query = "SELECT * FROM '$tableName' $constraints";
    } else {
      query = "SELECT * FROM '$tableName' ";
    }

    result = await dbClient.rawQuery(query);
    // result = await dbClient.query(query);

    if (result.length == 0) return null;
    return result;
  }

 

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }

  Future<List<Map<String, dynamic>>> debugFunction(String query) async {
    var dbClient = await db;
    var result = dbClient.rawQuery(query);
    return result;
  }
}
