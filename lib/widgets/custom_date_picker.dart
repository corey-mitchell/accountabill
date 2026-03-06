import 'package:accountabill/utils/date_time_builder.dart';
import 'package:flutter/material.dart';

/// A date picker bar
///
/// This is meant to be used in conjunction with the
/// custom time picker Widget. Together they comprise the events
/// page.
///
/// @param DateTime date;
/// @param void Function(DateTime date) setDate;
/// @param void Function() nextDay;
/// @param void Function() prevDay;
class CustomDatePicker extends StatelessWidget {
  final DateTime date;
  final void Function(DateTime date) setDate;
  final void Function() nextDay;
  final void Function() prevDay;

  const CustomDatePicker({
    super.key,
    required this.date,
    required this.setDate,
    required this.nextDay,
    required this.prevDay,
  });

  /// Page scaffold
  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: 'Currently selected date is ${formatDate(date)}',
      child: Material(
        elevation: 4,
        child: Row(
          children: [
            // Previous day
            Center(
              child: IconButton(
                icon: Icon(Icons.chevron_left),
                onPressed: prevDay,
              ),
            ),

            // Date selector
            Expanded(
              child: GestureDetector(
                onTap: () {
                  _pickDate(context, (newDate) => setDate(newDate));
                },
                child: Center(
                  child: Text(formatDate(date), textAlign: TextAlign.center),
                ),
              ),
            ),

            // Next day
            Center(
              child: IconButton(
                icon: Icon(Icons.chevron_right),
                onPressed: nextDay,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function for converting text into date picker
  Future<void> _pickDate(
    BuildContext context,
    ValueChanged<DateTime> onSelected,
  ) async {
    final newDate = await showDatePicker(
      context: context,
      firstDate: DateTime(2026),
      lastDate: DateTime(2050),
    );

    if (newDate != null) {
      onSelected(newDate);
    }
  }
}
