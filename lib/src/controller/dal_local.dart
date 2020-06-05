import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:work_witness/src/controller/models/project_report_photo.dart';
import 'package:work_witness/src/controller/models/project_report_question.dart';

import 'models/project_report.dart';

class DalLocal {
  Database database;

  DalLocal({@required this.database});

  static Future<DalLocal> create() async {
    return DalLocal(database: await DalLocal.getDatabase());
  }

  static Future<Database> getDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'ww_database.database'),
      onCreate: (database, version) async {
        // Ejecuta la sentencia CREATE TABLE en la base de datos
        await database.execute(
          'CREATE TABLE project_report_question (id INTEGER PRIMARY KEY, id_project_report INTEGER NOT NULL, id_project_type_question INTEGER NOT NULL, question TEXT NOT NULL, value TEXT NOT NULL, id_server INTEGER NULL)'
        );
        await database.execute(
          'CREATE TABLE project_report_photo (id INTEGER PRIMARY KEY, id_project_report INTEGER NOT NULL, latitude REAL NOT NULL, longitude REAL NOT NULL, photo TEXT NOT NULL, id_server INTEGER NULL)'
        );
        return database.execute(
          "CREATE TABLE project_report (id INTEGER PRIMARY KEY, id_project INTEGER NOT NULL, id_employee INTEGER NOT NULL, id_projecttype INTEGER NOT NULL, record_date INTEGER NOT NULL, location TEXT NULL, description TEXT NOT NULL, hours INTEGER NOT NULL, minutes INTEGER NOT NULL, create_date TEXT NOT NULL, modify_date TEXT NOT NULL, is_sended INTEGER NOT NULL, closed INTEGER NOT NULL, disabled INTEGER NOT NULL, id_server INTEGER NULL)"
        );
      },
      version: 2,
    );
    //v1 "CREATE TABLE project_report (id INTEGER PRIMARY KEY, id_project INTEGER NOT NULL, id_employee INTEGER NOT NULL, record_date INTEGER NOT NULL, location TEXT NULL, description TEXT NOT NULL, hours INTEGER NOT NULL, create_date TEXT NOT NULL, modify_date TEXT NOT NULL, is_sended INTEGER NOT NULL, closed INTEGER NOT NULL, disabled INTEGER NOT NULL, id_server INTEGER NULL)"
  }

  Future<bool> insertProjectReport(ProjectReport projectReport) async {
    try {
      int idProjectReport = await database.insert(
        'project_report',
        projectReport.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      projectReport.id = idProjectReport;
      for (var projectReportQuestion in projectReport.projectReportQuestions) {
        projectReportQuestion.idProjectReport = idProjectReport;
        int id = await database.insert(
          'project_report_question',
          projectReportQuestion.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        projectReportQuestion.id = id;
      }
      for (var projectReportPhoto in projectReport.projectReportPhotos) {
        if (!projectReportPhoto.disabled) {
          projectReportPhoto.idProjectReport = idProjectReport;
          int id = await database.insert(
            'project_report_photo',
            projectReportPhoto.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
          projectReportPhoto.id = id;
        }
      }
      return true;
    } catch (ex) {
      return false;
    }
  }

  Future<List<ProjectReport>> getProjectReports(
      int idProject, int idEmployee) async {
    final List<Map<String, dynamic>> maps = await database.query(
        'project_report',
        where: 'id_project = ? and id_employee = ?',
        whereArgs: [idProject, idEmployee],
        orderBy: 'record_date DESC');

    // Convierte List<Map<String, dynamic> en List<Dog>.
    return List.generate(maps.length, (i) {
      return ProjectReport.fromMap(maps[i]);
    });
  }

  Future<List<ProjectReportQuestion>> getProjectReportQuestions(
      int idProjectReport) async {
    final List<Map<String, dynamic>> maps = await database.query(
        'project_report_question',
        where: 'id_project_report = ?',
        whereArgs: [idProjectReport]);

    // Convierte List<Map<String, dynamic> en List<Dog>.
    return List.generate(maps.length, (i) {
      return ProjectReportQuestion.fromMap(maps[i]);
    });
  }

  Future<List<ProjectReportPhoto>> getProjectReportPhotos(
      int idProjectReport) async {
    final List<Map<String, dynamic>> maps = await database.query(
        'project_report_photo',
        where: 'id_project_report = ?',
        whereArgs: [idProjectReport]);

    // Convierte List<Map<String, dynamic> en List<Dog>.
    return List.generate(maps.length, (i) {
      return ProjectReportPhoto.fromMap(maps[i]);
    });
  }

  Future<bool> updateProjectReport(ProjectReport projectReport) async {
    // Actualiza el Dog dado
    await database.update(
      'project_report',
      projectReport.toMap(),
      // Aseguúrate de que solo actualizarás el Dog con el id coincidente
      where: "id = ?",
      // Pasa el id Dog a través de whereArg para prevenir SQL injection
      whereArgs: [projectReport.id],
    );

    for (var projectReportQuestion in projectReport.projectReportQuestions) {
      await database.update(
        'project_report_question',
        projectReportQuestion.toMap(),
        // Aseguúrate de que solo actualizarás el Dog con el id coincidente
        where: "id = ?",
        // Pasa el id Dog a través de whereArg para prevenir SQL injection
        whereArgs: [projectReportQuestion.id],
      );
    }

    for (var projectReportPhoto in projectReport.projectReportPhotos) {
      if (projectReportPhoto.id == null && !projectReportPhoto.disabled) {
        projectReportPhoto.idProjectReport = projectReport.id;
        await database.insert(
          'project_report_photo',
          projectReportPhoto.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      } else if (projectReportPhoto.id != null && projectReportPhoto.disabled) {
        await database.delete(
          'project_report_photo',
          // Utiliza la cláusula `where` para eliminar un dog específico
          where: "id = ?",
          // Pasa el id Dog a través de whereArg para prevenir SQL injection
          whereArgs: [projectReportPhoto.id],
        );
      }
    }

    return true;
  }

  Future<bool> deleteProjectReport(ProjectReport projectReport) async {
    await database.delete(
      'project_report',
      where: "id = ?",
      whereArgs: [projectReport.id],
    );

    await database.delete(
      'project_report_question',
      where: "id_project_report = ?",
      whereArgs: [projectReport.id],
    );

    await database.delete(
      'project_report_photo',
      where: "id_project_report = ?",
      whereArgs: [projectReport.id],
    );

    return true;
  }
}
