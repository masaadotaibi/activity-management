import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';
import '../models/user.dart';
import '../services/personal_folder_collection.dart';

// * We want the authentication instance to be available the whole time the app is running
// * thus we have to have something that persist it, that is AuthBinding()
class AuthController extends GetxController {
  // 1
  FirebaseAuth _auth = FirebaseAuth.instance;
  Rx<FirebaseUser> _firebaseUser = Rx<FirebaseUser>();

  // 4 we need to get the firebase stream of the user
  FirebaseUser get user => _firebaseUser.value;

  // 5 when the firebase user is logged in, out, etc, we want that stream to be shared throughout the app to check each state
  // 5.1 we want to stream data directly after the initiation of this object (AuthController)
  @override
  void onInit() {
    // 5.2 bind firebase stream to the actual user
    // 5.3 thus whenever the instance of this app is created then we check everytime the state of authentication has changed
    _firebaseUser.bindStream(_auth.onAuthStateChanged);
  }

  // 2 we need creating account functionality
  void createUser(String email, String name, String password) async {
    try {
      AuthResult _authResult = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password);

      // 19 now we created the user in firebase, we then need to create its model in Firestore database
      // 19.1 we first create the coressponding model
      UserModel _user = UserModel(
        name,
        _authResult.user.uid,
        _authResult.user.email,
      );

      // 19.2 we then inject the created model to create it at Firestore database, and the function we use returns bool
      if (await PersonalFolderCollection().createNewUser(_user)) {
        // 19.3 since the above function returns a boolean, we can check if the user successfully created then we can assign the user
        // to the newly created model and this can be done this way (the setter we made earlier in Database())
        Get.find<UserController>().user =
            _user; // assign the current user to the newly created user
        Get.back(); // this to pop off the sign up screen and go back to login screen
      }
    } catch (e) {
      Get.snackbar(
        'Error creating account',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // 3 we need log in functionality
  void login(String email, String password) async {
    try {
      AuthResult _authResult = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
      Get.find<UserController>().user =
          await PersonalFolderCollection().getUser(_authResult.user.uid);
    } catch (e) {
      Get.snackbar(
        'Error Log into account',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void signout() async {
    try {
      await _auth.signOut();
      // 20 we clear the user model whenever we sign out
      Get.find<UserController>().clear();
    } catch (e) {
      Get.snackbar(
        'Error sign out of account',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
