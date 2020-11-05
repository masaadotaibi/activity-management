import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
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
  // 18 now we finished setting up Firestore for the authentication side, and we are now going to use it within our app
  // and we are going to use it directly when we create a user in Firebase authentication service, and when we log in

  // 21 we want to add the created task at the personal folder to the database
  Future<void> createTask({
    String userId,
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

    // TODO: add this list for the categories
    // ! List<TaskModel> tasksList = List<TaskModel>();
    // ! tasksList.add(newTask);

    // formatting the task dart object to be a JSON object
    Map<String, dynamic> task = newTask.toJson();

    try {
      await _firestore
          .collection('users')
          .document(userId)
          .collection('personalFolder')
          .document(newTaskId)
          .setData(task);
      print(
          'Here is the database, take addTask on the line. AddTask: I have added the task, thanks!');
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> createSubtask({
    String userId,
    String parentTaskId,
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
      DocumentReference taskReference = _firestore
          .collection('users')
          .document(userId)
          .collection('personalFolder')
          .document(parentTaskId);

      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(taskReference);
        if (!snapshot.exists) {
          throw Exception('data does not exist');
        }

        await transaction.update(
            taskReference,
            ({
              'subtasks': FieldValue.arrayUnion([
                subtaskJSON,
              ])
            }));
      });
    } catch (e) {
      print(e);
    }
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

  // now we need to display data in the screen
  Future<void> updateTaskStatus(
      String newState, String userId, String taskId) async {
    try {
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
}
