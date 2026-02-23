import 'package:flutter/material.dart';

/// Helper method for building a date time object with a TimeOfDay preferred and fallback values
DateTime buildDateTime(
  DateTime date,
  TimeOfDay? preferred,
  TimeOfDay fallback,
) {
  final time = preferred ?? fallback;

  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}
