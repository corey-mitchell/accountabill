import 'package:flutter/material.dart';

/// Display a message to the user letting them know
/// that the current page is under construction
class UnderConstruction extends StatelessWidget {
  const UnderConstruction({super.key});

  /// Show a large construction icon and a message to the user
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        spacing: 32,
        children: [
          Center(
            widthFactor: double.infinity,
            child: Icon(
              Icons.construction,
              size: 200,
              color: Theme.of(context).colorScheme.inverseSurface,
            ),
          ),
          Text(
            "This page is currently under construction",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
