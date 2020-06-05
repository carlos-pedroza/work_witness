import 'package:flutter/foundation.dart';

class SubscriptionBenefit {
  final int id;
  final int idSubscription;
  final String name;
  final int cover;
  final String role;
  final bool publish;

  SubscriptionBenefit({
    @required this.id,
    @required this.idSubscription,
    @required this.name,
    @required this.cover,
    @required this.role,
    @required this.publish,
  });

  factory SubscriptionBenefit.fromJson(dynamic json) {
    return SubscriptionBenefit(
      id: json['id'],
      idSubscription: json['idSubscription'],
      name: json['name'],
      cover: json['cover'],
      role: json['role'],
      publish: json['publish'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'idSubscription': this.idSubscription,
      'name': this.name,
      'cover': this.cover,
      'role': this.role,
      'publish': this.publish,
    };
  }
}
