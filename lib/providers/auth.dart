import 'package:diabetes_app/screens/challenge_screen.dart';
import 'package:diabetes_app/services/user_service.dart';
import 'package:diabetes_app/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';


class Auth with ChangeNotifier {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final UserService userService = new UserService();
  FirebaseUser user;

  

  Future<void> signIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    user = result.user;
    return user.uid;
    notifyListeners();
  }

  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }


  Future<void> signUp(String email, String password,String displayName) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    user = result.user;
    await userService.saveNewUser(user.uid, email, displayName);
    await this.signIn(email, password);
    return user.uid;
    notifyListeners();
  }

   handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          //return NewChallengeScreen();
         return NewChallengeScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }

}