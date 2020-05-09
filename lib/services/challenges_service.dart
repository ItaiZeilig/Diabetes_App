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
}


/*
deleteFood(Challenge singleChallenge, Function challengeDeleted) async {

  await Firestore.instance.collection('Challenges').document(singleChallenge.id).delete();
  challengeDeleted(singleChallenge);
}
*/

// Future<List<GroupWithIds>> groupsToPairs (QuerySnapshot groupSnap) {
//     return Future.wait(groupSnap.documents.map((DocumentSnapshot groupDoc) async {
//       return await groupToPair(groupDoc);
//     }).toList());
//   }

// Stream<List<GroupWithIds>> stream = Firestore.instance
//         .collection('Challenges')
//         .orderBy('id')
//         .snapshots()
//         .asyncMap((QuerySnapshot groupSnap) => groupsToPairs(groupSnap));

//     return StreamBuilder(
//         stream: stream,
//         builder: (BuildContext c, AsyncSnapshot<List<GroupWithUsers>> snapshot) {
//             // build whatever
//     }
//     )

//     Future<GroupWithIds> groupToPair(DocumentSnapshot groupDoc) {
//     return Firestore.instance
//         .collection('Challenges')
//         .where('id', isEqualTo: groupDoc.documentID)
//         //.orderBy('createdAt', descending: false)
//         .getDocuments()
//         .then((usersSnap) {
//       List<Challenge> users = [];
//       for (var doc in usersSnap.documents) {
//         users.add(Challenge.from(doc));
//       }

//       return GroupWithIds(Group.from(groupDoc), users);
//     });
//   }
