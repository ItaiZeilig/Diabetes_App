import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/healthInfo.dart';
import 'package:flutter/material.dart';

class HealthInfoProvider with ChangeNotifier {
  final CollectionReference _chatsCollectionReference =
      Firestore.instance.collection('healthInfo');

  Future createNewChatRoomForUser(HealthInfo info, String uid) async {
    try {
      await _chatsCollectionReference.document(uid).setData(info.toJson());
    } catch (e) {
      return e.message;
    }
  }
}
