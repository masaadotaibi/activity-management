import 'package:get/get.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:the_todo_app/models/category.dart';
import '../controllers/auth_controller.dart';
import '../models/task.dart';
import '../services/personal_folder_collection.dart';

class CategoryController extends GetxController {
  // Make an observable task models
  Rx<List<Category>> _categoryList = Rx<List<Category>>();

  List<Category> get categories => _categoryList.value;

  @override
  void onInit() {
    // 28.1 we need to get the current user uid
    String uid = Get.find<AuthController>().user.uid;
    // Binds the tasks model of the user of the above uid by assigning its uid to its database personal tasks stream
    _categoryList.bindStream(
      PersonalFolderCollection().personalFolderCategoriesStream(uid),
    );
  }
}
