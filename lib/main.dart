import 'package:flutter/material.dart';
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
            body: ListView.builder(
                itemCount: list.count(),
                itemBuilder: (context, index) {
                  return Text(list.list[index].text);
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
