import 'dart:convert';
import 'dart:io';

import 'package:accountabill/data/models/calendar_event.dart';
import 'package:accountabill/data/repositories/event_repository.dart';
import 'package:accountabill/widgets/custom_date_picker.dart';
import 'package:accountabill/widgets/custom_time_picker.dart';
import 'package:accountabill/pages/handle_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

/// User events page
///
/// This is where the user will be able to see and
/// edit their events on a calendar component.
///
/// TODOs:
///  1. Handle saving and deleting events in local storage (and then in long term storage)
///  2. Handle catch/fail/error cases
///  3. Handle recurring events and notification settings
///
/// Current know issues:
///  1. The left and right buttons do not fire the swipe animation
class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  static DateTime date = DateTime.now();
  Map<String, CalendarEvent> _events = {};
  int pageIndex = 0;
  // static const String fileName = 'assets/database.json';
  final EventRepository _repository = EventRepository();

  @override
  void initState() {
    super.initState();
    _initializeEvents();
  }

  // Read events from local DB into state
  void _initializeEvents() async {
    final loadedEvents = await _repository.loadEvents();
    setState(() {
      _events = loadedEvents;
    });
  }

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

  /// Handle directly setting calendar page index
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
    final CalendarEvent? newEvent = await _repository.createEvent(eventInput);
    if (newEvent != null) {
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
    final CalendarEvent? updatedEvent = await _repository.updateEvent(
      eventInput,
    );
    if (updatedEvent != null) {
      // Update UI
      setState(() {
        _events[event.id] = updatedEvent;
      });

      // Announce to screen readers that event was successfully updated
      SemanticsService.sendAnnouncement(
        View.of(context),
        "Event successfully updated",
        TextDirection.ltr,
      );
    }
  }

  /// Handle event deletion
  void _deleteEvent(CalendarEvent event) async {
    // Delete event from storage
    final bool deleted = await _repository.deleteEvent(event);
    if (deleted) {
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
