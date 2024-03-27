import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart' as fl_chart;

class PieChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Sample data for the pie chart
    List<fl_chart.PieChartSectionData> pieChartSections = [
      fl_chart.PieChartSectionData(
        value: 30,
        color: Colors.red,
        showTitle: false,
        title: 'Malaria',
        radius: 20,
      ),
      fl_chart.PieChartSectionData(
        value: 50,
        color: Colors.green,
        showTitle: false,
        title: 'Healthy',
        radius: 20,
      ),
      fl_chart.PieChartSectionData(
        value: 20,
        color: Colors.black,
        showTitle: false,
        title: 'Diabetes',
        radius: 20,
      ),
      fl_chart.PieChartSectionData(
        value: 20,
        color: Colors.blue,
        showTitle: false,
        title: 'Typhoid',
        radius: 20,
      ),
      fl_chart.PieChartSectionData(
        value: 20,
        color: Colors.yellow,
        showTitle: false,
        title: 'HIV',
        radius: 20,
      ),
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AspectRatio(
          aspectRatio: 2.5,
          child: fl_chart.PieChart(
            swapAnimationDuration: const Duration(seconds: 5),
            swapAnimationCurve: Curves.bounceIn,
            fl_chart.PieChartData(
              sections: pieChartSections,
              centerSpaceRadius: 40,
            ),
          ),
        ),
          const SizedBox(height: 10),
          Wrap(
              alignment: WrapAlignment.center,
              children: pieChartSections
                  .map((section) => Container(
                        margin: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              color: section.color,
                            ),
                            const SizedBox(width: 8),
                            Text(section.title),
                          ],
                        ),
                      ))
                  .toList(),
            ),
      ],
    );
  }
}

