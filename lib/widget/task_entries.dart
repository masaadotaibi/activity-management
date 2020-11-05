import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:the_todo_app/controllers/auth_controller.dart';
import 'package:the_todo_app/models/task.dart';
import 'package:the_todo_app/services/personal_folder_collection.dart';

class TaskEntries extends StatefulWidget {
  @override
  _TaskEntriesState createState() => _TaskEntriesState();
}

class _TaskEntriesState extends State<TaskEntries> {
  final _taskTitleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tasktTitleFocusNode = FocusNode();
  // TODO: comment adding feature

  DateTime _dateTime;
  final _states = <DropdownMenuItem>[
    DropdownMenuItem(
      child: Row(
        children: [
          Text(
            'In Progress',
            style: TextStyle(
              color: Colors.green,
            ),
          ),
          Icon(
            Icons.timelapse,
            color: Colors.green,
          )
        ],
      ),
      value: 'in-progress',
    ),
    DropdownMenuItem(
      child: Row(
        children: [
          Text(
            'Not Started',
            style: TextStyle(
              color: Colors.orange[900],
            ),
          ),
          Icon(
            Icons.browser_not_supported,
            color: Colors.orange[900],
          ),
        ],
      ),
      value: 'not-started',
    )
  ];

  final _priorities = <DropdownMenuItem>[
    DropdownMenuItem(
      child: Text(
        'Low !',
        style: TextStyle(
          color: Colors.blue,
        ),
      ),
      value: 'low',
    ),
    DropdownMenuItem(
      child: Text(
        'Med !!',
        style: TextStyle(
          color: Colors.yellow[800],
        ),
      ),
      value: 'medium',
    ),
    DropdownMenuItem(
      child: Text(
        'High !!!',
        style: TextStyle(
          color: Colors.red[800],
        ),
      ),
      value: 'high',
    ),
  ];

  // state is by default not-started, and user can switch it while creating to in-progress, other states are to time and completion factors
  var _selectedStateValue = 'not-started';

  // priority is by default 'low', and user can switch it to medium and high
  var _selectedPriorityValue = 'low';

  @override
  void initState() {
    super.initState();

    // setting a listner for the task title entry focus node so once it hasn't the focus, it brings it back to it
    _tasktTitleFocusNode.addListener(() {
      if (!_tasktTitleFocusNode.hasFocus) {
        // if the task title loses the focus node, it immediately requested it back
        FocusScope.of(context).requestFocus(_tasktTitleFocusNode);
      }
    });
  }

  // 22 this is the continuation of 22 step
  void _addTaskFromEntries() {
    final givenTaskTitle = _taskTitleController.text;
    // 22.2 we first check before adding the task
    if (givenTaskTitle == null) {
      return;
    }

    if (_dateTime == null) {
      // ! for now, if there isn't a date, it won't be set (undated - the user can either decide the date later or just do it anytime)
      // _dateTime = DateTime.now();
    }

    // adding the task to the database
    PersonalFolderCollection().createTask(
      userId: Get.find<AuthController>().user.uid,
      newTtaskTitle: _taskTitleController.text,
      dueDate: _dateTime,
      state: _selectedStateValue,
      priority: _selectedPriorityValue,
    );
    Get.back();
  }

