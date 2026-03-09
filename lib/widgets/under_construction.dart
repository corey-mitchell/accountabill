import 'package:flutter/material.dart';

/// Display a message to the user letting them know
/// that the current page is under construction
class UnderConstruction extends StatelessWidget {
  const UnderConstruction({super.key});

  /// Show a large construction icon and a message to the user
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).padding.bottom,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Vertically center the content
          crossAxisAlignment:
              CrossAxisAlignment.center, // Horizontally center the content
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
      ),
    );
  }
}
