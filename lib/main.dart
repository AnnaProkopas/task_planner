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

  void deleteTask(BuildContext context, int index) async {
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop(false);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Continue"),
      onPressed: () {
        Task deletedTask = list.list[index];
        setState(() {
          list.removeAt(index);
        });
        Navigator.of(context).pop(true);
        db.delete(deletedTask);
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Submit delete"),
      content: Text("Are you sure you want to delete the \"" + list.list[index].text + "\" task?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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
            return ListTile(
                title: Text(
                  list.list[index].time == null ? '' : DateFormat('yyyy-MM-dd HH:mm').format(list.list[index].time!),
                ),
                subtitle: Text(list.list[index].text, style: taskStateToColor(list.list[index].state)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () {
                          editTask(index);
                        },
                        icon: const Icon(Icons.edit)),
                    IconButton(
                        onPressed: () {
                          deleteTask(context, index);
                        },
                        icon: const Icon(Icons.delete)),
                  ],
                ));
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
