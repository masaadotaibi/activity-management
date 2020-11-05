import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/personal_folder_collection.dart';

class TaskCard extends StatelessWidget {
  final String uid;
  final TaskModel task;

  const TaskCard({Key key, this.uid, this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                task.taskTitle,
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Checkbox(
            //     value: true, // task.state,
            //     onChanged: (newValue) {
            //       Database().updateTaskStatus(newValue, uid, task.taskId);
            //     })
          ],
        ),
      ),
    );
  }
}
