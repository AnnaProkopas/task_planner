import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:intl/intl.dart';
import 'package:task_planner/TaskDB.dart';
import 'package:task_planner/TaskList.dart';
import 'package:timezone/data/latest_10y.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'AddTaskScreen.dart';
import 'EditTaskScreen.dart';
import 'LoadingScreen.dart';

final localNotificationsPlugin = FlutterLocalNotificationsPlugin();

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
      if (result.time != list.list[index].time && list.list[index].isNotify) {
        localNotificationsPlugin.cancel(result.id!);
        result.isNotify = false;
      }
      setState(() {
        list.update(index, result);
      });
      db.update(result);
    }
  }

  void setNextState(int index) async {
    TaskState nextState = TaskState.wait;
    if (list.list[index].state == TaskState.wait) {
      nextState = TaskState.inProgress;
    } else if (list.list[index].state == TaskState.inProgress) {
      nextState = TaskState.done;
    }

    setState(() {
      list.list[index].state = nextState;
    });
    db.update(list.list[index]);
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
        if (list.list[index].isNotify) {
          localNotificationsPlugin.cancel(list.list[index].id!);
        }
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

  void showNotification(int index) async {
    var notificationDetails = const NotificationDetails(
        android: AndroidNotificationDetails(
      '123456',
      'My channel',
      channelDescription: 'Description',
      channelShowBadge: true,
      priority: Priority.high,
      importance: Importance.max,
      icon: "meditation_icon_background",
    ));

    Task task = list.list[index];

    if (!task.isNotify && task.time != null && task.time!.isAfter(DateTime.now())) {
      await localNotificationsPlugin.zonedSchedule(task.id!, 'Task time', task.text,
          tz.TZDateTime.now(tz.local).add(Duration(seconds: task.time!.difference(DateTime.now()).inSeconds)), notificationDetails,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime, androidAllowWhileIdle: true);

      setState(() {
        list.list[index].isNotify = true;
      });
    } else {
      await localNotificationsPlugin.cancel(task.id!);

      setState(() {
        list.list[index].isNotify = false;
      });
    }
  }

  TextStyle taskStateToTextStyle(TaskState state) {
    if (state == TaskState.done) {
      return const TextStyle(decoration: TextDecoration.lineThrough);
    }
    return const TextStyle();
  }

  bool canAddNotification(Task task) {
    print(task.time != null && task.time!.isAfter(DateTime.now().add(const Duration(minutes: 1))));
    return task.time != null && task.time!.isAfter(DateTime.now().add(const Duration(minutes: 1)));
  }

  void iniTimeZone() async {
    tz.initializeTimeZones();
  }

  @override
  void initState() {
    super.initState();
    initDb();
    iniTimeZone();
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
                leading: IconButton(
                  icon: Icon(taskStateToIcon[list.list[index].state]!),
                  color: taskStateToColor[list.list[index].state]!,
                  onPressed: () {
                    setNextState(index);
                  },
                ),
                title: Text(
                  list.list[index].time == null ? '' : DateFormat('yyyy-MM-dd HH:mm').format(list.list[index].time!),
                ),
                subtitle: Text(list.list[index].text, style: taskStateToTextStyle(list.list[index].state)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: canAddNotification(list.list[index])
                          ? () {
                              showNotification(index);
                            }
                          : null,
                      icon: list.list[index].isNotify
                          ? const Icon(
                              Icons.notifications_active,
                              color: Colors.black,
                            )
                          : Icon(
                              Icons.notifications_off,
                              color: canAddNotification(list.list[index]) ? Colors.black : Colors.blueGrey,
                            ),
                    ),
                    IconButton(
                        onPressed: () {
                          editTask(index);
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.black,
                        )),
                    IconButton(
                        onPressed: () {
                          deleteTask(context, index);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.black,
                        )),
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
