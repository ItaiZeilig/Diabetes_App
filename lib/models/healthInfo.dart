import 'dart:convert';

HealthInfo healthInfoFromJson(String str) =>
    HealthInfo.fromJson(json.decode(str));

String healthInfoToJson(HealthInfo data) => json.encode(data.toJson());

class HealthInfo {
  HealthInfo({
    this.id,
    this.diabetesType,
    this.gender,
    this.dateOfBirth,
    this.weight,
    this.height,
    this.medication,
    this.pump,
    this.sensor,
    this.bmi,
    this.age,
  });

  String id;
  int diabetesType;
  String gender;
  DateTime dateOfBirth;
  int weight;
  int height;
  String medication;
  bool pump;
  bool sensor;
  double bmi;
  int age;

  factory HealthInfo.fromJson(Map<String, dynamic> json) => HealthInfo(
        id: json["id"],
        diabetesType: json["diabetesType"],
        gender: json["gender"],
        dateOfBirth: json["dateOfBirth"],
        weight: json["weight"],
        height: json["height"],
        medication: json["medication"],
        pump: json["pump"],
        sensor: json["sensor"],
        bmi: json["bmi"].toDouble(),
        age: json["age"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "diabetesType": diabetesType,
        "gender": gender,
        "dateOfBirth": dateOfBirth,
        "weight": weight,
        "height": height,
        "medication": medication,
        "pump": pump,
        "sensor": sensor,
        "bmi": bmi,
        "age": age,
      };
}
