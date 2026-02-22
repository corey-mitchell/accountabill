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
  static const double pixelsPerMinute = .75;
  static const double totalHeight = 24 * 60 * pixelsPerMinute;

  const CustomTimePicker({super.key, required this.date, required this.events});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: 'Schedule for $date', // TODO: Format date
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 16,
        ),
        child: SizedBox(
          height: totalHeight,
          child: Stack(
            children: [
              _buildGrid(), // decorative
              _buildTimeSlots(), // target tracking
              _buildEvents(), // semantic buttons
            ],
          ),
        ),
      ),
    );
  }

  /// A decorative layer for drawing calendar appearance
  Widget _buildGrid() {
    return ExcludeSemantics(
      child: Container(
        padding: EdgeInsets.only(top: 16),
        child: CustomPaint(
          size: Size(double.infinity, totalHeight),
          painter: _GridPainter(pixelsPerMinute),
        ),
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
            onTap: () =>
                print('Open time editor $time'), // TODO: Open time editor
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () =>
                  print('Open time editor $time'), // TODO: Open time editor
              child: const SizedBox.expand(),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildEvents() {
    return Stack(
      children: [],
      // children: events.map((event) => {
      //   return Positioned(
      //     top: 0,
      //     left: 60,
      //     right: 8,
      //     height: totalHeight,
      //     child: Semantics(),
      //   )
      // }).toList(),
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
