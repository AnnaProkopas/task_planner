import 'package:flutter/material.dart';

class AddTaskScreen extends StatelessWidget {
  static const String id = "add_task";

  String taskText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add task"),
        ),
        body: Column(
          children: [
            const Text("Description"),
            TextField(
              onChanged: (value) => {taskText = value},
            ),
            FloatingActionButton(
                child: const Icon(Icons.save),
                onPressed: () {
                  apply(context);
                }),
          ],
        ));
  }

  void apply(BuildContext context) {
    Navigator.pop(context);
  }
}
