import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class User {
  final String id;
  final String name;
  final String email;

  User({this.id, this.name, this.email});

  User.fromData(Map<String, dynamic> data)
      : id = data['id'],
        name = data['name'],
        email = data['email'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}

class UserService with ChangeNotifier {
  final CollectionReference _usersCollectionReference =
      Firestore.instance.collection('users');
      
  User _user;

  User get getUser => _user;

  Future createUser(User user) async {
    try {
      await _usersCollectionReference.document(user.id).setData(user.toJson());
    } catch (e) {
      return e.message;
    }
  }

  Future<void> fetchAndSetUser(String uid) async {
    try {
      var userData = await _usersCollectionReference.document(uid).get();
      _user = User.fromData(userData.data);
      notifyListeners();
    } catch (e) {
      return e.message;
    }
  }
}
