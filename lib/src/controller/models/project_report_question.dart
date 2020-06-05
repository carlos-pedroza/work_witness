import 'package:flutter/foundation.dart';

class ProjectReportQuestion {
  int id;
  int idProjectReport;
  final int idProjectTypeQuestion;
  final String question;
  String value;
  int idServer;

  ProjectReportQuestion({
    @required this.id,
    @required this.idProjectReport,
    @required this.idProjectTypeQuestion,
    @required this.question,
    @required this.value,
    this.idServer,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "id_project_report": idProjectReport,
      "id_project_type_question": idProjectTypeQuestion,
      "question": question,
      "value": value,
      "id_server": idServer != null ? idServer : 0,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      "id": null,
      "idProjectReport": idProjectReport,
      "idProjectTypeQuestion": idProjectTypeQuestion,
      "question": question,
      "value": value,
    };
  }

  factory ProjectReportQuestion.fromMap(dynamic map) {
    return ProjectReportQuestion(
      id: map["id"],
      idProjectReport: map["id_project_report"],
      idProjectTypeQuestion: map["id_project_type_question"],
      question: map["question"],
      value: map["value"],
      idServer: map['id_server'],
    );
  }

  factory ProjectReportQuestion.fromJson(dynamic map) {
    return ProjectReportQuestion(
      id: map["id"],
      idProjectReport: map["idProjectReport"],
      idProjectTypeQuestion: map["idProjectTypeQuestion"],
      question: map["question"],
      value: map["value"],
    );
  }
}
