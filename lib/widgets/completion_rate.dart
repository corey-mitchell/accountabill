import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CompletionRate extends StatelessWidget {
  const CompletionRate({super.key});

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
