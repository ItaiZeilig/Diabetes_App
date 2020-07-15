import 'dart:convert';

import 'package:age/age.dart';
import 'package:diabetes_app/models/createdBy.dart';

HealthInfo healthInfoFromJson(String str) =>
    HealthInfo.fromJson(json.decode(str));

String healthInfoToJson(HealthInfo data) => json.encode(data.toJson());

//TODO - Add user email attribute

class HealthInfo {
  HealthInfo({
    this.id,
    this.name,
    this.fullAge,
    this.ageYears,
    this.diabetesType,
    this.gendar,
    this.dateOfBirth,
    this.diabetesDiagnosisDate,
    this.weight,
    this.height,
    this.bmi,
    this.medication,
    this.pump,
    this.sensor,
    this.createdBy,  
    this.email,  
  });

  String id;
  String name;
  dynamic fullAge;
  int ageYears;
  String diabetesType;
  String gendar;
  dynamic dateOfBirth;
  dynamic diabetesDiagnosisDate;
  String weight;
  String height;
  String bmi;
  String medication;
  String pump;
  String sensor;
  CreatedBy createdBy;
  String email;

  factory HealthInfo.fromJson(Map<String, dynamic> json) => HealthInfo(
        id: json["id"],
        name: json["name"],
        fullAge: json["fullAge"],
        ageYears: json["ageYears"],
        diabetesType: json["diabetesType"],
        diabetesDiagnosisDate: json["diabetesDiagnosisDate"],
        gendar: json["gender"],
        dateOfBirth: json["dateOfBirth"],
        weight: json["weight"].toDouble(),
        height: json["height"].toDouble(),
        bmi: json["bmi"].toDouble(),
        medication: json["medication"],
        pump: json["pump"],
        sensor: json["sensor"],
        createdBy: CreatedBy.fromJson(json["createdBy"]),        
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
      "id": id,
        "name": name,
        "fullAge": fullAge,
        "ageYears": ageYears,
        "diabetesType": diabetesType,
        "diabetesDiagnosisDate": diabetesDiagnosisDate,
        "gender": gendar,
        "dateOfBirth": dateOfBirth,
        "weight": weight,
        "height": height,
        "bmi": bmi,
        "medication": medication,
        "pump": pump,
        "sensor": sensor,
        "createdBy": createdBy.toJson(), 
      "email": email,               
      };
}
