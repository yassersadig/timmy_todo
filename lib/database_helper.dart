import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:timmy_todo/todo_item_model.dart';

class DatabaseHelper {
  static Database? _db;

  Future<Database> get database async {
    return _db ??= await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    final db = openDatabase(
      join(await getDatabasesPath(), 'todo_list.db'),
      onCreate: _onCreate,
      version: 1,
    );
    return db;
  }

  _onCreate(db, version) async {
    return db.execute(
      'CREATE TABLE items(id INTEGER PRIMARY KEY, title TEXT, subtitle TEXT, isDone Integer)',
    );
  }

  Future<void> addItem(TodoItem item) async {
    final db = await database;
    final itemMap = item.toMap();
    itemMap.remove('id');
    await db.insert(
      'items',
      itemMap,
    );
  }

  Future<List<TodoItem>> getItems(bool pending) async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'items',
      columns: ['id', 'title', 'subtitle', 'isDone'],
      where: 'isDone = ?',
      whereArgs: [pending ? 1 : 0],
      orderBy: 'id DESC'
    );
    return List.generate(
      maps.length,
      (index) {
        return TodoItem.fromMap(maps[index]);
      },
    );
  }

  Future<void> updateItem(TodoItem item) async {
    final db = await database;

    await db.update(
      'items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }
}
