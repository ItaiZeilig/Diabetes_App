import 'package:cloud_firestore/cloud_firestore.dart';


class UserService {

  final databaseReference = Firestore.instance;

  Future<void> saveNewUser(String email , String displayName) async {
    await databaseReference.collection("users").add(
      {
      'email': email,
      'displayName': displayName,
      'createDate': FieldValue.serverTimestamp(),
    }
    );
  }
  
}