import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/challenge.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChallengesProvider with ChangeNotifier {
  final CollectionReference _challengesCollectionReference =
      Firestore.instance.collection('challenges');

  String dateToday = DateFormat.yMMMd().format(DateTime.now());

  final int numOfChallenges = 3;

  int allChallengesTabIndex = 0;

  String searchText = '';

  List<Challenge> challenges = [];

  void setTabIndex(int index) {
    allChallengesTabIndex = index;
    notifyListeners();
  }

  void setSearchText(String text) {
    searchText = text;
    notifyListeners();
  }

  Future deleteChallenge(Challenge challenge) async {
    await _challengesCollectionReference
        .document("system_challenges")
        .collection("all_challenges")
        .document(challenge.id)
        .delete();
  }

  Future updateUserChallenge(Challenge challenge, String uid) async {
    try {
      await _challengesCollectionReference
          .document("users_challenges")
          .collection(uid)
          .document(dateToday)
          .collection("daily_challenges")
          .document(challenge.id)
          .setData(challenge.toJson());
    } catch (e) {
      return e.message;
    }
  }

  Future updateSingleChallenge(Challenge challenge) async {
    try {
      await _challengesCollectionReference
          .document("system_challenges")
          .collection("all_challenges")
          .document(challenge.id)
          .setData(challenge.toJson());
    } catch (e) {
      return e.message;
    }
  }

  Future addChallengeToUserByDay(String uid, String diabetesType) async {
    try {
      List<Challenge> allChallengesList = List<Challenge>();
      List<Challenge> userChallengesList = List<Challenge>();
      var userFuture = await _challengesCollectionReference
          .document("users_challenges")
          .collection(uid)
          .document(dateToday)
          .collection("daily_challenges")
          .getDocuments();

      if (userFuture.documents.length < numOfChallenges) {
        var future = await _challengesCollectionReference
            .document("system_challenges")
            .collection("all_challenges")
            .where('diabetesType', isEqualTo: diabetesType)
            .getDocuments();
        var documents = future.documents;
        documents.forEach((document) {
          allChallengesList.add(Challenge.fromSnapshot(document));
        });
        allChallengesList.shuffle();
        userChallengesList = allChallengesList
            .take(numOfChallenges - userFuture.documents.length)
            .toList();
        userChallengesList.forEach((challenge) {
          updateUserChallenge(challenge, uid);
        });
      }
    } catch (e) {
      return e.message;
    }
  }

  Stream<QuerySnapshot> getUserDailyChallengesSnapshot(String uid) {
    try {
      return _challengesCollectionReference
          .document("users_challenges")
          .collection(uid)
          .document(dateToday)
          .collection("daily_challenges")
          .limit(3)
          .snapshots();
    } catch (e) {
      return e.message;
    }
  }

  Stream<QuerySnapshot> getAllChallengesBySatusSnapshot(bool status) {
    try {
      return _challengesCollectionReference
          .document("system_challenges")
          .collection("all_challenges")
          .where("active", isEqualTo: status)
          .limit(30)
          .snapshots();
    } catch (e) {
      return e.message;
    }
  }
}
