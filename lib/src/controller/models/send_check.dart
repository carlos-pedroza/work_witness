import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class SendCheck {
  final int id;
  final int idProject;
  final int idEmployee;
  final int idCheckType;
  final double longitude;
  final double latitude;
  final DateTime value;

  SendCheck({
    @required this.id,
    @required this.idProject,
    @required this.idEmployee,
    @required this.idCheckType,
    @required this.longitude,
    @required this.latitude,
    @required this.value,
  });

  factory SendCheck.fromJson(Map<String, dynamic> json) {
    return SendCheck(
      id: json["id"],
      idProject: json["idProject"],
      idEmployee: json["idEmployee"],
      idCheckType: json["idCheckType"],
      longitude: json["longitude"],
      latitude: json["latitude"],
      value: DateTime.parse(json["value"]),
    );
  }

  Map<String, String> toJson() {
    return {
      "id": this.id.toString(),
      "idProject": this.idProject.toString(),
      "idEmployee": this.idEmployee.toString(),
      "idCheckType": this.idCheckType.toString(),
      "longitude": this.longitude.toString(),
      "latitude": this.latitude.toString(),
      "value": this.value.toString(),
    };
  }
}
