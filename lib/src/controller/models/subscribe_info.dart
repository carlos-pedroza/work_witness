import 'package:flutter/foundation.dart';

class SubscribeInfo {
  String name;
  String company;
  String email;
  String password;
  int idSubscription;
  int days;

  SubscribeInfo({
    @required this.name,
    @required this.company,
    @required this.email,
    @required this.password,
    @required this.idSubscription,
    @required this.days,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': this.name,
      'company': this.company,
      'email': this.email,
      'password': this.password,
      'idSubscription': this.idSubscription,
      'days': this.days
    };
  }
}
