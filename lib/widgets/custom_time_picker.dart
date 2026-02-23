import 'package:accountabill/models/calendar_event.dart';
import 'package:accountabill/widgets/under_construction.dart';
import 'package:flutter/material.dart';

/// Custom Time Picker component
///
/// Provides a 24-hour custom time picker for displaying and creating
/// events.
///
/// This is a fully accessible calendar component wrapped in the
/// appropriate semantic elements. It will return a stacked component with
/// three layers. A decorative layer for drawing evenly spaced lines, a
/// logical semantic layer for target tracking and an event layer for tracking
/// individual events on the timeline (with semantically aware buttons).
class CustomTimePicker extends StatelessWidget {
  final DateTime date;
  final List<CalendarEvent> events;
  final void Function(TimeOfDay time) createEvent;
  final void Function(CalendarEvent event) deleteEvent;
  static const double pixelsPerMinute = .75;
  static const double totalHeight = 24 * 60 * pixelsPerMinute;

  const CustomTimePicker({
    super.key,
    required this.date,
    required this.events,
    required this.createEvent,
    required this.deleteEvent,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: 'Schedule for $date', // TODO: Format date
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: 16,
          bottom: MediaQuery.of(context).padding.bottom + 16,
        ),
        child: SizedBox(
          height: totalHeight,
          child: Stack(
            children: [
              _buildGrid(), // decorative
              _buildTimeSlots(), // target tracking
              _buildEvents(context), // semantic buttons
            ],
          ),
        ),
      ),
    );
  }

  /// A decorative layer for drawing calendar appearance
  Widget _buildGrid() {
    return ExcludeSemantics(
      child: CustomPaint(
        size: Size(double.infinity, totalHeight),
        painter: _GridPainter(pixelsPerMinute),
      ),
    );
  }

  /// A semantic layer for building time slots with target tracking
  Widget _buildTimeSlots() {
    return Stack(
      // The number 48 is from 30 minute blocks of 24 hours (2 * 24 = 48)
      children: List.generate(48, (index) {
        final minutes = index * 30;
        final time = TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);

        return Positioned(
          top: minutes * pixelsPerMinute,
          left: 0,
          right: 0,
          height: 30 * pixelsPerMinute,
          child: Semantics(
            button: true,
            label: 'Add event at $time',
            onTap: () => createEvent(time),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => createEvent(time),
              child: const SizedBox.expand(),
            ),
          ),
        );
      }),
    );
  }

  // An event layer for adding events to the timeline
  Widget _buildEvents(BuildContext context) {
    double minutesSinceMidnight(DateTime dt) {
      return dt.hour * 60 + dt.minute + dt.second / 60 + dt.millisecond / 60000;
    }

    String twoDigit(int value) => value.toString().padLeft(2, '0');

    return Stack(
      children: events.map((event) {
        final top = minutesSinceMidnight(event.start) * pixelsPerMinute;
        final height = (event.duration.inMinutes * pixelsPerMinute).clamp(
          0.0,
          double.infinity,
        );
        return Positioned(
          top: top,
          left: 60,
          right: 8,
          height: height,
          child: Semantics(
            button: true,
            label:
                "${event.title}, from ${TimeOfDay.fromDateTime(event.start).format(context)} to ${TimeOfDay.fromDateTime(event.end).format(context)}",
            hint: "Tap to edit",
            child: GestureDetector(
              // onTap: () => print("Open event editor for ${event.title}"), // TODO: Open event modal
              onTap: () => deleteEvent(event),
              child: Container(
                padding: EdgeInsets.only(top: 8, left: 16, right: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${event.start.hour}:${twoDigit(event.start.minute)}-${event.end.hour}:${twoDigit(event.end.minute)}',
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.white70),
                    ),
                    Text(
                      event.title,
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Create a custom painter class for drawing grid lines and time
///
/// @param pixelsPerMinute<double>
class _GridPainter extends CustomPainter {
  final double pixelsPerMinute;

  _GridPainter(this.pixelsPerMinute);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors
          .black45 // TODO: Update to be theme aware
      ..strokeWidth = 2;

    final textStyle = const TextStyle(color: Colors.black45, fontSize: 12);

    for (int halfHour = 0; halfHour < 48; halfHour++) {
      // Draw horizontal lines
      final bool isHour = halfHour % 2 == 0;
      final double xOffset = isHour ? 60 : 75;
      final y = halfHour * 30 * pixelsPerMinute;
      canvas.drawLine(Offset(xOffset, y), Offset(size.width, y), paint);

      // Draw hour text
      if (isHour && halfHour != 48) {
        final hour = halfHour ~/ 2;
        final time = TimeOfDay(hour: hour, minute: 0);
        final formatted = _formatHour(time);
        final textSpan = TextSpan(text: formatted, style: textStyle);

        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(16, y - textPainter.height / 2));
      }
    }
  }

  String _formatHour(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? "AM" : "PM";
    return "$hour $period";
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
