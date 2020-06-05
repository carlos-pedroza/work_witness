import 'package:flutter/foundation.dart';
import 'package:work_witness/src/controller/models/subscription_benefit.dart';

class Subscription {
  final int id;
  final String name;
  final String description;
  final int coverDays;
  final double pricePerMonth;
  final String offer;
  final bool annual;
  final bool disabled;

  Subscription({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.coverDays,
    @required this.pricePerMonth,
    @required this.offer,
    @required this.annual,
    @required this.disabled,
  });
 
  factory Subscription.fromJson(dynamic json) {
    return Subscription(
      id: json['id'],
      name: json['name'],
      description: json["description"],
      coverDays: json['coverDays'] as int,
      pricePerMonth: (json['pricePerMonth'] as int).toDouble(),
      offer: json['offer'],
      annual: json['annual'] == 1,
      disabled: json['disabled'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'name': this.name,
      'description': this.description,
      'coverDays': this.coverDays,
      'pricePerMonth': this.pricePerMonth,
      'offer': this.offer,
      'annual': this.annual,
      'disabled': this.disabled,
    };
  }
}
