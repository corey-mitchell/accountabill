import 'package:accountabill/widgets/completion_rate.dart';
import 'package:accountabill/widgets/money_donated.dart';
import 'package:flutter/material.dart';

/// Main Dashboard page
///
/// This is where the user will see general statistics and
/// be driven to other places in the application.
///
/// @params String userName
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key, required this.userName});

  final String userName;

  /// Page scaffold
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBar(context), body: _buildUI(context));
  }

  /// Page app bar widget
  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primaryFixed,
      title: Text("Welcome, $userName"),
      actions: [
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            Navigator.pushNamed(context, '/settings');
          },
        ),
      ],
    );
  }

  /// Page UI main widget
  Widget _buildUI(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        spacing: 32,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [CompletionRate(), MoneyDonated()],
          ),

          Container(
            width: double.infinity, // consume full width
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.inverseSurface,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              spacing: 16,
              children: [
                Text(
                  "Words of encouragement:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "Lorem ipsum dolor sit amet, consectetur adipisicing elif.",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          Spacer(), // Push button to the bottom
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom,
            ),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/events');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  foregroundColor: Colors.white,
                ),
                child: Text("Schedule an event"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
