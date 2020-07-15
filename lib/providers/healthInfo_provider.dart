import 'package:age/age.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes_app/models/createdBy.dart';
import '../models/healthInfo.dart';
import 'package:flutter/material.dart';

class HealthInfoProvider with ChangeNotifier {

  final CollectionReference _healthInfoReference =
      Firestore.instance.collection('healthInfo');


  Future addNewHealthInfo(
      String id, String name, String fullAge, int ageYears, String diabetesType, String gendar, 
      dynamic dateOfBirth, dynamic diabetesDiagnosisDate , String weight, String height, String bmi,
      String medication, String pump, String sensor, CreatedBy createdBy, String email) async {
    return await _healthInfoReference.document(id).setData({
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
    });
  }

  Future createNewChatRoomForUser(HealthInfo info, String uid) async {
    try {
      await _healthInfoReference.document(uid).setData(info.toJson());
    } catch (e) {
      return e.message;
    }
  }
}
