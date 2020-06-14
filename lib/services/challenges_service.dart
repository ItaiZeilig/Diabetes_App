import 'package:diabetes_app/dailyChallenge/challenge.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChallengeService {
  final String uid;
  ChallengeService({this.uid});

  final CollectionReference allChallenges =
      Firestore.instance.collection('Challenges');

  Future addNewChallenge(
      String name, String category, String id, String searchKey) async {
    return await allChallenges.document(uid).setData({
      'name': name,
      'category': category,
      'id': id,
      'searchKey': searchKey,
    });
  }
  //Just for future use
  //Firestore.instance.collection('Challenges').document().documentID.toString() // Generate New Auto ID Document

  getChallngeId(String challengeName) {
    var ref =
        allChallenges.where("name", isEqualTo: challengeName).getDocuments();
    ref.then((v) => setChallngeId(v.documents[0].documentID));
  }

  Future setChallngeId(String id) async {
    return await allChallenges.document(id).updateData({
      'id': id,
    });
  }

  deleteChallemngeByName(String name) {
    var ref = allChallenges.where("name", isEqualTo: name).getDocuments();
    ref.then((v) => deleteChallenge(v.documents[0].documentID));
  }

  Future deleteChallenge(String id) async {
    await Firestore.instance.collection('Challenges').document(id).delete();
  }

  updateChallemngeByName(String nameBeforeUpdate, String name, String category, String searchKey) {
    var ref = allChallenges.where("name", isEqualTo: nameBeforeUpdate).getDocuments();
    ref.then(
      (v) => updateChallenge((v.documents[0].documentID), name, category, searchKey));
  }

  Future updateChallenge(String id, String name, String category, String searchKey) async {
    return await allChallenges.document(id).updateData({
      'name': name,
      'category': category,
      'searchKey': searchKey,
    });
  }


  Future<List<Challenge>> fetchAllUsers(Challenge currentChallenge) async {
    List<Challenge> challengeList = List<Challenge>();
    QuerySnapshot querySnapshot =
        await allChallenges.getDocuments();
    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID != currentChallenge.id) {
        challengeList.add(Challenge.fromMap(querySnapshot.documents[i].data));
      }
    }
    return challengeList;
  }
  

  //  Future<>searchChallengeByName(String name) {
  //   return Firestore.instance
  //       .collection('Challenges')
  //       .where('name',
  //           isEqualTo: name)
  //       .getDocuments();
  // }


  Future<bool> doesNameAlreadyExist(String name) async {
    //try {
      final QuerySnapshot result = await Firestore.instance
        .collection('Challenges')
        .where('name', isEqualTo: name)
        //.limit(1)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    return documents.length == 1;  
    //}
    // catch (e) {
    //   return e.message;
    // }
    
  }

  List<Challenge> _challengeListFromSpanshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Challenge(
        name: doc.data['name'] ?? '',
        category: doc.data['category'] ?? '',
        id: doc.data['id'] ?? '',
        searchKey: doc.data['searchKey'] ?? '',
      );
    }).toList();
  }

  Stream<List<Challenge>> get reciveAllChallengesFromDB {
    return allChallenges.snapshots().map(_challengeListFromSpanshot);
  }

  Future<List<Challenge>> reciveAllChallengesFromDBFuture() async {
    var snapshot = await allChallenges.getDocuments();
    var answer = _challengeListFromSpanshot(snapshot);
    return answer.toList();
  }

  Stream<Challenge> get challengeData {
    return allChallenges.document(uid).snapshots().map(_challengeFromSnapshot);
  }

  Challenge _challengeFromSnapshot(DocumentSnapshot snapshot) {
    return Challenge(
      category: snapshot.data['category'],
      id: snapshot.data['id'] ?? '',
      name: snapshot.data['name'],
      searchKey: snapshot.data['searchKey'] ?? '',
    );
  }
}
