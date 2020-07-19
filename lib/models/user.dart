import 'dart:convert';
import 'package:diabetes_app/models/createdBy.dart';
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
      // @required this.fullAge,
      // @required this.ageYears,
      // @required this.gendar,
      // @required this.dateOfBirth,
      // @required this.diabetesDiagnosisDate, 
      // @required this.weight,
      // @required this.height, 
      // @required this.bmi,
      // @required this.medication,
      // @required this.pump, 
      // @required this.sensor,
      // @required this.createdBy,
    });

    String id;
    String name;
    String email;
    String type;
    bool active;
    dynamic createTimestamp;
    String diabetesType;

    // dynamic fullAge;
    // int ageYears;
    // String gendar;
    // dynamic dateOfBirth;
    // dynamic diabetesDiagnosisDate;
    // String weight;
    // String height;
    // String bmi;
    // String medication;
    // String pump;
    // String sensor;
    // CreatedBy createdBy;
    
    

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        type: json["type"],
        active: json["active"],
        createTimestamp: json["createTimestamp"],
        diabetesType: json["diabetesType"],

        // fullAge: json["fullAge"],
        // ageYears: json["ageYears"],        
        // diabetesDiagnosisDate: json["diabetesDiagnosisDate"],
        // gendar: json["gender"],
        // dateOfBirth: json["dateOfBirth"],
        // weight: json["weight"],
        // height: json["height"],
        // bmi: json["bmi"],
        // medication: json["medication"],
        // pump: json["pump"],
        // sensor: json["sensor"],
        // createdBy: CreatedBy.fromJson(json["createdBy"]),        
        
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "type": type,
        "active": active,
        "createTimestamp": createTimestamp,
        "diabetesType": diabetesType,

        // "fullAge": fullAge,
        // "ageYears": ageYears,        
        // "diabetesDiagnosisDate": diabetesDiagnosisDate,
        // "gender": gendar,
        // "dateOfBirth": dateOfBirth,
        // "weight": weight,
        // "height": height,
        // "bmi": bmi,
        // "medication": medication,
        // "pump": pump,
        // "sensor": sensor,
        // "createdBy": createdBy.toJson(),        
    };
}
