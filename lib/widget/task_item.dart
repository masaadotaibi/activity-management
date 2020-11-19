import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/task.dart';

class TaskItem extends StatelessWidget {
  final TaskModel task;
  final Function tickTask;

  TaskItem({this.task, this.tickTask});

  @override
  Widget build(BuildContext context) {
    final _stateColorIndicator = task.state == 'in-progress'
        ? Colors.green
        : task.state == 'not-started'
            ? Colors.orange[700]
            : task.state == 'overdue'
                ? Colors.red
                : Colors.grey[350];

    final _priorityColorIndicator = task.priority == 'high'
        ? Colors.red[800]
        : task.priority == 'medium'
            ? Colors.yellow[800]
            : Colors.blue;

    final _priorityFontWeight =
        task.priority == 'high' ? FontWeight.w900 : FontWeight.w700;

    return Card(
      elevation: 0,
      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 3),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 18,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(width: 4, color: _stateColorIndicator),
                  ),
                  child: Material(
                    shape: CircleBorder(),
                    child: InkWell(
                      onTap: () {
                        tickTask(task.taskId, task.state);
                      },
                      enableFeedback: true,
                      focusColor: _stateColorIndicator,
                      highlightColor: _stateColorIndicator,
                      hoverColor: _stateColorIndicator,
                      splashColor: _stateColorIndicator,
                      child: task.state == 'completed'
                          ? Icon(
                              Icons.check_circle,
                              size: 24.0,
                              color: _stateColorIndicator,
                            )
                          : Icon(
                              Icons.circle,
                              size: 24.0,
                              color: _stateColorIndicator.withOpacity(0.15),
                            ),
                    ),
                  ),
                ),
              ),
              // CircularCheckBox(
              //   value: false,
              //   onChanged: (_) {
              //     tickTask(task.taskId);
              //   },
              //   inactiveColor: _stateColorIndicator,
              //   checkColor: _stateColorIndicator,
              //   focusColor: _stateColorIndicator,
              //   activeColor: _stateColorIndicator,
              //   hoverColor: _stateColorIndicator,
              // )
            ),
            Expanded(
              flex: 61,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 7),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      task.taskTitle,
                      style: task.state == 'completed'
                          ? Theme.of(context).textTheme.headline6.copyWith(
                                decoration: TextDecoration.lineThrough,
                                decorationThickness: 1.7,
                                color: Colors.grey[500],
                              )
                          : Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  SizedBox(height: 5),
                  task.dueDate == null
                      ? Text("")
                      : Text(
                          "  ${DateFormat.yMMMd().format(task.dueDate)}",
                          style: TextStyle(
                            color: task.state == 'completed'
                                ? Colors.grey[400]
                                : task.state == 'overdue'
                                    ? Colors.red
                                    : Colors.grey[600],
                            decoration: task.state == 'completed'
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            fontSize: 16,
                          ),
                        ),
                  SizedBox(height: 7),
                ],
              ),
            ),
            Flexible(
              flex: 14,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.42,
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  task.priority == 'low'
                      ? '!'
                      : task.priority == 'high'
                          ? '!!!'
                          : '!!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: _priorityFontWeight,
                    color: _priorityColorIndicator,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
