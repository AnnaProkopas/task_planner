class TaskList {
  List<Task> list = List.empty(growable: true);

  TaskList() {
    list.add(Task(text: "Go on lesson", state: TaskState.wait));
    list.add(Task(text: "Go in library", state: TaskState.wait));
    list.add(Task(text: "Go to sleep", state: TaskState.wait));
  }

  void addTask(String text, TaskState state, DateTime? time) {
    list.add(Task(text: text, time: time, state: TaskState.wait));
  }

  int count() {
    return list.length;
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
