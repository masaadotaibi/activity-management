import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import '../models/category.dart';
import 'package:the_todo_app/models/comment.dart';
import 'package:uuid/uuid.dart';
import '../models/task.dart';
import '../models/user.dart';

class PersonalFolderCollection {
  // 15 this is the instance we need to handle Firestore operations
  final Firestore _firestore = Firestore.instance;

  // 16 now we create the user model in the database from Firebase Service, so we need all the info (UserModel we built)
  Future<bool> createNewUser(UserModel user) async {
    try {
      await _firestore.collection('users').document(user.id).setData({
        'name': user.name,
        'email': user.email,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // 17 to retrieve the user model we need just their uid
  Future<UserModel> getUser(String uid) async {
    try {
      // 17.1 we first bring the user data from the users collection with the user 'uid' injected, then save it as document query
      DocumentSnapshot _doc =
          await _firestore.collection('users').document(uid).get();

      // 17.2 we then feed that data to our UserModel and return it back to the user
      return UserModel.fromDocumentSnapshot(_doc);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> createCategory(String userId, String categoryName) async {
    // TODO: create the category
    String categoryId = Uuid().v1();

    List<TaskModel> _tasks = List<TaskModel>();

    final categoryModel = Category(categoryId, categoryName, _tasks);

    try {
      // !
      final category = categoryModel.toJson();
      // !
      await _firestore
          .collection('users')
          .document(userId)
          .collection('personalFolder')
          .document(categoryId)
          .setData(category);
    } catch (e) {
      print(e);
    }
  }

  Future<void> addTaskToCategory(String categoryId, String taskId) async {
    // TODO: add a task to to category
  }
  Future<void> removeTaskFromCategory(String categoryId, String taskId) async {
    // TODO: remove a task from category
  }

  Future<void> changeCategoryName(String categoryId, String newName) async {
    // TODO: change the category of id 'categoryId' to the name 'newName'
  }

  // 18 now we finished setting up Firestore for the authentication side, and we are now going to use it within our app
  // and we are going to use it directly when we create a user in Firebase authentication service, and when we log in

  // 21 we want to add the created task at the personal folder to the database
  Future<void> createTask({
    String userId,
    String categoryId,
    String newTtaskTitle,
    DateTime dueDate,
    String state,
    String priority,
  }) async {
    // TODO: add due date, priority, state, and category fields
    String newTaskId = Uuid().v1();

    List<TaskModel> subtasksList = List<TaskModel>();

    List<Comment> commentsList = List<Comment>();

    TaskModel newTask = TaskModel(
      taskId: newTaskId,
      taskTitle: newTtaskTitle,
      dueDate: dueDate,
      state: state,
      priority: priority,
      subtasks: subtasksList,
      comments: commentsList,
    );

    // formatting the task dart object to be a JSON object
    final jsonTask = newTask.toJson();

    try {
      await _firestore
          .collection('users')
          .document(userId)
          .collection('personalFolder')
          //     .document(categoryId) // ! this should be instead of the below .document(newTaskId).setData(jsonTask);
          //     .updateData(
          //   {
          //     'tasks': FieldValue.arrayUnion([jsonTask])
          //   },
          // )
          // * .collection('tasks') // we could use an id of task if we wish to add a collection of 'tasks' to give the id for document
          .document(newTaskId)
          .setData(jsonTask);
      print(
          'Here is the database, take addTask on the line. AddTask: I have added the task, thanks!');
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> deleteTask(String categoryId, String taskId) async {
    // TODO: delete a task
  }

  Future<void> createSubtask({
    String userId,
    String parentTaskId,
    String categoryId,
    String subtaskTitle,
    DateTime dueDate,
    String state,
    String priority,
  }) async {
    String subtaskId = Uuid().v1();

    TaskModel newSubtask = TaskModel(
      taskId: subtaskId,
      taskTitle: subtaskTitle,
      dueDate: dueDate,
      state: state,
      priority: priority,
    );

    Map<String, dynamic> subtaskJSON = newSubtask.toJson();

    try {
      final parentTaskReference = await _firestore
          .collection('users')
          .document(userId)
          .collection('personalFolder')
          .document(categoryId)
          .get();
      final tasks = parentTaskReference.data['tasks'];
      // TODO: loop through the tasks and add this new subtask to it
    } catch (e) {
      print(e);
    }
  }

  Future<void> delteSubtask() async {
    // TODO: delete a subtask
  }

  // this is the stream we are going to provide to the perosnal folder
  Stream<List<TaskModel>> personalTasksStream(String userId) {
    print(
        'personalTaskStream method of PersonalFolderCollection has been entered');
    // now we bring tasks data of user of the 'userId' parameter provided
    return _firestore
        .collection('users')
        .document(userId)
        .collection('personalFolder')
        // .orderBy('dueDate', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      // In the above brought anonymous function query snapshot, we have all the documents we need, we only need to map it
      // to models, by making a tasks list, and adding each document to the list of models, then return it
      List<TaskModel> _tasksList = List<TaskModel>();
      print('${query.documents.length} would you work?');
      query.documents.forEach((element) {
        // we recieve a document snapshot and we should use the snapshots converter to actual tasks model (.fromDocumentSnapshot),
        // this way we map each database document snapshot to actual task by fetching the data inside each document snapshot into
        // actual TaskModel
        print(
            '${element.data['subtasks'].runtimeType} the element data in the stream of QuerySnapshot');
        _tasksList.add(TaskModel.fromJson(element.data));
      });
      print('${_tasksList.runtimeType} out of the QuerySnapshot criteria');
      return _tasksList;
    });
  }

  Stream<List<Category>> personalFolderCategoriesStream(String userId) {
    return _firestore
        .collection('users')
        .document(userId)
        .collection('personalFolder')
        .snapshots()
        .map(
      (QuerySnapshot query) {
        List<Category> _categoriesList = List<Category>();
        // TODO: bring the 'tasks' field (which is the array)
        query.documents.forEach(
          (element) {
            _categoriesList.add(Category.fromJson(element.data));
          },
        );
        return _categoriesList;
      },
    );
  }

  // now we need to display data in the screen
  Future<void> updateTaskStatus({
    String newState,
    String userId,
    String taskId,
    String categoryId,
  }) async {
    //
    // final categorySnapshot = await _firestore
    //     .collection('personalFolder')
    //     .document(categoryId)
    //     .get();
    // TODO: use categorySnaphot['tasks'] to bring tasks, then loop through it to find your task to update its state
    try {
      // TODO: update the data using the new category feature
      _firestore
          .collection('users')
          .document(userId)
          .collection('personalFolder')
          .document(taskId)
          .updateData({'taskState': newState});
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // TODO: add task priority update function
}
