import 'dart:io';

import 'package:flutter/foundation.dart';

class ProjectReportPhoto {
  int id;
  int idProjectReport;
  final double latitude;
  final double longitude;
  final String photo;
  bool disabled;
  int idServer;

  ProjectReportPhoto({
    @required this.id,
    @required this.idProjectReport,
    @required this.latitude,
    @required this.longitude,
    @required this.photo,
    this.disabled = false,
    this.idServer,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "id_project_report": idProjectReport,
      "latitude": latitude,
      "longitude": longitude,
      "photo": photo,
      "id_server": idServer != null ? idServer : 0,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      "id": null,
      "idProjectReport": idProjectReport,
      "latitude": latitude,
      "longitude": longitude,
      "photo": photo,
    };
  }

  factory ProjectReportPhoto.fromMap(dynamic map) {
    return ProjectReportPhoto(
      id: map["id"],
      idProjectReport: map["id_project_report"],
      latitude: map["latitude"],
      longitude: map["longitude"],
      photo: map["photo"],
      idServer: map["id_server"],
    );
  }

  factory ProjectReportPhoto.fromJson(dynamic map) {
    return ProjectReportPhoto(
      id: map["id"],
      idProjectReport: map["idProjectReport"],
      latitude: map["latitude"],
      longitude: map["longitude"],
      photo: map["photo"],
    );
  }
}
