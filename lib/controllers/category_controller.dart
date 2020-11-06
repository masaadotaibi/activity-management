import 'package:get/get.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:the_todo_app/models/category.dart';
import '../controllers/auth_controller.dart';
import '../models/task.dart';
import '../services/personal_folder_collection.dart';

class CategoryController extends GetxController {
  // 26 we make an observable task models
  Rx<List<Category>> categoryList = Rx<List<Category>>();

  // 27 we need to stream the list of tasks to the personal folder
  List<Category> get tasks => categoryList.value;

  // 28 we need to bind the _tasksList to the stream coming from Firestore of the database
  @override
  void onInit() {
    print('tasks_controller entered, and we bind the stream to the whole app');
    // 28.1 we need to get the current user uid
    String uid = Get.find<AuthController>().user.uid;
    // 28.2 and then we bind the tasks models of the user of the above uidby assigning its uid to its database personal tasks stream
    categoryList.bindStream(
      PersonalFolderCollection().personalFolderCategoriesStream(uid),
    );
    // stream coming from firebase, thus we are going to separate that from
    // this widget to Database() (separating firebase interfaces from the actual content)
  }

  // 29 it is a better practice to separate the Firestore works from other classes, and make only within a single class
  // for easier management, that is "Database()"
}
