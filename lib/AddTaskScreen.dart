import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:task_planner/TaskList.dart';

class AddTaskScreen extends StatefulWidget {
  static const String id = "add_task";

  @override
  State<StatefulWidget> createState() => AddTaskScreenState();
}

class AddTaskScreenState extends State<AddTaskScreen> {
  String taskText = "";
  DateTime? taskTime;

  void apply(BuildContext context) {
    Navigator.pop(context, Task(text: taskText, state: TaskState.wait, time: taskTime));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add task"),
        ),
        body: Column(
          children: [
            TextField(
              onChanged: (value) => {taskText = value},
              decoration: const InputDecoration(
                labelText: 'Task text',
              ),
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              elevation: 4.0,
              onPressed: () {
                DatePicker.showDateTimePicker(context,
                    theme: const DatePickerTheme(
                      containerHeight: 210.0,
                    ),
                    showTitleActions: true, onConfirm: (time) {
                  taskTime = time;
                  setState(() {});
                }, currentTime: DateTime.now(), locale: LocaleType.en);
                setState(() {});
              },
              child: Container(
                alignment: Alignment.center,
                height: 50.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          child: Row(
                            children: <Widget>[
                              const Icon(
                                Icons.access_time,
                                size: 18.0,
                                color: Colors.blue,
                              ),
                              Text(
                                taskTime == null ? '' : DateFormat('yyyy-MM-dd HH:mm').format(taskTime!),
                                style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 18.0),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const Text(
                      "  Change",
                      style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                  ],
                ),
              ),
              color: Colors.white,
            ),
            FloatingActionButton.extended(
              icon: const Icon(Icons.save),
              label: const Text('Save'),
              onPressed: () {
                apply(context);
              },
              shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
            ),
          ],
        ));
  }
}
