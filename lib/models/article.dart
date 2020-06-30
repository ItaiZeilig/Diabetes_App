import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/createdBy.dart';

Article articleFromJson(String str) => Article.fromJson(json.decode(str));

String articleToJson(Article data) => json.encode(data.toJson());

class Article {
    Article({
        this.id,
        this.title,
        this.subtitle,
        this.content,
        this.category,
        this.diabetesType,
        this.time,
        this.author,
        this.seen,
        this.favorite,
        this.image,
        this.createdBy,
    });

    String id;
    String title;
    String subtitle;
    String content;
    String category;
    int diabetesType;
    dynamic time;
    String author;
    String seen;
    String favorite;
    String image;
    CreatedBy createdBy;

    factory Article.fromJson(Map<String, dynamic> json) => Article(
        id: json["id"],
        title: json["title"],
        subtitle: json["subtitle"],
        content: json["content"],
        category: json["category"],
        diabetesType: json["diabetesType"],
        time: json["time"],
        author: json["author"],
        seen: json["seen"],
        favorite: json["favorite"],
        image: json["image"],
        createdBy: CreatedBy.fromJson(json["createdBy"]),
    );

     factory Article.fromSnapshot(DocumentSnapshot document) => Article(
        id: document["id"],
        title: document["title"],
        subtitle: document["subtitle"],
        content: document["content"],
        category: document["category"],
        diabetesType: document["diabetesType"],
        time: document["time"],
        author: document["author"],
        seen: document["seen"],
        favorite: document["favorite"],
        image: document["image"],
        createdBy: CreatedBy.fromJson(document["createdBy"]),
      );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "subtitle": subtitle,
        "content": content,
        "category": category,
        "diabetesType": diabetesType,
        "time": time,
        "author": author,
        "seen": seen,
        "favorite": favorite,
        "image": image,
        "createdBy": createdBy.toJson(),
    };
}




   
