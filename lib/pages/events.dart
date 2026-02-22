import 'package:accountabill/widgets/custom_time_picker.dart';
import 'package:accountabill/widgets/under_construction.dart';
import 'package:flutter/material.dart';

/// User events page
///
/// 🚧 Currently under construction 🚧
///
/// This is where the user will be able to see and
/// edit their events on a calendar component
class EventsPage extends StatelessWidget {
  static DateTime date = DateTime.now();
  const EventsPage({super.key});

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
    return CustomTimePicker(date: date, events: []);
  }
}
