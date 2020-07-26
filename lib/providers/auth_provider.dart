import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes_app/models/healthInfo.dart';
import 'package:diabetes_app/screens/home_screen.dart';
import 'package:diabetes_app/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final CollectionReference _usersCollectionReference =
      Firestore.instance.collection('users');

  User user;
  User get getUser => user;

  HealthInfo healthInfo;

  // Firebase user one-time fetch
  Future<FirebaseUser> get getFirebaseUser async =>
      await _firebaseAuth.currentUser();

  Future signIn({
    @required String email,
    @required String password,
  }) async {
    try {
      var authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      return e.message;
    }
  }

  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }

  Future updateUserInfo(User user) async {
    try {
      await _usersCollectionReference.document(user.id).setData(user.toJson());
    } catch (e) {
      return e.message;
    }
  }

  Future resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return 'Please check your email for reset your password';
    } catch (e) {
      return e.message;
    }
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
      await createUser(new User(
        id: authResult.user.uid,
        email: email,
        name: name,
        active: true,
        createTimestamp: FieldValue.serverTimestamp(),
        type: "Doctor",
      ));
    } catch (e) {
      return e.message;
    }
  }

  Future createUser(User user) async {
    try {
      await _usersCollectionReference.document(user.id).setData(user.toJson());
    } catch (e) {
      return e.message;
    }
  }

  Future<void> fetchAndSetUser() async {
    try {
      var firebaseUser = await getFirebaseUser;
      var userData =
          await _usersCollectionReference.document(firebaseUser.uid).get();
      user = User.fromJson(userData.data);
      notifyListeners();
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
