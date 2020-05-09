import 'package:cloud_firestore/cloud_firestore.dart';


class UserService {

  final String uid;
  UserService({this.uid});

final databaseReference = Firestore.instance;

Future<void> saveNewUser(String uId, String email, String displayName) async {
    await databaseReference.collection("users").document(uId).setData({
      'email': email,
      'displayName': displayName,
      'createDate': FieldValue.serverTimestamp(),
    });
  }

  
}