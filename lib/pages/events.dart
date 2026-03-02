import 'package:accountabill/models/calendar_event.dart';
import 'package:accountabill/widgets/custom_date_picker.dart';
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
  int pageIndex = 0;

  /// Handle setting the date object
  void _setDate(DateTime newDate) {
    setState(() {
      date = newDate;
    });
  }

  /// Handle progressing the date by one day
  void _nextDay() {
    _setDate(date.add(const Duration(days: 1)));
    _setPageIndex(pageIndex + 1);
  }

  /// Handle regressing the date by one day
  void _prevDay() {
    _setDate(date.subtract(const Duration(days: 1)));
    _setPageIndex(pageIndex - 1);
  }

  /// Handle setting calendar page index
  void _setPageIndex(int index) {
    setState(() {
      pageIndex = index;
    });
  }

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
    final newEvent = CalendarEvent(
      start: start,
      end: end,
      title: eventInput.title,
      description: eventInput.description,
      hasReminderSet: eventInput.hasReminderSet,
    );

    // TODO: Add event to storage

    // Update UI
    setState(() {
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

    // TODO: Update event in storage

    // Update UI
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
    // TODO: Delete event from storage

    // Update UI
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
    return Column(
      children: [
        CustomDatePicker(
          date: date,
          setDate: _setDate,
          nextDay: _nextDay,
          prevDay: _prevDay,
        ),
        Expanded(
          child: CustomTimePicker(
            date: date,
            events: _events,
            pageIndex: pageIndex,
            setPageIndex: _setPageIndex,
            nextDay: _nextDay,
            prevDay: _prevDay,
            createEvent: _createEvent,
            updateEvent: _updateEvent,
          ),
        ),
      ],
    );
  }
}
