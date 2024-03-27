import 'package:flutter/material.dart';
import 'package:hemospectra/screens/test/disease_data.dart';
import 'package:hemospectra/widgets/pie_chart.dart';
import '../../models/patient_record.dart';
import '../../widgets/custom_search_bar.dart';
import '../../widgets/patient_record_card.dart';

class TestScreen extends StatefulWidget {
  TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  TextEditingController searchController = TextEditingController();

  final List<PatientRecord> patientRecords = [
    PatientRecord(id: 1, name: 'John Doe', diagnosis: 'Hypertension'),
    PatientRecord(id: 2, name: 'Jane Smith', diagnosis: 'Diabetes'),
    // Add more sample patient records as needed
  ];

  List<String> carouselItems = [
    'Item 1',
    'Item 2',
    'Item 3',
    // Add more carousel items as needed
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomSearchBar(
          controller: searchController,
          onChanged: (value) {
            // Handle search functionality
            // For example, filter patient records based on the search query
          },
        ),
        const SizedBox(
          height: 10,
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'History Summary',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                PieChart(),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recent Tests'),
            Text('See all'),
          ],
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: patientRecords.length,
            itemBuilder: (context, index) {
              return PatientRecordCard(patientRecord: patientRecords[index]);
            },
          ),
        ),
      ],
    );
  }
}
