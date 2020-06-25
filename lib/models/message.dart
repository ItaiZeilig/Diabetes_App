import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

Message messageFromJson(String str) => Message.fromJson(json.decode(str));

String messageToJson(Message data) => json.encode(data.toJson());

class Message {
  Message({
    this.userId,
    this.userName,
    this.type,
    this.message,
    this.createTimestamp,
  });

  String userId;
  String userName;
  String type;
  String message;
  dynamic createTimestamp;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        userId: json["userId"],
        userName: json["userName"],
        type: json["type"],
        message: json["message"],
        createTimestamp: json["createTimestamp"],
      );

  factory Message.fromSnapshot(DocumentSnapshot document) => Message(
        userId: document["userId"],
        userName: document["userName"],
        type: document["type"],
        message: document["message"],
        createTimestamp: document["createTimestamp"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "userName": userName,
        "type": type,
        "message": message,
        "createTimestamp": createTimestamp,
      };
}
