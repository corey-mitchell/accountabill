import 'package:accountabill/models/calendar_event.dart';
import 'package:accountabill/models/date_time_builder.dart';
import 'package:flutter/material.dart';

/// This creates a dialog widget which will allow the user to add event details
///
/// A stateful component which accepts an initial time for creating events at the selected time.
class HandleEventPage extends StatefulWidget {
  final DateTime initialTime;
  final CalendarEvent? existingEvent; // null = create mode
  final void Function(CalendarEvent event)? deleteEvent;
  const HandleEventPage({
    super.key,
    required this.initialTime,
    this.existingEvent,
    this.deleteEvent,
  });
  bool get isEditing => existingEvent != null;

  @override
  State<HandleEventPage> createState() => _HandleEventPageState();
}

class _HandleEventPageState extends State<HandleEventPage> {
  String? title;
  DateTime? selectedStartTime;
  DateTime? selectedEndTime;
  String? description;
  bool hasReminderSet = false;
  final _titleController = TextEditingController();
  final _startController = TextEditingController();
  final _endController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  /// Initialize state
  void initState() {
    super.initState();

    if (widget.isEditing) {
      _titleController.text = widget.existingEvent!.title;
      selectedStartTime = widget.existingEvent!.start;
      selectedEndTime = widget.existingEvent!.end;
      description = widget.existingEvent!.description;

      _startController.text = widget.existingEvent!.start.toString();
      _endController.text = widget.existingEvent!.end.toString();
    } else {
      selectedStartTime = widget.initialTime;
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
      title: Text(widget.isEditing ? "Edit Event" : "New Event"),
      centerTitle: true,
    );
  }

  Widget _buildUI(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: Column(
          spacing: 16,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Event name',
              ),
              validator: (String? value) {
                return (value == null || value.trim().isEmpty)
                    ? 'Value cannot be empty'
                    : null;
              },
            ),
            Row(
              spacing: 16,
              children: [
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    controller: _startController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Start time',
                    ),
                    validator: (String? value) {
                      return (value == null || value.trim().isEmpty)
                          ? 'Value cannot be empty'
                          : null;
                    },
                    onTap: () {
                      _pickTime(
                        context,
                        _startController,
                        (time) => setState(() => selectedStartTime = time),
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    controller: _endController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'End time',
                    ),
                    validator: (String? value) {
                      return (value == null || value.trim().isEmpty)
                          ? 'Value cannot be empty'
                          : null;
                    },
                    onTap: () {
                      _pickTime(
                        context,
                        _endController,
                        (time) => setState(() => selectedEndTime = time),
                      );
                    },
                  ),
                ),
              ],
            ),
            TextFormField(
              maxLines: null,
              minLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Description',
                alignLabelWithHint: true,
              ),
            ),
            CheckboxListTile(
              title: const Text("Is recurring"),
              activeColor: Theme.of(context).colorScheme.inversePrimary,
              controlAffinity: ListTileControlAffinity.leading,
              value: hasReminderSet,
              onChanged: (bool? value) {
                setState(() {
                  hasReminderSet = value ?? false;
                });
              },
            ),
            const Spacer(), // Push button to the bottom
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) {
                      return; // Stop if invalid
                    }
                    final start = selectedStartTime ?? widget.initialTime;
                    final end =
                        selectedEndTime ??
                        selectedStartTime!.add(Duration(hours: 1));
                    Navigator.pop(
                      context,
                      CalendarEvent(
                        title: _titleController.text.trim(),
                        start: start,
                        end: end,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.inversePrimary,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(widget.isEditing ? "Update" : "Save"),
                ),
              ),
            ),
            if (widget.isEditing)
              Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom,
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    print("Delete event ${widget.existingEvent!.title}");
                    widget.deleteEvent?.call(widget.existingEvent!);
                  },
                  child: const Text("Delete Task"),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Helper function for converting input to a time picker
  Future<void> _pickTime(
    BuildContext context,
    TextEditingController controller,
    ValueChanged<DateTime> onSelected,
  ) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(widget.initialTime),
    );

    if (time != null) {
      onSelected(timeOfDayToDateTime(DateTime.now(), time));
      controller.text = time.format(context);
    }
  }
}
