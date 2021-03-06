import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_planner/TaskList.dart';

const String tableTask = 'task';
const String columnId = 'id';
const String columnText = 'text';
const String columnTime = 'time';
const String columnState = 'state';
const String columnIsNotify = 'isNotify';

class TaskDB {
  Database? _db;
  Future<Database> get db async {
    return _db ?? await init();
  }

  TaskDB();

  Future<Database> init() async {
    Database database = await openDatabase(
      "db.db",
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
            CREATE TABLE $tableTask (
              $columnId INTEGER PRIMARY KEY AUTOINCREMENT, 
              $columnText TEXT not null, 
              $columnTime TEXT, 
              $columnState INTEGER not null,
              $columnIsNotify BOOLEAN not null);
            ''');
      },
    );
    _db = database;
    return database;
  }

  Future<TaskList> getAllTasks() async {
    Database database = await db;
    List<Map> maps = await database.query(tableTask,
        columns: [columnId, columnText, columnTime, columnState, columnIsNotify], orderBy: "$columnState asc, $columnId asc");
    TaskList list = TaskList();
    for (var map in maps) {
      list.addTask(map[columnId], map[columnText], TaskState.values[map[columnState]],
          map[columnTime] == null ? null : DateTime.parse(map[columnTime]), map[columnIsNotify] > 0);
    }
    return list;
  }

  Future<int> insert(Task task) async {
    Database? database = await db;
    int id = await database.insert(tableTask, <String, Object?>{
      columnText: task.text,
      columnTime: task.time == null ? null : DateFormat('yyyy-MM-dd HH:mm').format(task.time!),
      columnState: task.state.index,
      columnIsNotify: task.isNotify ? 1 : 0,
    });
    return id;
  }

  Future<int> update(Task task) async {
    Database? database = await db;
    int id = await database.update(
        tableTask,
        <String, Object?>{
          columnText: task.text,
          columnTime: task.time == null ? null : DateFormat('yyyy-MM-dd HH:mm').format(task.time!),
          columnState: task.state.index,
          columnIsNotify: task.isNotify ? 1 : 0,
        },
        where: '$columnId = ?',
        whereArgs: [task.id]);
    return id;
  }

  void delete(Task task) async {
    Database? database = await db;
    database.delete(tableTask, where: '$columnId = ?', whereArgs: [task.id]);
  }
}
