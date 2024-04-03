import 'package:flutter/material.dart';
import 'package:hemospectra/models/patient.dart';
import 'package:logger/logger.dart';

import '../services/database/patient_database_helper.dart';
import 'patient_card.dart';

class PatientShortDetailCard extends StatelessWidget {
  final String patientId;
  final VoidCallback onPressed;
  const PatientShortDetailCard({
    Key? key,
    required this.patientId,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: FutureBuilder<Patient?>(
        future: PatientDatabaseHelper().getPatientWithID(patientId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final patient = snapshot.data;
            return PatientCard(
              patient: patient!,
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: SizedBox());
          } else if (snapshot.hasError) {
            final errorMessage = snapshot.error.toString();
            Logger().e(errorMessage);
          }
          return const Center(
            child: Icon(
              Icons.error,
              // color: kTextColor,
              size: 60,
            ),
          );
        },
      ),
    );
  }
}
