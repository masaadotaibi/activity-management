import 'package:flutter/material.dart';

import 'package:circular_check_box/circular_check_box.dart';
import 'package:intl/intl.dart';

import '../models/task.dart';

class TaskItem extends StatelessWidget {
  final TaskModel task;
  final Function tickTask;

  TaskItem({this.task, this.tickTask});

  @override
  Widget build(BuildContext context) {
    bool _checkBoxIconState = false;
    final _stateColorIndicator = task.state == 'in-progress'
        ? Colors.green
        : task.state == 'not-started'
            ? Colors.orange[700]
            : task.state == 'overdue'
                ? Colors.red
                : Colors.grey[350];

    final _priorityColorIndicator = task.state == 'completed'
        ? Colors.grey[350]
        : task.priority == 'high'
            ? Colors.red[800]
            : task.priority == 'medium'
                ? Colors.yellow[800]
                : Colors.blue;

    final _priorityFontWeight =
        task.priority == 'high' ? FontWeight.bold : FontWeight.normal;

    print('taskItem entered');
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 3),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 25,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(width: 4, color: _stateColorIndicator),
                  ),
                  child: InkWell(
                    onTap: () {
                      tickTask(task.taskId);
                    },
                    focusColor: _stateColorIndicator,
                    highlightColor: _stateColorIndicator,
                    hoverColor: _stateColorIndicator,
                    splashColor: _stateColorIndicator,
                    child: _checkBoxIconState
                        ? Icon(
                            Icons.check,
                            size: 24.0,
                            color: _stateColorIndicator,
                          )
                        : Icon(
                            Icons.check,
                            size: 24.0,
                            color: _stateColorIndicator,
                          ),
                  ),
                ),
              ),
              // CircularCheckBox(
              //   value: false,
              //   onChanged: (_) {
              //     print(task.taskId == null
              //         ? 'nullity aware check'
              //         : task.taskId);
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
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  SizedBox(height: 5),
                  task.dueDate == null
                      ? Text("")
                      : Text(
                          "  ${DateFormat.yMMMd().format(task.dueDate)}",
                          style: TextStyle(
                            color: task.state == 'completed'
                                ? Colors.grey[350]
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
              flex: 48,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.42,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                        icon: Icon(
                          Icons.today,
                          size: 32,
                          color: task.state == 'overdue'
                              ? Colors.red
                              : Colors.grey[600],
                        ),
                        onPressed: () {
                          // TODO: the user should click this to quickly change the date of the task
                        }),
                    SizedBox(width: 5),
                    Text(
                      task.priority == 'low'
                          ? 'Low !'
                          : task.priority == 'high'
                              ? 'High !!!'
                              : 'Medium !!',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: _priorityFontWeight,
                        color: _priorityColorIndicator,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
      // TODO: if this commented widget is not needed anymore, delete it for cleaning the code
      // ListTile(
      //   leading: CircularCheckBox(
      //     value: false,
      //     onChanged: (_) {
      //       print(task.taskId == null ? 'nullity aware check' : task.taskId);
      //       tickTask(task.taskId);
      //     },
      //     inactiveColor: _stateColorIndicator,
      //     checkColor: _stateColorIndicator,
      //     focusColor: _stateColorIndicator,
      //     activeColor: _stateColorIndicator,
      //     hoverColor: _stateColorIndicator,
      //   ),
      //   title: GestureDetector(
      //     onTap: () {},
      //     child: Text(
      //       task.taskTitle,
      //       style: Theme.of(context).textTheme.headline6,
      //     ),
      //   ),
      //   subtitle: task.dueDate == null
      //       ? Text("")
      //       : Text(
      //           "${DateFormat.yMMMd().format(task.dueDate)}",
      //           style: TextStyle(
      //             color:
      //                 task.state == 'overdue' ? Colors.red : Colors.grey[600],
      //             decoration: task.state == 'completed'
      //                 ? TextDecoration.lineThrough
      //                 : TextDecoration.none,
      //           ),
      //         ),
      //   trailing: SizedBox(
      //     width: MediaQuery.of(context).size.width * 0.3,
      //     child: Row(
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       children: [
      //         IconButton(icon: Icon(Icons.today), onPressed: () {}),
      //         SizedBox(width: 5),
      //         Text(task.priority == 'low'
      //             ? 'Low'
      //             : task.priority == 'high'
      //                 ? 'High'
      //                 : 'Medium'),
      //       ],
      //     ),
      //   ),
      // )
      ,
    );
  }
}
