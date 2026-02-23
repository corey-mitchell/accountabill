/// Calendar event data layer
class CalendarEvent {
  static int _counter = 0;
  final String id;
  final DateTime start;
  final DateTime end;
  final String title;
  final String? description;
  final bool? hasReminderSet;

  CalendarEvent({
    required this.start,
    required this.end,
    required this.title,
    this.description,
    this.hasReminderSet,
  }) : id = (_counter++)
           .toString(); // This increments a new id for each instance

  Duration get duration => end.difference(start);
}
