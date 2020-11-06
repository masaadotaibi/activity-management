import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:the_todo_app/models/category.dart';
import 'package:the_todo_app/models/task.dart';
import 'package:the_todo_app/services/personal_folder_collection.dart';
import 'package:the_todo_app/widget/task_entries.dart';
import 'package:the_todo_app/widget/tasks_list.dart';
import '../controllers/auth_controller.dart';
import '../controllers/tasks_controller.dart';
import '../controllers/user_controller.dart';
import '../services/personal_folder_collection.dart';

//

class PersonalFolder extends StatefulWidget {
  @override
  _PersonalFolderState createState() => _PersonalFolderState();
}

class _PersonalFolderState extends State<PersonalFolder> {
  List<TaskModel> userTasks = [];
  List<Category> categories = [];
  List<TaskModel> completedTasks = [];

  void _tickTask(String taskId) {
    PersonalFolderCollection().updateTaskStatus(
      newState: 'completed'.toLowerCase(),
      userId: Get.find<AuthController>().user.uid,
      taskId: taskId,
      // TODO: add categoryId
    );
    // addingcollection of completed tasks in DB will cost more (changing the state, then add the task to another collection)
    setState(() {
      completedTasks
          .add(userTasks.firstWhere((TaskModel task) => task.taskId == taskId));
      userTasks.removeWhere((TaskModel task) => task.taskId == taskId);
    });
  }

  Future categoryDialog() {
    return Get.defaultDialog(
      content: Container(
        height: 170,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(height: 5.0),
            TextFormField(),
            TextFormField(),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RaisedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  color: Theme.of(context).errorColor,
                ),
                RaisedButton(
                  onPressed: () {},
                  child: Text(
                    'Add',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  color: Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
      title: "Add Category name",
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // to initilize one object instead of exploding the heap with many objects of the same type (when many contexts change)
    final mediaQuery = MediaQuery.of(context);
    final appBar = AppBar(
      title: GetX<UserController>(
        initState: (_) async {
          Get.find<UserController>().user = await PersonalFolderCollection()
              .getUser(Get.find<AuthController>().user.uid);
        },
        builder: (_) {
          if (_.user.name != null) {
            return Text("Welcome " + _.user.name);
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () {
            Get.find<AuthController>().signout();
          },
        ),
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            if (Get.isDarkMode) {
              Get.changeTheme(ThemeData.light());
            } else {
              Get.changeTheme(ThemeData.dark());
            }
          },
        ),
        PopupMenuButton(onSelected: (value) {
          if (value == OptionsButton.Category) {
            categoryDialog();
          }
        }, itemBuilder: (_) {
          return [
            // TODO: make the category addition be a sole button in the personal folder screen(without being in a pop up view) and remove "Select tasks" button for future considerations
            PopupMenuItem(
              child: Row(
                children: [
                  Text('Categories'),
                  Icon(Icons.category),
                ],
              ),
              value: OptionsButton.Category,
            ),
            PopupMenuItem(
              child: Row(
                children: [
                  Text('Select tasks'),
                  Icon(Icons.category),
                ],
              ),
              value: OptionsButton.SelectTasks,
            ),
            PopupMenuItem(
              child: Row(
                children: [
                  Text('Option 3'),
                  Icon(Icons.category),
                ],
              ),
            ),
          ];
        }),
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: Column(
        // ! you might need SingleChildScrollView surrnounding this above Column
        children: <Widget>[
          // 32 now here we view our tasks we added to the personal folder
          GetX<TasksController>(
            // 32.1 we initialize our data which we are going to read from
            init: Get.put<TasksController>(TasksController()),
            builder: (TasksController taskController) {
              if (taskController != null && taskController.tasks != null) {
                // ! would it be good to check even if the tasks list is empty (not null, but has 0 items)?
                // 33.2 we assign the whole tasks to the user tasks
                print(
                    '${taskController.tasks.runtimeType} in the Personal folder view');
                userTasks = taskController.tasks
                    .where(
                      (task) =>
                          task.state.toLowerCase() != 'completed'.toLowerCase(),
                    )
                    .toList(); // ! this should change later to the state rather than boolean
                print(userTasks.length);
                return Expanded(
                  // 32.3 without Expanded widget surronding ListView, Flutter would complain (ListView inside Column)
                  child: Container(
                    height: (mediaQuery.size.height -
                        appBar.preferredSize.height -
                        mediaQuery.padding.top),
                    child: TasksList(tasks: userTasks, tickTask: _tickTask),
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: 'Add a Task',
        onPressed: () {
          // 22 we create the task here by openning the bottomsheet
          showModalBottomSheet(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
            ),
            context: context,
            builder: (ctx) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  // 22.1 here we give the enteries by this object (continue steps from there - 22.2, 22.3, ...)
                  child: TaskEntries(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

enum OptionsButton {
  Category,
  SelectTasks,
}
