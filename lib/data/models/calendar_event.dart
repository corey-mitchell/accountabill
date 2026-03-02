import 'package:uuid/uuid.dart';

/// Calendar event data layer
class CalendarEvent {
  static const Uuid _uuid = Uuid();

  final String id;
  final DateTime start;
  final DateTime end;
  final String title;
  final String? description;
  final bool? hasReminderSet;

  CalendarEvent({
    String? id,
    required this.start,
    required this.end,
    required this.title,
    this.description,
    this.hasReminderSet,
  }) : id = id ?? _uuid.v4();

  Duration get duration => end.difference(start);

  /// This will be used for converting incoming dynamic JSON data into the preferred CalendarEvent type
  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    return CalendarEvent(
      id: json['id'],
      start: DateTime.parse(json['start']),
      end: DateTime.parse(json['end']),
      title: json['title'],
      description: json['description'],
      hasReminderSet: json['hasReminderSet'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'start': start.toIso8601String(),
      'end': end.toIso8601String(),
      'description': description,
      'hasReminderSet': hasReminderSet,
    };
  }
}
