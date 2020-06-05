import 'package:flutter/foundation.dart';

class SubscriptionResult {
  final bool success;
  final bool exists;

  SubscriptionResult({@required this.success, @required this.exists});

  factory SubscriptionResult.fromJson(dynamic json) {
    return SubscriptionResult(
      exists: json['exists'] == 1,
      success: json['success'] == 1,
    );
  }
}
