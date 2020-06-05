import 'package:flutter/foundation.dart';

class Employee {
  final int id;
  final int idCompany;
  final String company;
  final String code;
  final String name;
  final String position;
  final String phone;
  final String email;
  final bool isAccount;
  final bool disabled;

  const Employee({
    @required this.id,
    @required this.idCompany,
    @required this.company,
    @required this.code,
    @required this.name,
    @required this.position,
    @required this.phone,
    @required this.email,
    @required this.isAccount,
    @required this.disabled,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      idCompany: json['idCompany'],
      company: json['company'],
      code: json['code'],
      name: json['name'],
      position: json['position'],
      phone: json['phone'],
      email: json['email'],
      isAccount: json['isAccount'] == 1,
      disabled: json['disabled'] == 1,
    );
  }
}
