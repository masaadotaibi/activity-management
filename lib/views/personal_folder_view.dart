import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:the_todo_app/controllers/category_controller.dart';
import 'package:the_todo_app/controllers/tasks_controller.dart';
import 'package:the_todo_app/models/category.dart';
import 'package:the_todo_app/models/task.dart';
import 'package:the_todo_app/services/personal_folder_collection.dart';
import 'package:the_todo_app/widget/task_entries.dart';
import 'package:the_todo_app/widget/tasks_list.dart';
import '../controllers/auth_controller.dart';
import '../controllers/user_controller.dart';
import '../services/personal_folder_collection.dart';

//

class PersonalFolder extends StatefulWidget {
  @override
  _PersonalFolderState createState() => _PersonalFolderState();
}

class _PersonalFolderState extends State<PersonalFolder> {
  List<Category> categories = [];
  TextEditingController _categoryController = TextEditingController();

  Future categoryFormDialog() {
    return Get.defaultDialog(
      title: "Category Name",
      content: Container(
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(height: 5.0),
            Container(
              padding: EdgeInsets.only(top: 0, left: 7, right: 6, bottom: 0),
              child: TextFormField(
                controller: _categoryController,
                maxLength: 50,
                decoration: InputDecoration(
                  hintText: 'e.g. Home tasks',
                  labelText: 'Category Name',
                ),
                autofocus: true,
              ),
            ),
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
                  onPressed: () {
                    if (_categoryController.text.isNotEmpty) {
                      PersonalFolderCollection().createCategory(
                        Get.find<AuthController>().user.uid,
                        _categoryController.text,
                      );
                    }
                    Get.back();
                    _categoryController.clear();
                  },
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
        IconButton(
          icon: Icon(
            Icons.playlist_add_outlined,
            size: 29,
          ),
          onPressed: () {
            categoryFormDialog();
          },
        ),
      ],
    );

    return Scaffold(
      appBar: appBar,
      // ? might we need SingleChildScrollView surrnounding this above Column?
      body: Column(
        children: <Widget>[
          GetX<CategoryController>(
            init: Get.put<CategoryController>(CategoryController()),
            builder: (CategoryController categoryController) {
              if (categoryController != null &&
                  categoryController.categories != null &&
                  categoryController.categories.isNotEmpty) {
                categories = categoryController.categories;
              }
              Get.put<TasksController>(TasksController());
              Get.find<TasksController>();
              return Expanded(
                // Without Expanded widget surronding ListView, Flutter would complain (ListView inside TasksList)
                child: Container(
                  height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top),
                  child: TasksList(
                    categoriesList: categories,
                  ),
                ),
              );
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
