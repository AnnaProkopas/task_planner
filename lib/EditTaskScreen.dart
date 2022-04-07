import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

import 'TaskList.dart';

class EditTaskScreen extends StatefulWidget {
  static const String id = "edit_task";
  final Task task;

  EditTaskScreen(this.task);

  @override
  State<StatefulWidget> createState() => EditTaskScreenState(task: task);
}

class EditTaskScreenState extends State<EditTaskScreen> {
  Task task;
  String taskText = '';
  DateTime? taskTime;
  TaskState taskState = TaskState.wait;

  EditTaskScreenState({required this.task}) {
    taskText = task.text;
    taskTime = task.time;
    taskState = task.state;
  }

  void apply(BuildContext context) {
    Navigator.pop(context, Task(id: task.id, text: taskText, state: taskState, time: taskTime));
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
        appBar: AppBar(
          title: const Text("Edit task"),
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
                    }, currentTime: taskTime ?? DateTime.now(), locale: LocaleType.en);
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
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(3)), color: Color(0xFFFFFFFF)),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                        canvasColor: const Color(0xFFFFFFFF),
                        buttonTheme: ButtonTheme.of(context).copyWith(
                          alignedDropdown: true,
                        )),
                    child: DropdownButton<TaskState>(
                      value: taskState,
                      elevation: 16,
                      onChanged: (TaskState? newValue) {
                        setState(() {
                          taskState = newValue!;
                        });
                      },
                      items: TaskState.values.map<DropdownMenuItem<TaskState>>((TaskState value) {
                        return DropdownMenuItem<TaskState>(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                    ),
                  ),
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
