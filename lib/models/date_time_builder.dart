import 'package:flutter/material.dart';

/// Helper method for building a date time object with a TimeOfDay preferred and fallback values
DateTime buildDateTime(DateTime date, DateTime? preferred, DateTime fallback) {
  final time = preferred ?? fallback;

  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}

/// Helper method for converting TimeOfDay to DateTime
DateTime timeOfDayToDateTime(DateTime date, TimeOfDay time) {
  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}
