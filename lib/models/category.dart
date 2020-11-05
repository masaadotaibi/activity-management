//

import 'package:the_todo_app/models/task.dart';

class Category {
  String _categoryId;
  String _categoryName;
  List<TaskModel> _tasks;

  Category(this._categoryId, this._categoryName, this._tasks);

  Category.fromJson(Map<String, dynamic> json) {
    _categoryId = json['categoryId'];
    _categoryName = json['categoryName'];
    if (json['tasks'] != null) {
      _tasks = List<TaskModel>();
      json['tasks'].forEach((task) {
        _tasks.add(TaskModel.fromJson(Map<String, dynamic>.from(task)));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['categoryId'] = this._categoryId;
    data['categoryName'] = this._categoryName;
    if (this._tasks != null) {
      data['tasks'] = _tasks.map((e) => e.toJson()).toList();
    }
    return data;
  }
}
