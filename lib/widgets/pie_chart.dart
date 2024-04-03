import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart' as fl_chart;
import 'package:hemospectra/services/database/patient_database_helper.dart';

import '../services/authentification_service.dart';

class PieChart extends StatelessWidget {
  const PieChart({Key? key}) : super(key: key);

  @override
Widget build(BuildContext context) {
  return StreamBuilder<Map<String, int>>(
    stream: PatientDatabaseHelper().fetchDiagnosisForUserPatients(AuthentificationService().currentUser.uid),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: const CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else {
        final Map<String, int> diagnosisCountMap = snapshot.data ?? {};
        print('Diagnosis count data: $diagnosisCountMap');
        return buildPieChart(diagnosisCountMap);
      }
    },
  );
}


  Map<String, int> _getDiagnosisCounts(List<String> diagnosisList) {
    // Create a map to store the counts of each diagnosis
    Map<String, int> diagnosisCounts = {};

    // Count the occurrences of each diagnosis
    for (String diagnosis in diagnosisList) {
      if (diagnosisCounts.containsKey(diagnosis)) {
        diagnosisCounts[diagnosis] = (diagnosisCounts[diagnosis] ?? 0) + 1;
      } else {
        diagnosisCounts[diagnosis] = 1;
      }
    }

    return diagnosisCounts;
  }

  Widget buildPieChart(Map<String, int> diagnosisCountMap) {
    List<fl_chart.PieChartSectionData> pieChartSections = [];
    final List<Color> colors = [
      Colors.red,
      Colors.green,
      Colors.black,
      Colors.blue,
      Colors.yellow,
    ];

    // Generate pie chart sections based on diagnosis counts
    diagnosisCountMap.forEach((diagnosis, count) {
      pieChartSections.add(
        fl_chart.PieChartSectionData(
          value: count.toDouble(),
          color: colors[pieChartSections.length % colors.length],
          showTitle: false,
          title: diagnosis,
          radius: 20,
        ),
      );
    });

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
