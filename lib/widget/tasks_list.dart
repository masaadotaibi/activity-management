import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/task.dart';
import './task_item.dart';

class TasksList extends StatelessWidget {
  final List<TaskModel> tasks;
  final Function tickTask;

  TasksList({@required this.tasks, @required this.tickTask});
  @override
  Widget build(BuildContext context) {
    return tasks.isEmpty
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
                  child: Text('Press \'\+\' Button! To Save it for Later!',
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
                    EdgeInsets.only(right: 11, left: 11, top: 20, bottom: 3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 10,
                          child: Text(
                            'Daily Tasks Daily Tasks Daily Tasks Daily Tasks Daily Tasks Daily Tasks',
                            style: TextStyle(
                              fontSize: 26.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: IconButton(
                            icon: Icon(
                              Icons.more_vert,
                              color: Colors.grey.shade700,
                            ),
                            onPressed: () {
                              /* // TODO: add a pop view of actions. including the following actions:-
                                1- delete category(ask the user if he/she also wants to delete its tasks or move it to another category). 
                                2- rename category. 
                                3- Add task to this category. 
                                4- Activity Log of the category.
                              */
                            },
                          ),
                        ),
                      ],
                    ),
                    Divider(thickness: 2),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return TaskItem(task: tasks[index], tickTask: tickTask);
                  },
                  itemCount: tasks.length,
                ),
              ),
            ],
          );
  }
}
