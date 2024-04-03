import 'package:flutter/material.dart';
import 'package:hemospectra/models/patient.dart';
import 'package:hemospectra/screens/patient_details/patient_details_screen.dart';

class FilteredList extends StatelessWidget {
  final List<Patient> filteredPatients;

  const FilteredList({
    Key? key,
    required this.filteredPatients,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: Navigator.of(context).pop,
        ),
        title: const Text('Filtered Patients'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        itemCount: filteredPatients.length,
        itemBuilder: (context, index) {
          final patient = filteredPatients[index];
          return ListTile(
            title: Text(patient.fullName ?? ''),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PatientDetailsScreen(
                      patientId: filteredPatients[index].id,
                    ),
                  ),
                );
            },
            // Add more patient details as needed
          );
        },
      ),
    );
  }
}
