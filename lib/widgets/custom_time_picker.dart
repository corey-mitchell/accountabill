import 'package:accountabill/data/models/calendar_event.dart';
import 'package:accountabill/utils/date_time_builder.dart';
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
///
/// @param DateTime date;
/// @param Map<String, CalendarEvent> events;
/// @param void Function(DateTime time) createEvent;
/// @param void Function(CalendarEvent event) updateEvent;
/// @param void Function() nextDay;
/// @param void Function() prevDay;
/// @return StatelessWidget;
class CustomTimePicker extends StatelessWidget {
  final DateTime date;
  final Map<String, CalendarEvent> events;
  final PageController pageController;
  final void Function(DateTime time) createEvent;
  final void Function(CalendarEvent event) updateEvent;
  final void Function(int index) handlePageSwipe;

  const CustomTimePicker({
    super.key,
    required this.date,
    required this.events,
    required this.pageController,
    required this.createEvent,
    required this.updateEvent,
    required this.handlePageSwipe,
  });

  static const double pixelsPerMinute = .75;
  static const double totalHeight = 24 * 60 * pixelsPerMinute;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      onPageChanged: handlePageSwipe,
      itemBuilder: (context, index) {
        return Semantics(
          container: true,
          label: 'Schedule for ${formatDate(date)}',
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
      },
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
            label: 'Add event at ${formatHour(time)}',
            onTap: () {
              final dateTime = timeOfDayToDateTime(date, time);
              createEvent(dateTime);
            },
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                final dateTime = timeOfDayToDateTime(date, time);
                createEvent(dateTime);
              },
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

    // Filter out events from other days
    final List<CalendarEvent> filteredEvents = events.values
        .where((event) => event.start.day == date.day)
        .toList();

    return Stack(
      children: filteredEvents.map((event) {
        final top = minutesSinceMidnight(event.start) * pixelsPerMinute;
        final height = (event.duration.inMinutes * pixelsPerMinute).clamp(
          0.0,
          double.infinity,
        );
        final start = formatHour(TimeOfDay.fromDateTime(event.start));
        final end = formatHour(TimeOfDay.fromDateTime(event.end));
        return Positioned(
          top: top,
          left: 60,
          right: 8,
          height: height,
          child: Semantics(
            button: true,
            label: "${event.title}, from $start to $end",
            hint: "Tap to edit",
            child: GestureDetector(
              onTap: () => updateEvent(event),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final elementHeight = constraints.maxHeight;
                  const minHeightForTitle = 24;
                  const minHeightForFull = 40;
                  final showFull = elementHeight >= minHeightForFull;
                  final showTitleOnly = elementHeight >= minHeightForTitle;
                  return Container(
                    padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (showFull)
                          Text(
                            '$start-$end',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              height: 1.0,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        if (showTitleOnly)
                          Text(
                            event.title,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              height: 1.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  );
                },
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
/// @param double pixelsPerMinute
class _GridPainter extends CustomPainter {
  final double pixelsPerMinute;

  _GridPainter(this.pixelsPerMinute);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black45
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
        final formatted = formatHour(time);
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

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
