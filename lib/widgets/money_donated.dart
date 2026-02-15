import 'package:flutter/material.dart';

/// Display the user's total money donated
class MoneyDonated extends StatelessWidget {
  const MoneyDonated({super.key});

  /// Show user's donation amount and component title
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 150,
          width: 150,
          child: Center(
            child: Text(
              "\$430.00",
              style: TextStyle(
                fontFamily: "Roboto",
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Center(
          child: Text(
            "Money donated",
            style: TextStyle(fontFamily: "Roboto", fontSize: 16),
          ),
        ),
      ],
    );
  }
}
