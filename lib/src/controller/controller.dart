import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:work_witness/src/controller/controlller_local.dart';
import 'package:work_witness/src/controller/models/comment.dart';
import 'package:work_witness/src/controller/models/localitation.dart';
import 'package:work_witness/src/controller/models/project_project_type.dart';
import 'package:work_witness/src/controller/models/project_type_question.dart';
import 'package:work_witness/src/controller/models/send_check.dart';
import 'package:work_witness/src/controller/models/subscribe_info.dart';
import 'package:work_witness/src/controller/models/subscription.dart';
import 'package:work_witness/src/controller/models/subscription_benefit.dart';
import 'package:work_witness/src/controller/models/subscription_result.dart';
import 'package:work_witness/src/controller/models/subtoken.dart';
import 'package:work_witness/src/controller/models/token.dart';
import 'package:work_witness/src/controller/models/employee.dart';
import './dal.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/project.dart';
import 'models/project_report.dart';
import 'models/query_result.dart';

class Controller {
  static final _subtokenPref = "subtoken";
  static final _tokenPref = "token";
  static final _emailPref = "email_pref";
  static final _localitationPref = "localitation_pref";

  static Future<Subtoken> loginEmailEmployee(String email) async {
    return Dal.loginEmailEmployee(email).then((Subtoken subtoken) {
      return SharedPreferences.getInstance().then((SharedPreferences prefs) {
        prefs.setString(Controller._subtokenPref, subtoken.key);
        return subtoken;
      });
    }).catchError((error) {
      return null;
    });
  }

  static Future<Subtoken> getSubtoken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String _subtoken = prefs.getString(Controller._subtokenPref) ?? '-';
    return Subtoken(key: _subtoken, idAccount: 0, isAccount: false, active: true);
  }

  static Future<bool> loginEmployee(Subtoken subtoken, String password) async {
    return Dal.loginEmployee(subtoken, password).then((Token token) {
      return SharedPreferences.getInstance().then((SharedPreferences prefs) {
        prefs.setString(Controller._tokenPref, token.key);
        return true;
      });
    }).catchError((error) {
      return false;
    });
  }

  static Future<Token> getToken() async {
    return await Dal.getToken();
  }

  static Future<Employee> employee(Token token) async {
    return Dal.employee(token).then((Employee employee) {
      return employee;
    }).catchError((error) {
      throw error;
    });
  }

  static Future<List<Project>> listProjects(int idEmployee) async {
    return Dal.listProjects(idEmployee).then((List<Project> projects) {
      return projects;
    }).catchError((error) {
      throw error;
    });
  }

  static Future<bool> check(SendCheck check) async {
    return Dal.check(check).then((bool result) {
      return result;
    }).catchError((error) {
      throw error;
    });
  }

  static Future<SendCheck> lastCheck(int idProject, int idEmployee) async {
    return Dal.lastCheck(idProject, idEmployee).then((SendCheck sendCheck) {
      return sendCheck;
    }).catchError((error) {
      throw error;
    });
  }

  static Future<bool> setEmail(String email) {
    return SharedPreferences.getInstance().then((SharedPreferences prefs) {
      prefs.setString(Controller._emailPref, email);
      return true;
    });
  }

  static Future<bool> publishProjectReport(ProjectReport projectReport) async {
    var controllerLocal = await ControllerLocal.create();
    projectReport.isSended = true;
    return Dal.insertProjectReport(projectReport)
        .then((QueryResult queryResult) async {
      var idProjectReport = queryResult.insertId;
      projectReport.idServer = idProjectReport;
      projectReport.projectReportQuestions =
          await controllerLocal.getProjectReportQuestions(projectReport.id);
      for (var projectReportQuestion in projectReport.projectReportQuestions) {
        projectReportQuestion.idProjectReport = idProjectReport;
        QueryResult queryResult =
            await Dal.insertProjectReportQuestion(projectReportQuestion);
        projectReportQuestion.idProjectReport = projectReport.id;
        projectReportQuestion.idServer = queryResult.insertId;
      }
      projectReport.projectReportPhotos =
          await controllerLocal.getProjectReportPhotos(projectReport.id);
      for (var projectReportPhoto in projectReport.projectReportPhotos) {
        projectReportPhoto.idProjectReport = idProjectReport;
        QueryResult queryResult =
            await Dal.insertProjectReportPhoto(projectReportPhoto);
        var idProjectReportPhoto = projectReportPhoto.id;
        projectReportPhoto.id = queryResult.insertId;
        await Dal.uploadProjectReportPhoto(projectReportPhoto);
        projectReportPhoto.id = idProjectReportPhoto;
        projectReportPhoto.idProjectReport = projectReport.id;
        projectReportPhoto.idServer = projectReportPhoto.id;
      }
      return controllerLocal.updateProjectReport(projectReport);
    }).catchError((error) {
      throw error;
    });
  }

  static Future<List<ProjectReport>> listProjectReports(
      int idProjectReport) async {
    return await Dal.listProjectReports(idProjectReport).catchError((error) {
      throw error;
    });
  }

  static Future<ProjectReport> getProjectReport(int idProjectReport) async {
    var projectReportQuestions =
        await Dal.listProjectReportsQuestions(idProjectReport);
    return Dal.getProjectReport(idProjectReport)
        .then((ProjectReport projectReport) {
      projectReport.projectReportQuestions = projectReportQuestions;
      return projectReport;
    }).catchError((error) {
      throw error;
    });
  }

  static Future<String> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _email = prefs.getString(Controller._emailPref) ?? '';
    return _email;
  }

  static Future<bool> setLocalitation(Localitation localitation) async {
    return SharedPreferences.getInstance().then((SharedPreferences prefs) {
      prefs.setString(
          Controller._localitationPref, jsonEncode(localitation.toJson()));
      return true;
    });
  }

  static Future<Localitation> getLocalitation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _localitation =
        prefs.getString(Controller._localitationPref) ?? null;
    return _localitation != null
        ? Localitation.fromJson(jsonDecode(_localitation))
        : null;
  }

  static Future<List<ProjectTypeQuestion>> projectTypeQuetions(
      int idProject) async {
    return Dal.projectTypeQuetions(idProject)
        .then((List<ProjectTypeQuestion> projectTypeQuestions) {
      return projectTypeQuestions;
    }).catchError((error) {
      throw error;
    });
  }

  static Future<List<Comment>> listComments(int idProject) async {
    return await Dal.listComments(idProject).catchError((error) {
      throw error;
    });
  }

  static Future<List<Subscription>> listSubscriptions() async {
    return await Dal.listSubscriptions().catchError((error) {
      throw error;
    });
  }

  static Future<List<SubscriptionBenefit>> listSubscriptionBenefits(int idSubscription) async {
    return await Dal.listSubscriptionBenefits(idSubscription)
        .catchError((error) {
      throw error;
    });
  }

  static Future<SubscriptionResult> insertSubscription(SubscribeInfo subscribeInfo) async {
    return await Dal.insertSubscription(subscribeInfo).catchError((error) {
      throw error;
    });
  }

  static Future<bool> insertComment(Comment comment) async {
    return await Dal.insertComment(comment).catchError((error) {
      throw error;
    });
  }

  static Future<List<ProjectProjectType>> listProjectProjectTypes(int idProject) async {
    return await Dal.listProjectProjectTypes(idProject).catchError((error) {
      throw error;
    });
  }

  static Future<QueryResult> archive(Project project) async {
    return await Dal.archive(project).catchError((error) {
      throw error;
    });
  }
}
