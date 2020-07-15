import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/createdBy.dart';

Challenge challengeFromJson(String str) => Challenge.fromJson(json.decode(str));

String challengeToJson(Challenge data) => json.encode(data.toJson());

class Challenge {
  Challenge({
    this.name,
    this.active,
    this.createTimestamp,
    this.type,
    this.diabetesType,
    this.doneItems,
    this.numberOfItems,
    this.done,
    this.createdBy,
    this.id,
  });

  String name;
  bool active;
  dynamic createTimestamp;
  String type;
  int doneItems;
  int numberOfItems;
  int diabetesType;
  bool done;
  CreatedBy createdBy;
  String id;

  factory Challenge.fromJson(Map<String, dynamic> json) => Challenge(
        name: json["name"],
        active: json["active"],
        createTimestamp: json["createTimestamp"],
        type: json["type"],
        doneItems: json["doneItems"],
        diabetesType: json["diabetesType"],
        numberOfItems: json["numberOfItems"],
        done: json["done"],
        id: json["id"],
        createdBy: CreatedBy.fromJson(json["createdBy"]),
      );

  factory Challenge.fromSnapshot(DocumentSnapshot document) => Challenge(
        name: document["name"],
        active: document["active"],
        createTimestamp: document["createTimestamp"],
        type: document["type"],
        diabetesType: document["diabetesType"],
        doneItems: document["doneItems"],
        numberOfItems: document["numberOfItems"],
        done: document["done"],
        id: document["id"],
        createdBy: CreatedBy.fromJson(document["createdBy"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "active": active,
        "createTimestamp": createTimestamp,
        "type": type,
        "diabetesType": diabetesType,
        "doneItems": doneItems,
        "numberOfItems": numberOfItems,
        "done": done,
        "id": id,
        "createdBy": createdBy.toJson(),
      };
}
