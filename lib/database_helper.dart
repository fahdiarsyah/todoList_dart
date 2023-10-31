import 'package:todo_list/todo.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;


class DatabaseHelper {
  // Single Turn Pattern
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;
  static Database? _db;

  // async koneksi database yang sifatnya tertunda 
  // await berjalan sesuai antrian
  Future<Database?> get db async{
    if(_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  // Membuat Database
  Future<Database?> initDb() async {
    io.Directory docDirectory = await getApplicationDocumentsDirectory();
    String path = join(docDirectory.path, 'todolist.db');
    var localDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return localDb;
  }

  // Membuat Tabel
  void _onCreate(Database db, int version) async {
    await db.execute('''
    create table if not exists todos(
      id integer primary key autoincrement,
      nama text not null,
      deskripsi text not null,
      checkmark integer not null default 0
    )''');
  }

  // Read Data Tabel
  Future<List<Todo>> getAllTodos() async {
    var dbClient = await db;
    var todos = await dbClient!.query('todos');
    return todos.map((todo) => Todo.fromMap(todo)).toList();
  }

  // Tambah Data Tabel
  Future<int> addTodo(Todo todo) async {
    var dbClient = await db;
    return await dbClient!.insert('todos', todo.mapDatabase(), conflictAlgorithm: ConflictAlgorithm.replace);
    // ConflictAlgorithm.replace untuk mengganti nilai unique
  }

  // Edit Data Tabel
  Future<int> updateTodo(Todo todo) async {
    var dbClient = await db;
    return await dbClient!.update('todos', todo.mapDatabase(), where: 'id = ?', whereArgs: [todo.id]);
  }

  // Delete Data Tabel
  Future<int> deleteTodo(int id) async {
    var dbClient = await db;
    return await dbClient!.delete('todos', where: 'id = ?', whereArgs: [id]);
  }
}