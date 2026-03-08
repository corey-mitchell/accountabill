import 'dart:convert';
import 'dart:io';
import 'package:accountabill/data/models/calendar_event.dart';
import 'package:path_provider/path_provider.dart';

/// Data object for events
///
/// Keeps track of user events, loads events into data object on page
/// initialization and handles creating, updating and deleting events
class EventRepository {
  static const String fileName = 'events-database.json';
  Map<String, CalendarEvent> _events = {};

  /// Method for handling initial event loading
  ///
  /// @returns Map<String, CalendarEvent>
  Future<Map<String, CalendarEvent>> loadEvents() async {
    final documents = await getApplicationDocumentsDirectory();
    final file = File('${documents.path}/$fileName');

    /// If file doesn't exist, copy from assets
    /// (Relic from previous implementation, left in for reference.)
    // if (!await file.exists()) {
    //   final assetData = await rootBundle.loadString('assets/database.json');
    //   await file.writeAsString(assetData);
    // }

    final jsonString = await file.readAsString();
    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    _events = jsonMap.map(
      (key, value) => MapEntry(key, CalendarEvent.fromJson(value)),
    );

    return _events;
  }

  /// Method for creating a new event
  ///
  /// @returns CalendarEvent for success, null for failure
  Future<CalendarEvent?> createEvent(CalendarEvent eventInput) async {
    final start = eventInput.start;
    final end = eventInput.end;
    final newEvent = CalendarEvent(
      start: start,
      end: end,
      title: eventInput.title,
      description: eventInput.description,
      hasReminderSet: eventInput.hasReminderSet,
    );

    Directory documents = await getApplicationDocumentsDirectory();
    try {
      File file = File('${documents.path}/$fileName');
      Map<String, CalendarEvent> jsonMap = {..._events, newEvent.id: newEvent};
      final Map<String, dynamic> encodableMap = {
        for (final entry in jsonMap.entries) entry.key: entry.value.toJson(),
      };
      String jsonString = json.encode(encodableMap);
      await file.writeAsString(jsonString);
      _events = jsonMap;
      return newEvent;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  /// Method for updating existing event
  ///
  /// @returns CalendarEvent for success, null for failure
  Future<CalendarEvent?> updateEvent(CalendarEvent eventInput) async {
    // Update event in storage
    Directory documents = await getApplicationDocumentsDirectory();
    try {
      File file = File('${documents.path}/$fileName');
      Map<String, CalendarEvent> updatedEvents = {
        ..._events,
        eventInput.id: eventInput,
      };
      final Map<String, dynamic> encodableMap = {
        for (final entry in updatedEvents.entries)
          entry.key: entry.value.toJson(),
      };
      String jsonString = json.encode(encodableMap);
      await file.writeAsString(jsonString);
      _events = updatedEvents;
      return eventInput;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  /// Method for deleting existing event
  ///
  /// @returns true for successful deletion and false for failed case
  Future<bool> deleteEvent(CalendarEvent event) async {
    Directory documents = await getApplicationDocumentsDirectory();
    try {
      File file = File('${documents.path}/$fileName');
      Map<String, CalendarEvent> jsonMap = _events;
      jsonMap.remove(event.id);
      String jsonString = json.encode(jsonMap);
      await file.writeAsString(jsonString);
      _events = jsonMap;
      return true;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}
