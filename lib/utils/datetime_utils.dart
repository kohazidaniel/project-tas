import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  static String getFormattedDate(DateTime dateTime) {
    DateFormat formatter = new DateFormat.yMMMMd('hu');

    return formatter.format(dateTime) +
        ' ${dateTime.hour}:' +
        '${dateTime.minute.toString().length == 1 ? '0' : ''}' +
        '${dateTime.minute}';
  }

  static int calculateDifferenceInDays(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }
}
