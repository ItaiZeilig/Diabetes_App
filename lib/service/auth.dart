import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class Auth with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser user;
  IdTokenResult _token;
  
  Future<String> signIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    user = result.user;
  
    notifyListeners();
    return user.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    user = await _firebaseAuth.currentUser();
    return user;
  }

  bool get isAuth {
    return user != null;
  }

  Future<void> signOut() async {
    _firebaseAuth.signOut();
    notifyListeners();
    return;
  }
}
