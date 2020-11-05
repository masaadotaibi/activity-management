import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoriesScreen extends StatelessWidget {
  final _categoryTextController = TextEditingController();

  void _categoryForm() {
    Get.defaultDialog(
      title: 'New Category',
      barrierDismissible: false,
      content: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Category Name',
              labelText: 'Cateogry',
            ),
          ),
        ],
      ),
      actions: [
        FlatButton(
          onPressed: () {
            Get.back();
          },
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.red),
          ),
        ),
        FlatButton(
          onPressed: () {
            //
          },
          child: Text('Add'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Categories'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _categoryForm();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
