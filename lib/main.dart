import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_planner/TaskDB.dart';
import 'package:task_planner/TaskList.dart';
import 'AddTaskScreen.dart';
import 'EditTaskScreen.dart';
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

  Future<void> initDb() async {
    await db.init();
    list = await db.getAllTasks();
    setState(() {});
  }

  void addTask() async {
    final result = await Navigator.pushNamed(context, AddTaskScreen.id);
    if (result != null) {
      result as Task;
      int index = list.count();
      setState(() {
        list.add(result);
      });

      int id = await db.insert(result);
      setState(() {
        list.list[index].id = id;
      });
    }
  }

  void editTask(int index) async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => EditTaskScreen(list.list[index])));
    if (result != null) {
      result as Task;
      setState(() {
        list.update(index, result);
      });
      db.update(result);
    }
  }

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
  void initState() {
    super.initState();
    initDb();
  }

  @override
  Widget build(BuildContext context) {
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
                  IconButton(
                      onPressed: () {
                        editTask(index);
                      },
                      icon: const Icon(Icons.edit))
                ]));
          }),
      persistentFooterButtons: [
        FloatingActionButton(
          child: const Text("+"),
          onPressed: addTask,
        )
      ],
    );
  }
}
