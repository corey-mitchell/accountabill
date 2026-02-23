import 'package:accountabill/models/event_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// This creates a dialog widget which will allow the user to add event details
///
/// A stateful component which accepts an initial time for creating events at the selected time.
class EventDialog extends StatefulWidget {
  final TimeOfDay initialTime;
  const EventDialog({super.key, required this.initialTime});

  @override
  State<EventDialog> createState() => _EventDialogState();
}

class _EventDialogState extends State<EventDialog> {
  final controller = TextEditingController();
  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("New Event"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: "Event title"),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              final pickVal = await showTimePicker(
                context: context,
                initialTime: widget.initialTime,
              );
              if (pickVal != null) {
                setState(() {
                  selectedStartTime = pickVal;
                });
              }
            },
            child: Text(
              selectedStartTime == null
                  ? "Select Start Time"
                  : selectedStartTime!.format(context),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final pickVal = await showTimePicker(
                context: context,
                initialTime: TimeOfDay(
                  hour: (widget.initialTime.hour + 1) % 24,
                  minute: widget.initialTime.minute,
                ),
              );
              if (pickVal != null) {
                setState(() {
                  selectedEndTime = pickVal;
                });
              }
            },
            child: Text(
              selectedEndTime == null
                  ? "Select End Time"
                  : selectedEndTime!.format(context),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () => {
            Navigator.pop(
              context,
              EventInput(
                title: controller.text.trim(),
                startTime: selectedStartTime!,
                endTime: selectedEndTime!,
              ),
            ),
          },
          child: const Text("Create"),
        ),
      ],
    );
  }
}
