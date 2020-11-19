import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_todo_app/controllers/auth_controller.dart';
import 'package:the_todo_app/controllers/tasks_controller.dart';
import 'package:the_todo_app/models/category.dart';
import 'package:the_todo_app/services/personal_folder_collection.dart';

import '../models/task.dart';
import './task_item.dart';

class TasksList extends StatefulWidget {
  final List<Category> categoriesList;

  TasksList({@required this.categoriesList});

  @override
  _TasksListState createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  List<TaskModel> userTasks = [];
  List<TaskModel> completedTasks = [];

  void _tickTask(String taskId, String currentState) {
    PersonalFolderCollection().updateTaskStatus(
      newState: currentState == 'completed'
          ? 'not-started'
          : 'completed'.toLowerCase(),
      userId: Get.find<AuthController>().user.uid,
      taskId: taskId,
    );
    setState(() {
      currentState == 'completed'
          ? completedTasks
              .removeWhere((TaskModel task) => task.taskId == taskId)
          : completedTasks.add(
              userTasks.firstWhere((TaskModel task) => task.taskId == taskId));
    });
  }

  void _categoryOptions(String categoryId) {
    // TODO: Add the dropdown list of the options of the category
  }

  @override
  Widget build(BuildContext context) {
    return widget.categoriesList.isEmpty
        // TODO: make the thought bubble photo appear inside the default category list instead of being put of it at all
        ? LayoutBuilder(
            builder: (context, constraints) {
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
            },
          )
        : GetX(
            init: Get.put<TasksController>(TasksController()),
            builder: (TasksController tasksController) {
              if (tasksController != null &&
                  tasksController.tasks != null &&
                  tasksController.tasks.isNotEmpty) {
                userTasks = tasksController.tasks;
              }
              return ListView.builder(
                itemBuilder: (context, index) {
                  return Container(
                    width: double.infinity,
                    // height: MediaQuery.of(context).size.height -
                    //     Scaffold.of(context).appBarMaxHeight,
                    padding: EdgeInsets.only(right: 11, left: 11, top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // TODO: show the details(tasks, thier subtasks, etc) and the activity log of the category
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 10,
                                child: Text(
                                  widget.categoriesList[index].categoryName ??
                                      '',
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
                        ),
                        Divider(thickness: 2),
                        if (userTasks.isNotEmpty)
                          Column(
                            children: userTasks
                                .where((task) =>
                                    task.categoryId ==
                                    widget.categoriesList[index].categoryId)
                                .map(
                                  (taskItem) => TaskItem(
                                    task: taskItem,
                                    tickTask: _tickTask,
                                  ),
                                )
                                .toList(),
                          )
                      ],
                    ),
                  );
                },
                itemCount: widget.categoriesList.length,
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.12),
                shrinkWrap: true,
              );
            },
          );
  }
}
