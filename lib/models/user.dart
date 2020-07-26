import 'dart:convert';
import 'package:flutter/material.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    @required this.id,
    @required this.name,
    @required this.email,
    @required this.type,
    @required this.active,
    @required this.createTimestamp,
    @required this.diabetesType,
  });

  String id;
  String name;
  String email;
  String type;
  bool active;
  dynamic createTimestamp;
  String diabetesType;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        type: json["type"],
        active: json["active"],
        createTimestamp: json["createTimestamp"],
        diabetesType: json["diabetesType"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "type": type,
        "active": active,
        "createTimestamp": createTimestamp,
        "diabetesType": diabetesType,
      };
}
