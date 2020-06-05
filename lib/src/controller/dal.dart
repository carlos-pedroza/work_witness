import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_witness/src/controller/models/comment.dart';
import 'package:work_witness/src/controller/models/project_project_type.dart';
import 'package:work_witness/src/controller/models/project_type_question.dart';
import 'package:work_witness/src/controller/models/send_check.dart';
import 'package:work_witness/src/controller/models/subscribe_info.dart';
import 'package:work_witness/src/controller/models/subscription.dart';
import 'package:work_witness/src/controller/models/subscription_result.dart';
import './setting.dart';
import './models/subtoken.dart';
import './models/token.dart';
import './models/employee.dart';
import './models/project.dart';
import 'models/project_report.dart';
import 'models/project_report_photo.dart';
import 'models/project_report_question.dart';
import 'models/query_result.dart';
import 'models/subscription_benefit.dart';

class Dal {
  static final _tokenPref = "token";

  static Future<Token> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String _token = prefs.getString(Dal._tokenPref) ?? '-';
    return Token(key: _token);
  }

  static Future<Subtoken> loginEmailEmployee(String email) async {
    var _url = Endpoints.url(EndpointsEnum.employeeEmailLogin);
    final http.Response response = await http.post(
      _url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
      }),
    );
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return Subtoken.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('error');
    }
  }

  static Future<Token> loginEmployee(Subtoken subtoken, String password) async {
    var _url = Endpoints.url(EndpointsEnum.employeeLogin);
    final http.Response response = await http.post(
      _url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'key': subtoken.key,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return Token.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('error');
    }
  }

  static Future<Employee> employee(Token token) async {
    var _url = Endpoints.url(EndpointsEnum.employee);
    final http.Response response = await http.get(
      _url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token.key,
      },
    );
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      Employee _employee;
      try {
        _employee = Employee.fromJson(jsonDecode(response.body));
      } catch (ex) {
        throw ex;
      }
      return _employee;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('error');
    }
  }

  static Future<List<Project>> listProjects(int idEmployee) async {
    var token = await getToken();
    var _url = Endpoints.url(EndpointsEnum.projects);
    final http.Response response = await http.post(
      _url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token.key,
      },
      body: jsonEncode(<String, int>{
        'idEmployee': idEmployee,
        'archived': 0,
      }),
    );
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      List<Project> projects =
          Dal.convertList(response.body, List<Project>(), (v) {
        return Project.fromJson(v);
      });
      return projects;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('error');
    }
  }

  static Future<bool> check(SendCheck check) async {
    var token = await getToken();

    var _url = Endpoints.url(EndpointsEnum.check);
    final http.Response response = await http.post(
      _url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token.key,
      },
      body: jsonEncode(check.toJson()),
    );
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return true;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw false;
    }
  }

  static Future<List<ProjectTypeQuestion>> projectTypeQuetions(
      int idProjectType) async {
    var token = await getToken();

    var _url = Endpoints.url(EndpointsEnum.projectTypeQuestion);
    final http.Response response = await http.post(
      _url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token.key,
      },
      body: jsonEncode(<String, String>{
        'idProjectType': idProjectType.toString(),
      }),
    );
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      List<ProjectTypeQuestion> projectTypeQuestions =
          Dal.convertList(response.body, List<ProjectTypeQuestion>(), (v) {
        return ProjectTypeQuestion.fromJson(v);
      });
      return projectTypeQuestions;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('error');
    }
  }

  static Future<SendCheck> lastCheck(int idProject, int idEmployee) async {
    var token = await getToken();

    var _url = Endpoints.url(EndpointsEnum.lastCheck);
    final http.Response response = await http.post(
      _url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token.key,
      },
      body: jsonEncode(<String, String>{
        'idProject': idProject.toString(),
        'idEmployee': idEmployee.toString(),
      }),
    );
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return SendCheck.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      return null;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('error');
    }
  }

  static Future<QueryResult> insertProjectReport(
      ProjectReport projectReport) async {
    var token = await getToken();
    var _url = Endpoints.url(EndpointsEnum.projectReport);
    final http.Response response = await http.post(
      _url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token.key,
      },
      body: jsonEncode(projectReport.toJson()),
    );
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return QueryResult.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('error');
    }
  }

  static Future<QueryResult> updateProjectReport(
      ProjectReport projectReport) async {
    var token = await getToken();

    var _url = Endpoints.url(EndpointsEnum.projectReport);
    final http.Response response = await http.put(
      _url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token.key,
      },
      body: jsonEncode(projectReport.toJson()),
    );
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return QueryResult.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('error');
    }
  }

  static Future<List<ProjectReport>> listProjectReports(int idProject) async {
    var token = await getToken();
    var _url = Endpoints.url(EndpointsEnum.listProjectReport);
    final http.Response response = await http.post(
      _url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token.key,
      },
      body: jsonEncode(<String, int>{
        'idProject': idProject,
      }),
    );
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      List<ProjectReport> projectReports =
          Dal.convertList(response.body, List<ProjectReport>(), (v) {
        return ProjectReport.fromJson(v);
      });
      return projectReports;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('error');
    }
  }

  static Future<ProjectReport> getProjectReport(int idProjectReport) async {
    var token = await getToken();

    var _url = Endpoints.url(EndpointsEnum.getProjectReport);
    final http.Response response = await http.post(
      _url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token.key,
      },
      body: jsonEncode(<String, int>{
        'id': idProjectReport,
      }),
    );
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return ProjectReport.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('error');
    }
  }

  static Future<QueryResult> insertProjectReportQuestion(
      ProjectReportQuestion projectReportQuestion) async {
    var token = await getToken();

    var _url = Endpoints.url(EndpointsEnum.projectReportQuestion);
    final http.Response response = await http.post(
      _url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token.key,
      },
      body: jsonEncode(projectReportQuestion.toJson()),
    );
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return QueryResult.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('error');
    }
  }

  static Future<QueryResult> updateProjectReportQuestion(
      ProjectReportQuestion projectReportQuestion) async {
    var token = await getToken();

    var _url = Endpoints.url(EndpointsEnum.projectReportQuestion);
    final http.Response response = await http.put(
      _url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token.key,
      },
      body: jsonEncode(projectReportQuestion.toJson()),
    );
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return QueryResult.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('error');
    }
  }

  static Future<List<ProjectReportQuestion>> listProjectReportsQuestions(
      int idProjectReport) async {
    var token = await getToken();

    var _url = Endpoints.url(EndpointsEnum.listProjectReportQuestion);
    final http.Response response = await http.post(
      _url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token.key,
      },
      body: jsonEncode(<String, int>{
        'idProjectReport': idProjectReport,
      }),
    );
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      List<ProjectReportQuestion> projectReportsQuestion =
          Dal.convertList(response.body, List<ProjectReportQuestion>(), (v) {
        return ProjectReportQuestion.fromJson(v);
      });
      return projectReportsQuestion;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('error');
    }
  }

  static Future<ProjectReportQuestion> getProjectReportsQuestion(
      int idProjectReport) async {
    var token = await getToken();

    var _url = Endpoints.url(EndpointsEnum.getProjectReportQuestion);
    final http.Response response = await http.post(
      _url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token.key,
      },
      body: jsonEncode(<String, int>{
        'idProjectReport': idProjectReport,
      }),
    );
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return ProjectReportQuestion.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('error');
    }
  }

  static Future<QueryResult> insertProjectReportPhoto(
      ProjectReportPhoto projectReportPhoto) async {
    var token = await getToken();

    var _url = Endpoints.url(EndpointsEnum.projectReportPhoto);
    final http.Response response = await http.post(
      _url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token.key,
      },
      body: jsonEncode(projectReportPhoto.toJson()),
    );
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return QueryResult.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('error');
    }
  }

  static Future<QueryResult> updateProjectReportPhoto(
      ProjectReportPhoto projectReportPhoto) async {
    var token = await getToken();

    var _url = Endpoints.url(EndpointsEnum.projectReportPhoto);
    final http.Response response = await http.put(
      _url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token.key,
      },
      body: jsonEncode(projectReportPhoto.toJson()),
    );
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return QueryResult.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('error');
    }
  }

  static Future<List<ProjectReportPhoto>> listProjectReportsPhotos(
      int idProjectReport) async {
    var token = await getToken();

    var _url = Endpoints.url(EndpointsEnum.listProjectReportPhoto);
    final http.Response response = await http.post(
      _url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token.key,
      },
      body: jsonEncode(<String, int>{
        'idProjectReport': idProjectReport,
      }),
    );
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      List<ProjectReportPhoto> projectReportsPhoto =
          Dal.convertList(response.body, List<ProjectReportPhoto>(), (v) {
        return ProjectReportPhoto.fromJson(v);
      });
      return projectReportsPhoto;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('error');
    }
  }

  static Future<ProjectReportPhoto> getProjectReportsPhoto(
      int idProjectReport) async {
    var token = await getToken();

    var _url = Endpoints.url(EndpointsEnum.getProjectReportPhoto);
    final http.Response response = await http.post(
      _url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token.key,
      },
      body: jsonEncode(<String, int>{
        'idProjectReport': idProjectReport,
      }),
    );
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return ProjectReportPhoto.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('error');
    }
  }

  static Future<http.StreamedResponse> uploadProjectReportPhoto(
      ProjectReportPhoto projectReportPhoto) async {
    var _url = Endpoints.url(EndpointsEnum.uploadProjectReportPhoto) +
        '/' +
        projectReportPhoto.id.toString();
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(_url),
    );
    request.files.add(http.MultipartFile.fromBytes(
        'file', File(projectReportPhoto.photo).readAsBytesSync(),
        filename: projectReportPhoto.photo.split("/").last));
    var response = await request.send();
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return response;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('error');
    }
  }

  static Future<bool> insertComment(Comment comment) async {
    var token = await getToken();

    var _url = Endpoints.url(EndpointsEnum.comment);
    final http.Response response = await http.post(
      _url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token.key,
      },
      body: jsonEncode(comment.toJson()),
    );
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return true;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw false;
    }
  }

  static Future<List<Comment>> listComments(int idProject) async {
    var token = await getToken();

    var _url = Endpoints.url(EndpointsEnum.listComments);
    final http.Response response = await http.post(
      _url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token.key,
      },
      body: jsonEncode(<String, int>{
        'idProject': idProject,
      }),
    );
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      List<Comment> comments =
          Dal.convertList(response.body, List<Comment>(), (v) {
        return Comment.fromJson(v);
      });
      return comments;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('error');
    }
  }

  static Future<List<Subscription>> listSubscriptions() async {
    var _url = Endpoints.url(EndpointsEnum.listSubscription);
    final http.Response response = await http.post(
      _url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      List<Subscription> subscriptions =
          Dal.convertList(response.body, List<Subscription>(), (v) {
        return Subscription.fromJson(v);
      });
      return subscriptions;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('error');
    }
  }

  static Future<List<SubscriptionBenefit>> listSubscriptionBenefits(
      int idSubscription) async {
    var _url = Endpoints.url(EndpointsEnum.listSubscriptionBenefits);
    final http.Response response = await http.post(
      _url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, int>{
        'idSubscription': idSubscription,
      }),
    );
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      List<SubscriptionBenefit> subscriptionBenefits =
          Dal.convertList(response.body, List<SubscriptionBenefit>(), (v) {
        return SubscriptionBenefit.fromJson(v);
      });
      return subscriptionBenefits;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('error');
    }
  }

  static Future<SubscriptionResult> insertSubscription(
      SubscribeInfo subscribeInfo) async {
    var token = await getToken();

    var _url = Endpoints.url(EndpointsEnum.subscribeAccount);
    final http.Response response = await http.post(
      _url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token.key,
      },
      body: jsonEncode(subscribeInfo.toJson()),
    );
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return SubscriptionResult.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('error');
    }
  }

  static Future<List<ProjectProjectType>> listProjectProjectTypes(
      int idProject) async {
    var token = await getToken();

    var _url = Endpoints.url(EndpointsEnum.projectProjectTypes);
    final http.Response response = await http.post(
      _url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token.key,
      },
      body: jsonEncode(<String, int>{
        'idProject': idProject,
      }),
    );
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      List<ProjectProjectType> projectProjectTypes =
          Dal.convertList(response.body, List<ProjectProjectType>(), (v) {
        return ProjectProjectType.fromJson(v);
      });
      return projectProjectTypes;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('error');
    }
  }

   static Future<QueryResult> archive(
      Project project) async {
    var token = await getToken();

    var _url = Endpoints.url(EndpointsEnum.project);
    final http.Response response = await http.put(
      _url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token.key,
      },
      body: jsonEncode(project.toJson()),
    );
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return QueryResult.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('error');
    }
  }

  static List<dynamic> convertList(
      dynamic body, List<dynamic> itemsDestiny, Function fromJson) {
    List<dynamic> _items = jsonDecode(body);
    for (var p in _items) {
      dynamic _item;
      try {
        _item = fromJson(p);
      } catch (ex) {
        throw ex;
      }
      itemsDestiny.add(_item);
    }

    return itemsDestiny;
  }
}
