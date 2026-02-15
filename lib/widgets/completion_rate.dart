import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Display a simple pie chart of the user's completion percentage
class CompletionRate extends StatelessWidget {
  const CompletionRate({super.key});

  /// Show pie chart and component title
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 150,
          width: 150,
          child: PieChart(
            PieChartData(
              sections: _pieChartSections(context),
              sectionsSpace: 0,
              centerSpaceRadius: 0,
            ),
          ),
        ),
        Center(
          child: Text(
            "Completion rate",
            style: TextStyle(fontFamily: "Roboto", fontSize: 16),
          ),
        ),
      ],
    );
  }

  /// Create pie chart sections
  ///
  /// Currently displays a hardcoded value
  ///
  /// @param BuildContext context
  List<PieChartSectionData> _pieChartSections(BuildContext context) {
    return [
      PieChartSectionData(
        value: 70, // 70% for the first section
        color: Theme.of(
          context,
        ).colorScheme.inversePrimary, // Set color for this section
        title: '70%', // Optionally add a title
        radius: 50, // Size of the section
        titleStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white, // Text color for the title
        ),
      ),
      PieChartSectionData(
        value: 30, // 30% for the second section
        color: Colors.transparent, // Set color for this section
        title: '30%', // Optionally add a title
        radius: 50, // Size of the section
        titleStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white, // Text color for the title
        ),
      ),
    ];
  }
}
