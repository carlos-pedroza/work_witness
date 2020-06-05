import 'package:flutter/foundation.dart';

class ProjectTypeQuestion {
  final int id;
  final int idProjectType;
  final String question;
  final bool disabled;

  ProjectTypeQuestion({
    @required this.id,
    @required this.idProjectType,
    @required this.question,
    @required this.disabled,
  });

  factory ProjectTypeQuestion.fromJson(dynamic json) {
    return ProjectTypeQuestion(
      id: json['id'],
      idProjectType: json['idProjectType'],
      question: json['question'],
      disabled: json['disabled'] == 1,
    );
  }
}
