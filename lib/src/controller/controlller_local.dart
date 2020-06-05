import 'package:flutter/foundation.dart';
import 'package:work_witness/src/controller/dal_local.dart';
import 'package:work_witness/src/controller/models/project_report.dart';
import 'package:work_witness/src/controller/models/project_report_photo.dart';
import 'package:work_witness/src/controller/models/project_report_question.dart';

class ControllerLocal {
  final DalLocal dal;

  ControllerLocal({@required this.dal});

  static Future<ControllerLocal> create() async {
    return ControllerLocal(dal: await DalLocal.create());
  }

  Future<bool> insertProjectReport(ProjectReport projectReport) async {
    return dal.insertProjectReport(projectReport);
  }

  Future<List<ProjectReport>> getProjectReports(
      int idProject, int idEmployee) async {
    return dal.getProjectReports(idProject, idEmployee);
  }

  Future<List<ProjectReportQuestion>> getProjectReportQuestions(
      int idProjectReport) async {
    return dal.getProjectReportQuestions(idProjectReport);
  }

  Future<List<ProjectReportPhoto>> getProjectReportPhotos(
      int idProjectReport) async {
    return dal.getProjectReportPhotos(idProjectReport);
  }

  Future<bool> updateProjectReport(ProjectReport projectReport) async {
    return dal.updateProjectReport(projectReport);
  }

  Future<bool> deleteProjectReport(ProjectReport projectReport) async {
    return dal.deleteProjectReport(projectReport);
  }
}
