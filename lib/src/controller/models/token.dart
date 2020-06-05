import 'package:flutter/foundation.dart';

class Token {
  final String key;

  const Token({@required this.key});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      key: json['key'],
    );
  }
}
