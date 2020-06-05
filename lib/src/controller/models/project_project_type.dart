import 'package:flutter/foundation.dart';

class ProjectProjectType {
  final int id;
  final int idProject;
  final int idProjectType;
  final String name;

  ProjectProjectType({
    @required this.id,
    @required this.idProject,
    @required this.idProjectType,
    @required this.name,
  });

  factory ProjectProjectType.fromJson(dynamic json) {
    return ProjectProjectType(
      id: json['id'],
      idProject: json['idProject'],
      idProjectType: json['idProjectType'],
      name: json['name'],
    );
  }
}
