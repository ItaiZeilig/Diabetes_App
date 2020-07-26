import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes_app/models/createdBy.dart';
import '../models/healthInfo.dart';
import 'package:flutter/material.dart';

class HealthInfoProvider with ChangeNotifier {
  final CollectionReference _healthInfoReference =
      Firestore.instance.collection('healthInfo');

  HealthInfo healthInfo;

  Future fetchHealthInfoByEmail(String email) async {
    var doc = await _healthInfoReference.document(email).get();
    healthInfo = HealthInfo.fromJson(doc.data);
    notifyListeners();
  }

  Future updateHealthInfoEmail(String email, String oldEmail) async {
    fetchHealthInfoByEmail(oldEmail).whenComplete(() {
      healthInfo.email = email;
      _healthInfoReference
          .document(email)
          .setData(healthInfo.toJson())
          .whenComplete(() {
        _healthInfoReference.document(oldEmail).delete();
      });
    });
  }

  Future addNewHealthInfo(
      String id,
      String name,
      String fullAge,
      int ageYears,
      String diabetesType,
      String gendar,
      dynamic dateOfBirth,
      dynamic diabetesDiagnosisDate,
      String weight,
      String height,
      String bmi,
      String medication,
      String pump,
      String sensor,
      CreatedBy createdBy,
      String email) async {
    bool exist = await checkIfEmailExist(email);
    if (!exist) {
      return await _healthInfoReference.document(email).setData({
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
    } else {
      return 'This email already exist';
    }
  }

  Future checkIfEmailExist(String email) async {
    try {
      var response = await _healthInfoReference.document(email).get();
      if (response.exists) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return e.message;
    }
  }
}
