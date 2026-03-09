import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

/// Data model for calendar events
///
/// Uses the uuid package for creating unique identifiers for each object.
/// These will be created automagically, but an ID can be supplied manually
/// during creation. The IDs will be used for performing update and delete
/// operations on specific events.
class CalendarEvent {
  static const Uuid _uuid = Uuid();

  final String id; // Event id
  final String userId; // User id
  final DateTime start;
  final DateTime end;
  final String title;
  final String? description;
  final bool? hasReminderSet;

  CalendarEvent({
    String? id,
    required this.userId,
    required this.start,
    required this.end,
    required this.title,
    this.description,
    this.hasReminderSet,
  }) : id = id ?? _uuid.v4();

  Duration get duration => end.difference(start);

  /// This will be used for converting incoming dynamic JSON data into the preferred CalendarEvent type on data load
  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    return CalendarEvent(
      id: json['id'],
      userId: json['userId'],
      start: (json['start'] as Timestamp).toDate(),
      end: (json['end'] as Timestamp).toDate(),
      title: json['title'],
      description: json['description'],
      hasReminderSet: json['hasReminderSet'],
    );
  }

  /// This will be used for converting CalendarEvents into the preferred JSON data for outgoing events (creating and updating operations)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'start': start.toIso8601String(),
      'end': end.toIso8601String(),
      'description': description,
      'hasReminderSet': hasReminderSet,
    };
  }
}
