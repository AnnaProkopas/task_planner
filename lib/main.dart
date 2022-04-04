import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_planner/TaskDB.dart';
import 'package:task_planner/TaskList.dart';
import 'AddTaskScreen.dart';
import 'LoadingScreen.dart';

void main() {
  runApp(MaterialApp(title: "Task planner", home: MainScreen(), routes: {
    MainScreen.id: (context) => MainScreen(),
    AddTaskScreen.id: (context) => AddTaskScreen(),
    LoadingScreen.id: (context) => LoadingScreen(),
  }));
}

class MainScreen extends StatefulWidget {
  static const String id = "main";

  @override
  State<StatefulWidget> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  TaskList list = TaskList();
  TaskDB db = TaskDB();

  Future<TaskList> initDb() async {
    await db.init();
    return db.getAllTasks();
  }

  void addTask() async {
    final Task result = await Navigator.pushNamed(context, AddTaskScreen.id) as Task;
    setState(() {
      list.list.add(result);
      db.insert(result);
    });
    // list = await db.getAllTasks();
  }

  void editTask() async {}

  TextStyle taskStateToColor(TaskState state) {
    if (state == TaskState.wait) {
      return const TextStyle(color: Colors.deepOrange);
    } else if (state == TaskState.inProgress) {
      return const TextStyle(color: Colors.green);
    } else {
      return const TextStyle(decoration: TextDecoration.lineThrough);
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<TaskList> _futureList = initDb();

    return FutureBuilder<TaskList>(
        future: _futureList,
        builder: (BuildContext context, AsyncSnapshot<TaskList> snapshot) {
          if (snapshot.hasData) {
            list = snapshot.data!;
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text("Task list"),
            ),
            body: ListView.separated(
                separatorBuilder: (BuildContext context, int index) => const Divider(),
                itemCount: list.count(),
                itemBuilder: (context, index) {
                  return Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                        Text(list.list[index].text, style: taskStateToColor(list.list[index].state)),
                        Text(
                          list.list[index].time == null ? '' : DateFormat('yyyy-MM-dd HH:mm').format(list.list[index].time!),
                        ),
                        IconButton(onPressed: editTask, icon: const Icon(Icons.edit))
                      ]));
                  // Text(list.list[index].text);
                }),
            persistentFooterButtons: [
              FloatingActionButton(
                child: const Text("+"),
                onPressed: addTask,
              )
            ],
          );
        });
  }
}
