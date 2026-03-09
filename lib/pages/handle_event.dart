import 'package:accountabill/data/models/calendar_event.dart';
import 'package:accountabill/data/repositories/authentication_repository.dart';
import 'package:accountabill/utils/date_time_builder.dart';
import 'package:accountabill/widgets/main_cta.dart';
import 'package:accountabill/widgets/page_container.dart';
import 'package:flutter/material.dart';

/// This page is used for creating, editing and deleting events off of the
/// custom time picker.
///
/// Takes in a DateTime object for determining the default values of the start
/// and end times. The default start time will be the time selected on the
/// calendar, the default end time will be one hour after the time selected.
///
/// Takes in an optional CalendarEvent object. If this object is not provided,
/// we will use the create mode. If the object is provided, we will pre-populate
/// the page with this object's values and consider the page in edit mode.
///
/// If using this in create mode, you must also pass in a deleteEvent function. This function
/// will handle removing the event from the timeline and can be found.
///
/// @param DateTime initialTime;
/// @param CalendarEvent? existingEvent;
/// @param void Function(CalendarEvent event)? deleteEvent;
class HandleEventPage extends StatefulWidget {
  final AuthenticationRepository authRepo;
  final DateTime initialTime;
  final CalendarEvent? existingEvent; // null = create mode
  final void Function(CalendarEvent event)? deleteEvent;
  const HandleEventPage({
    super.key,
    required this.authRepo,
    required this.initialTime,
    this.existingEvent,
    this.deleteEvent,
  });
  bool get isEditing => existingEvent != null;

  @override
  State<HandleEventPage> createState() => _HandleEventPageState();
}

class _HandleEventPageState extends State<HandleEventPage> {
  DateTime? selectedStartTime;
  DateTime? selectedEndTime;
  bool hasReminderSet = false;
  final _titleController = TextEditingController();
  final _startController = TextEditingController();
  final _endController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  /// Initialize state
  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      selectedStartTime = widget.existingEvent!.start;
      selectedEndTime = widget.existingEvent!.end;
      _titleController.text = widget.existingEvent!.title;
      _startController.text = formatHour(
        TimeOfDay.fromDateTime(selectedStartTime!),
      );
      _endController.text = formatHour(
        TimeOfDay.fromDateTime(selectedEndTime!),
      );
      _descriptionController.text = widget.existingEvent?.description ?? '';
    } else {
      selectedStartTime = widget.initialTime;
      selectedEndTime = widget.initialTime.add(Duration(hours: 1));
      _startController.text = formatHour(
        TimeOfDay.fromDateTime(selectedStartTime!),
      );
      _endController.text = formatHour(
        TimeOfDay.fromDateTime(selectedEndTime!),
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
      title: Text(widget.isEditing ? "Edit Event" : "New Event"),
      centerTitle: true,
    );
  }

  Widget _buildUI(BuildContext context) {
    return PageContainer(
      child: Column(
        children: [
          Expanded(
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
                              (time) =>
                                  setState(() => selectedStartTime = time),
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
                    controller: _descriptionController,
                    maxLines: null,
                    minLines: 3,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Description',
                      alignLabelWithHint: true,
                    ),
                  ),
                  // CheckboxListTile(
                  //   title: const Text("Remind me"),
                  //   activeColor: Theme.of(context).colorScheme.inversePrimary,
                  //   controlAffinity: ListTileControlAffinity.leading,
                  //   value: hasReminderSet,
                  //   onChanged: (bool? value) {
                  //     setState(() {
                  //       hasReminderSet = value ?? false;
                  //     });
                  //   },
                  // ), // TODO: Handle reminders and recurring events
                ],
              ),
            ),
          ),
          Column(
            children: [
              _buildSaveButton(),
              if (widget.isEditing) _buildDeleteButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return MainCTA(
      child: Text(widget.isEditing ? "Update" : "Save"),
      onPressed: () {
        if (!_formKey.currentState!.validate()) {
          return; // Stop if invalid
        }
        final start = selectedStartTime ?? widget.initialTime;
        final end =
            selectedEndTime ?? selectedStartTime!.add(Duration(hours: 1));
        Navigator.pop(
          context,
          CalendarEvent(
            id: widget.existingEvent?.id,
            userId: widget.authRepo.userId!,
            title: _titleController.text.trim(),
            start: start,
            end: end,
            description: _descriptionController.text.trim(),
            hasReminderSet: hasReminderSet,
          ),
        );
      },
    );
  }

  Widget _buildDeleteButton() {
    return MainCTA(
      child: Text("Delete"),
      onPressed: () {
        widget.deleteEvent?.call(widget.existingEvent!);
        Navigator.pop(context);
      },
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
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
      initialTime: parseTimeOfDay(controller.text),
    );

    if (time != null) {
      onSelected(timeOfDayToDateTime(DateTime.now(), time));
      controller.text = time.format(context);
    }
  }
}
