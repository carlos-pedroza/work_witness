import 'package:flutter/foundation.dart';

enum CheckTypeEnum {
  CheckIn,
  CheckOut,
  BreakTimeStart,
  BreakTimeEnd,
}

class CheckType {
  static int key(CheckTypeEnum item) {
    switch (item) {
      case CheckTypeEnum.CheckIn:
        return 1;
      case CheckTypeEnum.CheckOut:
        return 2;
      case CheckTypeEnum.BreakTimeStart:
        return 3;
      case CheckTypeEnum.BreakTimeEnd:
        return 4;
      default:
        return null;
    }
  }

  static String value(CheckTypeEnum item) {
    switch (item) {
      case CheckTypeEnum.CheckIn:
        return 'Check In';
      case CheckTypeEnum.CheckOut:
        return 'Check Out';
      case CheckTypeEnum.BreakTimeStart:
        return 'Break Time Start';
      case CheckTypeEnum.BreakTimeEnd:
        return 'Break Time End';
      default:
        return null;
    }
  }
}
