import 'package:diabetes_app/dailyChallenge/challenge.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ChallengeService {

final String uid;
  ChallengeService({this.uid});

  final CollectionReference allChallenges =
      Firestore.instance.collection('Challenges');

  Future updateChallenge(String name, String category, String id, int randIndex) async {
    return await allChallenges.document(uid).setData({
      'name' : name,
      'category': category,
      'id' : id,
      'randIndex' : randIndex,
    });
  }

  List<Challenge> _challengeListFromSpanshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Challenge(
        name: doc.data['name'] ?? '',
        category: doc.data['category'] ?? '',
        id: doc.data['id'] ?? '',
        randIndex: doc.data['randIndex'] ?? 0,
      );
    }).toList();
  }


  Stream<List<Challenge>> get reciveAllChallengesFromDB {
    return allChallenges.snapshots().map(_challengeListFromSpanshot);
  }

  Future<List<Challenge>> reciveAllChallengesFromDBFuture() async {
    var snapshot = await allChallenges.getDocuments();
    var answer = _challengeListFromSpanshot(snapshot);
    return answer;
  }
}


/*
deleteFood(Challenge singleChallenge, Function challengeDeleted) async {

  await Firestore.instance.collection('Challenges').document(singleChallenge.id).delete();
  challengeDeleted(singleChallenge);
}
*/


