import 'package:flutter/foundation.dart';

class Localitation {
  double latitude;
  double longitude;
  DateTime register;
  int _expiredMinutes = 10;

  Localitation({
    @required this.latitude,
    @required this.longitude,
    @required this.register,
  });

  Map toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'register': register.toString(),
      };

  void setLocalitationString(String _latitude, String _longitude) {
    setLocalitation(double.parse(_latitude), double.parse(_longitude));
  }

  void setLocalitation(double _latitude, double _longitude) {
    latitude = _latitude;
    longitude = _longitude;
    register = DateTime.now();
  }

  void copy(Localitation _localitation) {
    latitude = _localitation.latitude;
    longitude = _localitation.longitude;
    register = _localitation.register;
  }

  String toString() =>
      '{ latitude:${latitude}, logitude:${longitude}, register:"${register}" }';

  factory Localitation.fromJson(dynamic json) {
    return Localitation(
      latitude: json['latitude'],
      longitude: json['longitude'],
      register: DateTime.parse(json['register']),
    );
  }

  bool expired() {
    if (register != null) {
      DateTime _now = DateTime.now();
      DateTime _register =
          register.subtract(Duration(minutes: _expiredMinutes));

      return _register.isAfter(_now);
    } else {
      return false;
    }
  }
}
