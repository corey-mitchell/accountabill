import 'package:accountabill/models/calendar_event.dart';
import 'package:accountabill/widgets/custom_time_picker.dart';
import 'package:accountabill/pages/handle_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

/// User events page
///
/// 🚧 Currently under construction 🚧
///
/// This is where the user will be able to see and
/// edit their events on a calendar component
class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  static DateTime date = DateTime.now();
  final Map<String, CalendarEvent> _events = {};

  /// Handle event creation
  void _createEvent(DateTime time) async {
    final eventInput = await Navigator.push<CalendarEvent>(
      context,
      MaterialPageRoute(builder: (_) => HandleEventPage(initialTime: time)),
    );

    // Validate user input
    if (eventInput == null || eventInput.title.isEmpty) return;
    final start = eventInput.start;
    final end = eventInput.end;

    setState(() {
      final newEvent = CalendarEvent(
        start: start,
        end: end,
        title: eventInput.title,
      );
      _events[newEvent.id] = newEvent;
    });

    // Announce to screen readers that event was successfully created
    SemanticsService.sendAnnouncement(
      View.of(context),
      "Event created at ${TimeOfDay.fromDateTime(time).format(context)}",
      TextDirection.ltr,
    );
  }

  /// Handle event update
  void _updateEvent(CalendarEvent event) async {
    final eventInput = await Navigator.push<CalendarEvent>(
      context,
      MaterialPageRoute(
        builder: (_) => HandleEventPage(
          initialTime: event.start,
          existingEvent: event,
          deleteEvent: _deleteEvent,
        ),
      ),
    );

    // Validate user input
    if (eventInput == null || eventInput.title.isEmpty) return;
    final start = eventInput.start;
    final end = eventInput.end;

    setState(() {
      _events[event.id] = CalendarEvent(
        start: start,
        end: end,
        title: eventInput.title,
        description: eventInput.description,
        hasReminderSet: eventInput.hasReminderSet,
      );
    });

    // Announce to screen readers that event was successfully updated
    SemanticsService.sendAnnouncement(
      View.of(context),
      "Event successfully updated",
      TextDirection.ltr,
    );
  }

  /// Handle event deletion
  void _deleteEvent(CalendarEvent event) {
    setState(() {
      _events.remove(event.id);
    });

    // Announce to screen readers that event was successfully deleted
    SemanticsService.sendAnnouncement(
      View.of(context),
      "Event successfully deleted",
      TextDirection.ltr,
    );
  }

  /// Page scaffold
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBar(context), body: _buildUI(context));
  }

  /// Page app bar widget
  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text("Events"),
      centerTitle: true,
    );
  }

  /// Page UI main widget
  Widget _buildUI(BuildContext context) {
    return CustomTimePicker(
      date: date,
      events: _events,
      createEvent: _createEvent,
      updateEvent: _updateEvent,
    );
  }
}
