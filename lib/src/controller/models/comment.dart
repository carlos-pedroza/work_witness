import 'package:flutter/foundation.dart';

class Comment {
  final int id;
  final int idProject;
  final int idEmployee;
  final String employee;
  final String commentValue;
  final DateTime created;
  final bool disabled;

  Comment({
    @required this.id,
    @required this.idProject,
    @required this.idEmployee,
    @required this.employee,
    @required this.commentValue,
    @required this.created,
    @required this.disabled,
  });

  Map<String, String> toJson() {
    return {
      "id": id.toString(),
      "idProject": idProject.toString(),
      "idEmployee": idEmployee.toString(),
      "commentValue": commentValue,
      "created": created.toString(),
      "disabled": disabled ? '1' : '0',
    };
  }

  factory Comment.fromJson(dynamic json) {
    return Comment(
      id: json['id'],
      idProject: json['idProject'],
      idEmployee: json['idEmployee'],
      employee: json['employee'],
      commentValue: json['commentValue'],
      created: DateTime.parse(json['created']),
      disabled: json['disabled'] == 1,
    );
  }
}
