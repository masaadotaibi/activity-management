import 'package:flutter/foundation.dart';

class Subtask {
  String parentTaskId;
  String subtaskId;
  String subtaskTitle;
  DateTime dueDate;
  String subtaskState;
  String subtaskPriority;

  Subtask({
    @required this.parentTaskId,
    @required this.subtaskId,
    @required this.subtaskTitle,
    this.dueDate,
    this.subtaskState,
    this.subtaskPriority,
  });

  Subtask.fromJson(Map<String, dynamic> json) {
    parentTaskId = json['parentTaskId'];
    subtaskId = json['subtaskId'];
    subtaskTitle = json['subtaskTitle'];
    dueDate = json['dueDate'] == null
        ? null
        : DateTime.fromMicrosecondsSinceEpoch(
            json['dueDate'].microsecondsSinceEpoch);
    subtaskState = json['subtaskState'];
    subtaskPriority = json['subtaskPriority'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['parentTaskId'] = this.parentTaskId;
    data['subtaskId'] = this.subtaskId;
    data['subtaskTitle'] = this.subtaskTitle;
    data['dueDate'] = this.dueDate;
    data['subtaskState'] = this.subtaskState;
    data['subtaskPriority'] = this.subtaskPriority;

    return data;
  }
}
