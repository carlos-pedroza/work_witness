import 'package:flutter/foundation.dart';
import 'package:work_witness/src/controller/models/project_report_photo.dart';
import 'package:work_witness/src/controller/models/project_report_question.dart';

class ProjectReport {
  int id;
  int idProject;
  int idEmployee;
  int idProjectType;
  DateTime recordDate;
  String location;
  String description;
  int hours;
  int minutes;
  DateTime create;
  DateTime modify;
  bool isSended;
  bool closed;
  bool disabled;
  List<ProjectReportQuestion> projectReportQuestions;
  List<ProjectReportPhoto> projectReportPhotos;
  int idServer;

  ProjectReport({
    @required this.id,
    @required this.idProject,
    @required this.idEmployee,
    @required this.idProjectType,
    @required this.recordDate,
    @required this.location,
    @required this.description,
    @required this.hours,
    @required this.minutes,
    @required this.create,
    @required this.modify,
    @required this.isSended,
    @required this.closed,
    @required this.disabled,
    @required this.projectReportQuestions,
    @required this.projectReportPhotos,
    this.idServer,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_project': idProject,
      'id_employee': idEmployee,
      'id_projecttype': idProjectType,
      'record_date': recordDate.millisecondsSinceEpoch.toString(),
      'location': location,
      'description': description,
      'hours': hours,
      'minutes': minutes,
      'create_date': create.toString(),
      'modify_date': modify.toString(),
      'is_sended': isSended ? 1 : 0,
      'closed': closed ? 1 : 0,
      'disabled': disabled ? 1 : 0,
      'id_server': idServer != null ? idServer : 0,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': null,
      'idProject': idProject,
      'idEmployee': idEmployee,
      'idProjectType': idProjectType,
      'recordDate': recordDate.toString(),
      'location': location,
      'description': description,
      'hours': hours,
      'minutes': minutes,
      'createDate': create.toString(),
      'modifyDate': modify.toString(),
      'isSended': isSended ? 1 : 0,
      'closed': closed ? 1 : 0,
      'disabled': disabled ? 1 : 0,
    };
  }

  factory ProjectReport.fromMap(dynamic map) {
    return ProjectReport(
      id: map['id'],
      idProject: map['id_project'],
      idEmployee: map['id_employee'],
      idProjectType: map['id_projecttype'],
      recordDate: DateTime.fromMillisecondsSinceEpoch(map['record_date']),
      location: map['location'],
      description: map['description'],
      hours: map['hours'],
      minutes: map['minutes'],
      create: DateTime.parse(map['create_date']),
      modify: DateTime.parse(map['modify_date']),
      closed: map['closed'] == 1,
      isSended: map['is_sended'] == 1,
      disabled: map['disabled'] == 1,
      projectReportQuestions: [],
      projectReportPhotos: [],
      idServer: map['id_server'],
    );
  }

  factory ProjectReport.fromJson(dynamic map) {
    return ProjectReport(
      id: map['id'],
      idProject: map['idProject'],
      idEmployee: map['idEmployee'],
      idProjectType: map['idProjectType'],
      recordDate: DateTime.parse(map['recordDate']),
      location: map['location'],
      description: map['description'],
      hours: map['hours'],
      minutes: map['minutes'],
      create: DateTime.parse(map['createDate']),
      modify: DateTime.parse(map['modifyDate']),
      closed: map['closed'] == 1,
      isSended: map['isSended'] == 1,
      disabled: map['disabled'] == 1,
      projectReportQuestions: [],
      projectReportPhotos: [],
    );
  }

  void copyCloud(ProjectReport projectReport) {
    idProject = projectReport.idProject;
    idEmployee = projectReport.idEmployee;
    idProjectType = projectReport.idProjectType;
    recordDate = projectReport.recordDate;
    location = projectReport.location;
    description = projectReport.description;
    hours = projectReport.hours;
    minutes = projectReport.minutes;
    create = create;
    modify = modify;
    isSended = projectReport.isSended;
    closed = projectReport.closed;
    disabled = projectReport.disabled;
    projectReportQuestions = projectReport.projectReportQuestions;
    projectReportPhotos = projectReport.projectReportPhotos;
    idServer = projectReport.id;
  }

}
