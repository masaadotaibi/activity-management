import 'package:get/get.dart';
import '../models/user.dart';

class UserController extends GetxController {
  // 10 here we need an observable user model, so we have to use get utilities to so
  // thus we need _id, _name, _email in UserModel to be observable
  Rx<UserModel> _userModel = UserModel().obs;

  // 11 now we need a way to access this model after it is observable, we do this by giving back the user to any desired listener
  UserModel get user => _userModel.value;

  // 12 we need also to access the user by being able to set a new value to it (changing user object values)
  set user(UserModel value) => this._userModel.value = value;

  // 13 we now should be able to clear the user (in case of logged out)
  void clear() {
    _userModel.value = UserModel();
  }

  // 14 we're not going to use Firestore here, because we need more separation, and separate the database also
  // that is because, what if we want to use the database somewhere also in the app, this would violate DRY principle
  // also easier to handle and manage since the fucionalities are known
}
