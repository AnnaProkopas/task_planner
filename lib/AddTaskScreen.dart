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
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
        appBar: AppBar(
          title: const Text("Add task"),
        ),
        body: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  initialValue: taskText,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    taskText = value;
                  },
                  onSaved: (value) {
                    setState(() => taskText = value!);
                  },
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
                                    ' ' + (taskTime == null ? '' : DateFormat('yyyy-MM-dd HH:mm').format(taskTime!)),
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
                ElevatedButton(
                  child: const Text('Save'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      apply(context);
                    }
                  },
                ),
              ],
            )));
  }
}
