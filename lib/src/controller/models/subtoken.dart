import 'package:flutter/foundation.dart';

class Subtoken {
  final String key;
  final int idAccount;
  final bool isAccount;
  final bool active;

  const Subtoken({
    @required this.key,
    @required this.idAccount,
    @required this.isAccount,
    @required this.active,
  });

  factory Subtoken.fromJson(Map<String, dynamic> json) {
    return Subtoken(
      key: json['key'],
      idAccount: json['idAccount'],
      isAccount: json['isAccount'] == 1,
      active: json['active'] == 1,
    );
  }
}
