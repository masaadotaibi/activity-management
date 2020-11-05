import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/task.dart';
import './task_item.dart';

class TasksList extends StatefulWidget {
  final List<TaskModel> tasks;
  final Function tickTask;

  TasksList({@required this.tasks, @required this.tickTask});

  @override
  _TasksListState createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  @override
  void initState() {
    print('the tasks_list has been created');
  }

  @override
  Widget build(BuildContext context) {
    return widget.tasks.isEmpty
        ? LayoutBuilder(builder: (context, constraints) {
            print('the layout builder has been entered');
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: constraints.maxHeight * 0.4,
                  child: Image.asset(
                    'assets/images/thought_bubble.png',
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    'Do you have an idea?',
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                ),
                Center(
                  child: Text('Press the plus \'\+\' button! And do it!',
                      style: Theme.of(context).textTheme.headline6),
                )
              ],
            );
          })
        : Column(
            children: [
              Container(
                width: double.infinity,
                padding:
                    EdgeInsets.only(right: 30, left: 20, top: 20, bottom: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Tasks',
                      style: TextStyle(
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(thickness: 2),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    print('the listview.builder has been entered');
                    return TaskItem(
                        task: widget.tasks[index], tickTask: widget.tickTask);
                  },
                  itemCount: widget.tasks.length,
                ),
              ),
            ],
          );
  }
}
