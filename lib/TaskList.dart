class TaskList {
  List<Task> list = List.empty(growable: true);

  TaskList();

  void addTask(int? id, String text, TaskState state, DateTime? time) {
    list.add(Task(id: id, text: text, time: time, state: TaskState.wait));
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
}

class Task {
  Task({this.id, required this.text, required this.state, this.time});

  int? id;
  String text = '';
  DateTime? time;
  TaskState state = TaskState.wait;
}

enum TaskState {
  wait,
  inProgress,
  done,
}
