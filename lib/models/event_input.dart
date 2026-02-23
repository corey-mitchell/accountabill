import 'package:flutter/material.dart';

/// Event input data layer for handling the add event modal data
class EventInput {
  final String title;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  EventInput({
    required this.title,
    required this.startTime,
    required this.endTime,
  });
}
