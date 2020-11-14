import 'package:flutter/material.dart';

class DateTimeUtils {
  static TimeOfDay parseToTimeOfDay(String s) {
    return TimeOfDay(
      hour: int.parse(s.split(":")[0]),
      minute: int.parse(s.split(":")[1]),
    );
  }

  static int getTimeOfDayInMinutes(TimeOfDay timeOfDay) {
    return timeOfDay.hour * 60 + timeOfDay.minute;
  }
}
