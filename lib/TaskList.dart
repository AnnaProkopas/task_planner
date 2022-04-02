class TaskList {
  List<Task> list = List.empty(growable: true);

  TaskList();

  void addTask(String text, TaskState state, DateTime? time) {
    list.add(Task(text: text, time: time, state: TaskState.wait));
  }

  int count() {
    return list.length;
  }

  Task last() {
    return list.last;
  }
}

class Task {
  Task({required this.text, required this.state, this.time});

  String text = '';
  DateTime? time;
  TaskState state = TaskState.wait;
}

enum TaskState {
  wait,
  inProgress,
  done,
}
