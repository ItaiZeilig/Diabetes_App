import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/article.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/createdBy.dart';

class ArticleProvider with ChangeNotifier {
  final CollectionReference _articlesCollectionReference =
      Firestore.instance.collection('articles');

  String dateToday = DateFormat.yMMMd().format(DateTime.now());

  List<Article> articles = [];

  getArticleId() {
    var ref =
        _articlesCollectionReference.getDocuments();
    ref.then((v) => (v.documents[0].documentID));
  }

  Future createArticle(Article article) async {
    try {
      await _articlesCollectionReference
          .document(article.id)
          .setData(article.toJson());
    } catch (e) {
      return e.message;
    }
  }

  Stream<QuerySnapshot> getAllArticlesByType(String id, int diabetesType) {
  try {
    return _articlesCollectionReference
      .document(id)
      .collection("articles")
      .where("diabetesType", isEqualTo: diabetesType)
      .snapshots();  
  } catch (e) {
    return e.message;
  }
    
}



  Future addNewArticle(
      String id, String title, String subtitle, String content, String category,
      int diabetesType,dynamic time,String author,String image,CreatedBy createdBy, bool isPopular) async {
    return await _articlesCollectionReference.document(id).setData({
        "id": id,
        "title": title,
        "subtitle": subtitle,
        "content": content,
        "category": category,
        "diabetesType": diabetesType,
        "time": time,
        "author": author,
        //"seen": seen,
        //"favorite": favorite,
        "image": image,
        "createdBy": createdBy.toJson(),
        "isPopular" : isPopular,
    });
  }

  List<Article> _articleListFromSpanshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Article(
        id: doc.data["id"] ?? '',
        title: doc.data["title"] ?? '',
        subtitle: doc.data["subtitle"] ?? '',
        content: doc.data["content"] ?? '',
        category: doc.data["category"] ?? '',
        diabetesType: doc.data["diabetesType"] ?? '',
        time: doc.data["time"] ?? '',
        author: doc.data["author"] ?? '',
        seen: doc.data["seen"] ?? '',
        favorite: doc.data["favorite"] ?? '',
        image: doc.data["image"] ?? '',
        createdBy: CreatedBy.fromJson(doc.data["createdBy"]) ?? '',
      );
    }).toList();
  }

  Stream<List<Article>> get reciveAllArticlesFromDB {
    return _articlesCollectionReference.snapshots().map(_articleListFromSpanshot);
  }

  Future<List<Article>> reciveAllArticlesFromDBFuture() async {
    var snapshot = await _articlesCollectionReference.getDocuments();
    var answer = _articleListFromSpanshot(snapshot);
    return answer.toList();
  }

}