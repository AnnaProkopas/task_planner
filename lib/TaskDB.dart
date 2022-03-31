import 'package:sqflite/sqflite.dart';
import 'package:task_planner/TaskList.dart';

const String tableTask = 'task';
const String columnId = 'id';
const String columnText = 'text';
const String columnTime = 'time';
const String columnState = 'state';

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
              $columnState INTEGER not null);
            ''');
      },
    );
    _db = database;
    return database;
  }

  Future<TaskList> getAllTasks() async {
    Database database = await db;
    List<Map> maps = await database.query(tableTask,
        columns: [columnId, columnText, columnTime, columnState],
        orderBy: "$columnTime desc");
    TaskList list = TaskList();
    for (var map in maps) {
      list.addTask(
          map[columnText], TaskState.values[map[columnState]], map[columnTime]);
    }
    return list;
  }

  Future<int> insert(Task task) async {
    Database? database = await db;
    int id = await database.insert(tableTask, <String, Object?>{
      columnText: task.text,
      columnTime: task.time,
      columnState: task.state.index,
    });
    return id;
  }
}
