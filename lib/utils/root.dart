import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/user_controller.dart';
import '../screens/personal_folder_view.dart';
import '../screens/login.dart';

class Root extends GetWidget<AuthController> {
  @override
  Widget build(BuildContext context) {
    return GetX(
      // 21 whenever go to the root (sign out, or so) widget we want to initialize the user controller here
      initState: (_) async {
        Get.put<UserController>(UserController());
      },
      builder: (_) {
        return Get.find<AuthController>().user?.uid != null
            ? PersonalFolder()
            : Login();
      },
    );
  }
}
