import 'package:diabetes_app/providers/user_service.dart';
import 'package:diabetes_app/screens/home_screen.dart';
import 'package:diabetes_app/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class Auth with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final UserService _userService = new UserService();

  // Firebase user one-time fetch
  Future<FirebaseUser> get getUser async =>  await _firebaseAuth.currentUser();



  Future signIn({
    @required String email,
    @required String password,
  }) async {
    try {
      var authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return authResult.user != null;
    } catch (e) {
      return e.message;
    }
  }

  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }

  Future signUp({
    @required String email,
    @required String password,
    @required String name,
  }) async {
    try {
      var authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _userService.createUser(new User(
        id: authResult.user.uid,
        email: email,
        name: name,
      ));
      return authResult.user != null;
    } catch (e) {
      return e.message;
    }
  }

  handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HomeScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
