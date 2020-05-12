import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class User {
  final String id;
  final String name;
  final String email;

  User({
    @required this.id,
    @required this.name,
    @required this.email
  });

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return User(
      id: doc.documentID,
      name: data['displayName'] ?? '',
     email: data['email'] ?? '',
     );
  }

}

class UserService with ChangeNotifier {

  final Firestore _db = Firestore.instance;

  Future<User> fetchUserByID(String uid) async {
    var snap = await _db.collection('users').document(uid).get();
    return User.fromFirestore(snap);
  }

  Future<void> createUser(String uid, String email, String name) async{
    await _db.collection('users').document(uid).setData({
      'email': email,
      'name': name,
      'createDate': FieldValue.serverTimestamp(),
    });
  }

}