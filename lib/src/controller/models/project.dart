import 'package:flutter/foundation.dart';

class Project {
  final int id;
  final int idProject;
  final int idProjectType;
  final String projectNumber;
  final String project;
  final DateTime inictialDate;
  final int idEmployee;
  final int idCompany;
  final String company;
  final String codeEmployee;
  final String employee;
  final String email;

  const Project(
      {@required this.id,
      @required this.idProject,
      @required this.idProjectType,
      @required this.projectNumber,
      @required this.project,
      @required this.inictialDate,
      @required this.idEmployee,
      @required this.idCompany,
      @required this.company,
      @required this.codeEmployee,
      @required this.employee,
      @required this.email});

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
        id: json['id'],
        idProject: json['idProject'],
        idProjectType: json['idProjectType'],
        projectNumber: json['projectNumber'],
        project: json['project'],
        inictialDate: DateTime.parse(json['inictialDate']),
        idEmployee: json['idEmployee'],
        idCompany: json['idCompany'],
        company: json['company'],
        codeEmployee: json['codeEmployee'],
        employee: json['employee'],
        email: json['email']);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": idProject,
      "archived": 1
    };
  }
}
