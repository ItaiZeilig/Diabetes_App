import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/createdBy.dart';
import '../models/message.dart';

Chat chatFromJson(String str) => Chat.fromJson(json.decode(str));

String chatToJson(Chat data) => json.encode(data.toJson());

class Chat {
    Chat({
        this.name,
        this.active,
        this.createTimestamp,
        this.createdBy,
        this.lastMessage,
    });

    String name;
    bool active;
    dynamic createTimestamp;
    CreatedBy createdBy;
    Message lastMessage;

    factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        name: json["name"],
        active: json["active"],
        createTimestamp: json["createTimestamp"],
        createdBy: CreatedBy.fromJson(json["createdBy"]),
        lastMessage: Message.fromJson(json["lastMessage"]),
    );

      factory Chat.fromSnapshot(DocumentSnapshot document) => Chat(
        name: document["name"],
        active: document["active"],
        createTimestamp: document["createTimestamp"],
        createdBy: CreatedBy.fromJson(document["createdBy"]),
        lastMessage: Message.fromJson(document["lastMessage"]),
      );


    Map<String, dynamic> toJson() => {
        "name": name,
        "active": active,
        "createTimestamp": createTimestamp,
        "createdBy": createdBy.toJson(),
        "lastMessage": lastMessage.toJson(),
    };
}

