import 'package:flutter/material.dart';

class TaskList {
  List<Task> list = List.empty(growable: true);

  TaskList();

  void addTask(int? id, String text, TaskState state, DateTime? time, bool? isNotify) {
    list.add(Task(id: id, text: text, time: time, state: state, isNotify: isNotify ?? false));
  }

  int count() {
    return list.length;
  }

  Task last() {
    return list.last;
  }

  void add(Task task) {
    list.add(task);
  }

  void update(int index, Task task) {
    list[index] = task;
  }

  void removeAt(int index) {
    list.removeAt(index);
  }
}

class Task {
  Task({this.id, required this.text, required this.state, this.time, this.isNotify = false});

  int? id;
  String text = '';
  DateTime? time;
  TaskState state = TaskState.wait;
  bool isNotify = false;
}

enum TaskState {
  wait,
  inProgress,
  done,
}

const Map<TaskState, String> taskStateToEnText = {TaskState.wait: 'Wait', TaskState.inProgress: 'In progress', TaskState.done: 'Done'};
const Map<TaskState, IconData> taskStateToIcon = {
  TaskState.wait: Icons.access_time,
  TaskState.inProgress: Icons.directions_run,
  TaskState.done: Icons.done
};
const Map<TaskState, Color> taskStateToColor = {
  TaskState.wait: Colors.deepOrangeAccent,
  TaskState.inProgress: Colors.green,
  TaskState.done: Colors.blueGrey
};
