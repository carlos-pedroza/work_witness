import 'package:flutter/foundation.dart';

class QueryResult {
  final int fieldCount;
  final int affectedRows;
  final int insertId;
  final int serverStatus;
  final int warningCount;
  final String message;
  final bool protocol41;
  final int changedRows;

  QueryResult({
    @required this.fieldCount,
    @required this.affectedRows,
    @required this.insertId,
    @required this.serverStatus,
    @required this.warningCount,
    @required this.message,
    @required this.protocol41,
    @required this.changedRows,
  });

  factory QueryResult.fromJson(dynamic json) {
    return QueryResult(
      fieldCount: json['fieldCount'],
      affectedRows: json['affectedRows'],
      insertId: json['insertId'],
      serverStatus: json['serverStatus'],
      warningCount: json['warningCount'],
      message: json['message'],
      protocol41: json['protocol41'],
      changedRows: json['changedRows'],
    );
  }
}
