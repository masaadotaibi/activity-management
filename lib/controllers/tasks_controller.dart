import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:json_annotation/json_annotation.dart';
import '../controllers/auth_controller.dart';
import '../models/task.dart';
import '../services/personal_folder_collection.dart';

class TasksController extends GetxController {
  // 26 we make an observable task models
  Rx<List<TaskModel>> _tasksList = Rx<List<TaskModel>>();

  // 27 we need to stream the list of tasks to the personal folder
  List<TaskModel> get tasks => _tasksList.value;

  // 28 we need to bind the _tasksList to the stream coming from Firestore of the database
  @override
  void onInit() {
    String uid = Get.find<AuthController>().user.uid;

    _tasksList.bindStream(PersonalFolderCollection().personalTasksStream(uid));
  }
}