  // This function shows the date picker UI
  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
    ).then((dateChosen) {
      // If no date chosen, then we close the date picker
      if (dateChosen == null) {
        return;
      }
      //  we then mark the widget as dirty and set the state if a date chosen
      setState(() {
        _dateTime = dateChosen;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final _stateColorIndicator = _selectedStateValue == 'in-progress'
        ? Colors.green
        : _selectedStateValue == 'not-started'
            ? Colors.orange[900]
            : _selectedStateValue == 'overdue'
                ? Colors.red
                : Colors.grey[350];

    final _priorityColorIndicator = _selectedPriorityValue == 'high'
        ? Colors.red[800]
        : _selectedPriorityValue == 'medium'
            ? Colors.yellow[800]
            : Colors.blue;

    final _priorityFontWeight =
        _selectedPriorityValue == 'high' ? FontWeight.w800 : FontWeight.w600;

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Enter task title',
              border: InputBorder.none,
            ),
            controller: _taskTitleController,
            onSubmitted: (_) => _addTaskFromEntries(),
            cursorColor: Theme.of(context).primaryColor,
            focusNode: _tasktTitleFocusNode,
            autofocus: true,
          ),
          // this is the container which encapsulates the row of date, state, and priority buttons
          Container(
            // the height here indicates the fit height of the components of the row
            height: mediaQuery.size.height * 0.053,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: _showDatePicker,
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 7,
                      bottom: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: _dateTime == null
                              ? Colors.grey[500]
                              : Theme.of(context).primaryColor,
                          width: 2),
                    ),
                    child: _dateTime == null
                        ? Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'No Date',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                SizedBox(width: 10),
                                Icon(
                                  Icons.calendar_today,
                                  color: Colors.grey[600],
                                ),
                              ],
                            ),
                          )
                        : Text(
                            "${DateFormat.MMMd().format(_dateTime)}",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                // TODO: add the feature of changing the folder (whether specific project or just this folder where it has been added - either of specific project or personal folder)
                // ! Container(
                // !   padding: EdgeInsets.all(10),
                // !   decoration: BoxDecoration(
                // !     borderRadius: BorderRadius.circular(10),
                // !     border:
                // !         Border.all(color: Theme.of(context).primaryColorLight),
                // !   ),
                // !   child: Text("Personal tasks"),
                // ! ),
                // this is the box of choosing the state of the task in the personal folder
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _stateColorIndicator, width: 2),
                  ),
                  child: DropdownButton(
                    isDense: false,
                    items: _states,
                    // icon: null,
                    // * icon: _selectedStateValue == 'in-progress'
                    // *     ? Icon(
                    // *         Icons.timelapse,
                    // *         color: Colors.green,
                    // *       )
                    // *     : Icon(
                    // *         Icons.browser_not_supported,
                    // *         color: _stateColorIndicator,
                    // *       ),
                    // the default line below the dropdown list entry can be omitted giving it an empty value (null won't work)
                    underline: Text(''),
                    onChanged: (value) {
                      setState(
                        () {
                          _selectedStateValue = value;
                        },
                      );
                    },
                    value: _selectedStateValue,
                    style: TextStyle(
                      color: _stateColorIndicator,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    hint: Text(
                      _selectedStateValue == 'in-progress'
                          ? 'In Progress'
                          : 'Not Started',
                      style: TextStyle(color: Colors.red
                          // color: _selectedStateValue == 'in-progress'
                          //     ? Colors.greenAccent[400]
                          //     : Colors.grey[700],
                          // fontWeight: _selectedStateValue == 'in-progress'
                          //     ? FontWeight.w900
                          //     : FontWeight.w900,
                          ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                // this is the box of choosing the priority of the task in the personal folder
                // TODO: fix the problem of the dropdown menu item 'High' being hidden by keyboard when it is already set as 'Low'
                Container(
                  padding: const EdgeInsets.only(left: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(color: _priorityColorIndicator, width: 2),
                  ),
                  child: DropdownButton(
                    isDense: false,
                    items: _priorities,
                    onChanged: (value) {
                      setState(() {
                        _selectedPriorityValue = value;
                      });
                    },
                    underline: Text(''),
                    value: _selectedPriorityValue,
                    style: TextStyle(
                      color: _priorityColorIndicator,
                      fontWeight: _priorityFontWeight,
                      fontSize: 17,
                    ),
                    hint: Text(
                      _selectedPriorityValue == 'low'
                          ? 'Low !'
                          : _selectedPriorityValue == 'medium'
                              ? 'Med !!'
                              : 'High !!!',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: mediaQuery.size.width * 0.22,
            child: RaisedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Add'),
                  Icon(Icons.arrow_right),
                ],
              ),
              color: Theme.of(context).primaryColor,
              textColor: Theme.of(context).textTheme.button.color,
              onPressed: _addTaskFromEntries,
            ),
          ),
        ],
      ),
    );
  }
}
