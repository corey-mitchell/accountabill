import 'package:accountabill/data/models/calendar_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Data object for events
///
/// Keeps track of user events, loads events into data object on page
/// initialization and handles creating, updating and deleting events
class EventRepository {
  Map<String, CalendarEvent> _events = {};

  /// Method for handling initial event loading
  ///
  /// @returns Map<String, CalendarEvent>
  Future<Map<String, CalendarEvent>> loadEvents(String userId) async {
    try {
      final eventsCollection = FirebaseFirestore.instance.collection('events');
      QuerySnapshot snapshot = await eventsCollection
          .where('userId', isEqualTo: userId)
          .get();

      // Loop through the documents and convert them to CalendarEvent objects
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        _events[doc.id] = CalendarEvent.fromJson({...data, 'id': doc.id});
      }
    } catch (e) {
      print(e);
    }

    return _events;
  }

  /// Method for creating a new event
  ///
  /// @returns CalendarEvent for success, null for failure
  Future<CalendarEvent?> createEvent(
    String userId,
    CalendarEvent eventInput,
  ) async {
    try {
      final start = eventInput.start;
      final end = eventInput.end;

      // Add to Firebase collection
      final eventsCollection = FirebaseFirestore.instance.collection('events');
      DocumentReference eventDocRef = await eventsCollection.add({
        'userId': userId, // Tie event to user
        'start': start,
        'end': end,
        'title': eventInput.title,
        'description': eventInput.description,
        'hasReminderSet': eventInput.hasReminderSet,
      });

      final newEvent = CalendarEvent(
        id: eventDocRef.id,
        userId: userId,
        start: start,
        end: end,
        title: eventInput.title,
        description: eventInput.description,
        hasReminderSet: eventInput.hasReminderSet,
      );

      // Add to local events
      Map<String, CalendarEvent> jsonMap = {
        ..._events,
        eventDocRef.id: newEvent,
      };
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
    try {
      final eventsCollection = FirebaseFirestore.instance.collection('events');
      DocumentReference eventDocRef = eventsCollection.doc(
        eventInput.id,
      ); // Target specific event
      await eventDocRef.update({
        'start': Timestamp.fromDate(eventInput.start),
        'end': Timestamp.fromDate(eventInput.end),
        'title': eventInput.title,
        'description': eventInput.description,
        'hasReminderSet': eventInput.hasReminderSet,
      });

      Map<String, CalendarEvent> updatedEvents = {
        ..._events,
        eventInput.id: eventInput,
      };
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
    try {
      final eventsCollection = FirebaseFirestore.instance.collection('events');

      // Get a reference to the event document using the Firestore document ID
      DocumentReference eventDocRef = eventsCollection.doc(event.id);

      // Delete the event document from Firestore
      await eventDocRef.delete();

      Map<String, CalendarEvent> jsonMap = _events;
      jsonMap.remove(event.id);
      _events = jsonMap;

      return true;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}
