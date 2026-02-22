class CalendarEvent {
  final DateTime start;
  final DateTime end;
  final String title;
  final String description;

  CalendarEvent({
    required this.start,
    required this.end,
    required this.title,
    required this.description,
  });

  Duration get duration => end.difference(start);
}
