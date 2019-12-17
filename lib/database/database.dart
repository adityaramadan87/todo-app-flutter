import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:learnflutter/model/todo_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {

  static DatabaseHelper _databaseHelper;
  static Database _database;

  String taskTable = 'task_table';
  String colId = 'id';
  String colTask = 'task';
  String colDate = 'date';
  String colPriority = 'priority';
  
  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null){
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }
  Future<Database> get database async {
    if (_database == null){
      _database = await initializeDatabase();
    }
    return _database;
  }
  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'todo.db';

    var todoDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return todoDatabase;
  }
  void _createDb(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $taskTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTask TEXT, $colDate TEXT, $colPriority INTEGER)');
  }
  //get
  Future<List<Map<String, dynamic>>> getTaskList() async {
    Database db = await this.database;
    var result = await db.query(taskTable, orderBy: '$colPriority ASC');
    return result;
  }
  //create
  Future<int> insertTask(Todo todo) async {
    Database db = await this.database;
    var result = await db.insert(taskTable, todo.toMap());
    return result;
  }
  //update
  Future<int> updateTask(Todo todo) async {
		var db = await this.database;
		var result = await db.update(taskTable, todo.toMap(), where: '$colId = ?', whereArgs: [todo.id]);
		return result;
  }
  //delete
  Future<int> deleteTask(int id) async {
		var db = await this.database;
		int result = await db.rawDelete('DELETE FROM $taskTable WHERE $colId = $id');
		return result;
	}

	// Get number of Todo
	Future<int> getCount() async {
		Database db = await this.database;
		List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $taskTable');
		int result = Sqflite.firstIntValue(x);
		return result;
  }
  Future<List<Todo>> getTodoList() async {

		var todoMapList = await getTaskList();
		int count = todoMapList.length;         

		List<Todo> todoList = List<Todo>();
		for (int i = 0; i < count; i++) {
			todoList.add(Todo.fromMapObject(todoMapList[i]));
		}

		return todoList;
}
}