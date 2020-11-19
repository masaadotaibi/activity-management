import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_todo_app/models/subtask.dart';
import '../models/category.dart';
import 'package:the_todo_app/models/comment.dart';
import '../models/task.dart';
import '../models/user.dart';

/*
CHANGE THE:
  1- TASKS ADDITION TO BE ON A NEW SUBCOLLECTION BESIDE THE CATEGORIES SUBCOLLECTION
  2- WAY OF STREAMING TASKS TO BE ON THE SUBCOLLECTION ITSELF(ALL TASKS)
  3- CONTROLLER WAY OF HANDLING A TASK (DON'T INJECT CATEGORY ID TO IT)
  4- VIEW TO WHICH WE SHOW THE TASKS AND ITS CORRESPONDING CATEGORY
*/

class PersonalFolderCollection {
  // 15 this is the instance we need to handle Firestore operations
  final Firestore _firestore = Firestore.instance;

  // 16 now we create the user model in the database from Firebase Service, so we need all the info (UserModel we built)
  Future<bool> createNewUser(UserModel user) async {
    print('it entered createNewUser function');
    try {
      print(
          'the user id in createNewUser function is ${user.id} and name is ${user.name}');
      await _firestore.collection('users').document(user.id).setData(
        {
          'name': user.name,
          'email': user.email,
        },
      );
      print(
          'did pass the users collection creation in createNewUser function?');
      createCategory(user.id, 'Tasks List:');
      return true;
    } catch (e) {
      print('$e create New user exception');
      return false;
    }
  }

  // To retrieve the user model we need just their uid
  Future<UserModel> getUser(String uid) async {
    try {
      // We first bring the user data from the users collection with the user 'uid' injected, then save it as document query
      DocumentSnapshot _doc =
          await _firestore.collection('users').document(uid).get();

      // Feed that data to our UserModel and return it back to the user
      return UserModel.fromDocumentSnapshot(_doc);
    } catch (e) {
      print('$e get user exception');
      rethrow;
    }
  }

  Future<void> createCategory(String userId, String categoryName) async {
    final newCatDocument = _firestore
        .collection('users')
        .document(userId)
        .collection('categories')
        .document();

    final newCategory = Category(newCatDocument.documentID, categoryName);

    // Formatting category Dart object to be JSON object
    final category = newCategory.toJson();

    try {
      await newCatDocument.setData(category);
    } catch (e) {
      print('$e create category exception');
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

  // Now we finished setting up Firestore for the authentication side, and we are now going to use it within our app
  // and we are going to use it directly when we create a user in Firebase authentication service, and when we log in

  // Add the created task to the tasks collection at the database
  Future<void> createTask({
    String userId,
    String categoryId,
    String newTtaskTitle,
    DateTime dueDate,
    String state,
    String priority,
  }) async {
    List<TaskModel> subtasksList = List<TaskModel>();

    List<Comment> commentsList = List<Comment>();

    final newTaskDocument = _firestore
        .collection('users')
        .document(userId)
        .collection('tasks')
        .document();

    TaskModel newTask = TaskModel(
      categoryId: categoryId,
      taskId: newTaskDocument.documentID,
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
      await newTaskDocument.setData(jsonTask);
    } catch (e) {
      print('$e create task exception');
      rethrow;
    }
  }

  Future<void> deleteTask(String parentTaskId) async {
    // TODO: delete a task
  }

  Future<void> createSubtask({
    String userId,
    String parentTaskId,
    String subtaskTitle,
    DateTime dueDate,
    String state,
    String priority,
  }) async {
    final newSubtaskDocument = _firestore
        .collection('users')
        .document(userId)
        .collection('tasks')
        .document(parentTaskId)
        .collection('subtasks')
        .document();

    Subtask newSubtask = Subtask(
      parentTaskId: parentTaskId,
      subtaskId: newSubtaskDocument.documentID,
      subtaskTitle: subtaskTitle,
      dueDate: dueDate,
      subtaskState: state,
      subtaskPriority: priority,
    );

    final subtaskJSON = newSubtask.toJson();

    try {
      await newSubtaskDocument.setData(subtaskJSON);
    } catch (e) {
      print('$e create subtask exception');
    }
  }

  Future<void> delteSubtask() async {
    // TODO: delete a subtask
  }

  // The stream to provide to the tasks
  Stream<List<TaskModel>> personalTasksStream(String userId) {
    final tasksSnapshot = _firestore
        .collection('users')
        .document(userId)
        .collection('tasks')
        .snapshots();

    return tasksSnapshot.map(
      (QuerySnapshot query) {
        List<TaskModel> _tasksList = List<TaskModel>();
        query.documents.forEach(
          (DocumentSnapshot taskDocument) {
            _tasksList.add(TaskModel.fromJson(taskDocument.data));
          },
        );
        return _tasksList;
      },
    );
  }

  Stream<List<Category>> personalFolderCategoriesStream(String userId) {
    final categoriesSnapshot = _firestore
        .collection('users')
        .document(userId)
        .collection('categories')
        .snapshots();

    return categoriesSnapshot.map(
      (QuerySnapshot query) {
        List<Category> _categoriesList = List<Category>();
        query.documents.forEach(
          (DocumentSnapshot element) {
            _categoriesList.add(Category.fromJson(element.data));
          },
        );
        return _categoriesList;
      },
    );
  }

  Future<void> updateTaskStatus({
    String newState,
    String userId,
    String taskId,
    String categoryId,
  }) async {
    final taskDocument = _firestore
        .collection('users')
        .document(userId)
        .collection('tasks')
        .document(taskId);
    try {
      await taskDocument.updateData({'taskState': newState});
    } catch (e) {
      print('$e update task exception');
      rethrow;
    }
  }

  // TODO: add task priority update function
}
