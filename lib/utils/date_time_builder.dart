import 'package:flutter/material.dart';

const months = [
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "Jul",
  "Aug",
  "Sep",
  "Oct",
  "Nov",
  "Dec",
];

/// Helper method for converting TimeOfDay to DateTime
DateTime timeOfDayToDateTime(DateTime date, TimeOfDay time) {
  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}

/// Helper method for formatting hours to AM/PM variant
String formatHour(TimeOfDay time) {
  final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
  final min = time.minute == 0
      ? ''
      : ':${time.minute.toString().padLeft(2, '0')}';
  final period = time.period == DayPeriod.am ? "AM" : "PM";
  return "$hour$min $period";
}

/// Helper method for changing formatted hours (e.g. 12PM) to TimeOfDay object
TimeOfDay parseTimeOfDay(String input) {
  final cleaned = input.trim().toUpperCase();

  final regex = RegExp(r'^(\d{1,2})(?::(\d{2}))?\s?(AM|PM)$');
  final match = regex.firstMatch(cleaned);

  if (match == null) {
    throw FormatException('Invalid time format');
  }

  int hour = int.parse(match.group(1)!);
  int minute = int.parse(match.group(2) ?? '0');
  final period = match.group(3);

  if (period == 'PM' && hour != 12) {
    hour += 12;
  }
  if (period == 'AM' && hour == 12) {
    hour = 0;
  }

  return TimeOfDay(hour: hour, minute: minute);
}

/// Helper function for formatting a DateTime object to MMM. dd, yyyy string
String formatDate(DateTime date) {
  final month = months[date.month - 1];
  final day = date.day.toString().padLeft(2, '0');
  final year = date.year;

  return "$month. $day, $year";
}
