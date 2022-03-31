import 'package:flutter/material.dart';
import 'package:task_planner/TaskDB.dart';
import 'package:task_planner/TaskList.dart';

import 'AddTaskScreen.dart';

void main() {
  runApp(MaterialApp(title: "Task planner", home: MainScreen(), routes: {
    MainScreen.id: (context) => MainScreen(),
    AddTaskScreen.id: (context) => AddTaskScreen(),
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

  @override
  Widget build(BuildContext context) {
    initDb();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo list"),
      ),
      body: ListView.builder(
          itemCount: list.count(),
          itemBuilder: (context, index) {
            return Text(list.list[index].text);
          }),
      persistentFooterButtons: [
        FloatingActionButton(
          onPressed: addTodo,
        )
      ],
    );
  }

  void initDb() async {
    db.init();
  }

  void addTodo() async {
    // ...
  }
}
