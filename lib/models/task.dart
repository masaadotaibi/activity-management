import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:the_todo_app/models/comment.dart';
import 'package:the_todo_app/models/subtask.dart';

// 23 to show the tasks we have to bring their data from Firestore and then set that as a model and
// bring it back to the personal folder
class TaskModel {
  String categoryId;
  String taskTitle;
  String taskId;
  DateTime dueDate;
  String state;
  String priority;
  List<TaskModel> subtasks;
  List<Comment> comments;

  TaskModel({
    @required this.categoryId,
    @required this.taskId,
    @required this.taskTitle,
    this.dueDate,
    this.state,
    this.priority,
    this.subtasks,
    this.comments,
  });

  // 24 now we set the model the model from Firestore database data
  TaskModel.fromJson(Map<String, dynamic> json) {
    taskId = json['taskId'];
    categoryId = json['category'];
    taskTitle = json['taskTitle'];
    dueDate = json['dueDate'] == null
        ? null
        : DateTime.fromMicrosecondsSinceEpoch(
            json['dueDate'].microsecondsSinceEpoch);
    state = json['taskState'];
    priority = json['taskPriority'];
    if (json['subtasks'] != null) {
      subtasks = List<TaskModel>();
      json['subtasks'].forEach((subtask) {
        subtasks.add(TaskModel.fromJson(Map<String, dynamic>.from(subtask)));
      });
    }
    if (json['comments'] != null) {
      comments = List<Comment>();
      json['comments'].forEach((comment) {
        comments.add(new Comment.fromJson(Map<String, dynamic>.from(comment)));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['taskId'] = this.taskId;
    data['category'] = this.categoryId;
    data['taskTitle'] = this.taskTitle;
    data['dueDate'] = this.dueDate;
    data['taskState'] = this.state;
    data['taskPriority'] = this.priority;
    if (this.subtasks != null) {
      data['subtasks'] = subtasks.map((e) => e.toJson()).toList();
    }
    if (this.comments != null) {
      data['comments'] = comments.map((e) => e.toJson()).toList();
    }

    return data;
  }

  // 25 now we are going to stream the list of all the task models available in the database, so we have to get the
  // data from Firestore and model it here then use the controller to feed it back to the personal folder
}
