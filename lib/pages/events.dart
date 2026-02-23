import 'package:accountabill/models/calendar_event.dart';
import 'package:accountabill/models/date_time_builder.dart';
import 'package:accountabill/models/event_input.dart';
import 'package:accountabill/widgets/custom_time_picker.dart';
import 'package:accountabill/widgets/event_dialog.dart';
import 'package:accountabill/widgets/under_construction.dart';
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
  final List<CalendarEvent> _events = [];

  /// Handle event creation
  void _createEvent(TimeOfDay time) async {
    // Show popup
    final eventInput = await showDialog<EventInput>(
      context: context,
      builder: (_) => EventDialog(initialTime: time),
    );

    // Validate user input
    print(eventInput);
    if (eventInput == null || eventInput.title.isEmpty) return;
    final start = buildDateTime(date, eventInput.startTime, time);
    final end = buildDateTime(
      date,
      eventInput.endTime,
      TimeOfDay(hour: (start.hour + 1) % 24, minute: start.minute),
    );

    setState(() {
      _events.add(
        CalendarEvent(start: start, end: end, title: eventInput.title),
      );
    });

    // Announce to screen readers that event was successfully created
    SemanticsService.sendAnnouncement(
      View.of(context),
      "Event created at ${time.format(context)}",
      TextDirection.ltr,
    );
  }

  /// Handle event deletion
  void _deleteEvent(CalendarEvent event) {
    setState(() {
      _events.remove(event);
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
      deleteEvent: _deleteEvent,
    );
  }
}
