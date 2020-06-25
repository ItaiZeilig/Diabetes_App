import 'dart:convert';
import 'package:flutter/material.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
    User({
      @required this.id,
      @required this.name,
      @required this.email,
        this.type,
        this.active,
        this.createTimestamp,
    });

    String id;
    String name;
    String email;
    String type;
    bool active;
    dynamic createTimestamp;

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        type: json["type"],
        active: json["active"],
        createTimestamp: json["createTimestamp"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "type": type,
        "active": active,
        "createTimestamp": createTimestamp,
    };
}
