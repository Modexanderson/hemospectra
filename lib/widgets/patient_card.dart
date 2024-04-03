import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/patient.dart';
import '../models/patient_record.dart';

class PatientCard extends StatelessWidget {
  final Patient patient;

  const PatientCard({super.key, required this.patient});

  int _calculateAge(DateTime dateOfBirth) {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    int age = _calculateAge(patient.dateOfBirth!);

    // Format the date and time
    String formattedDateTime =
        "${patient.diagnosisDate!.day}/${patient.diagnosisDate!.month}/${patient.diagnosisDate!.year}";
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Row(
          children: [
            // Image
            CachedNetworkImage(
              width: 100,
              height: 100,
              imageUrl: patient.image!,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(10), // Adjust the value as needed
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Spacer between image and text
            const SizedBox(width: 20),
            // Patient details
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align text to the left
                children: [
                  Text(
                    patient.fullName!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  // Age and Gender
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Icon(
                            Icons.square,
                            color: Colors.red,
                            size: 15,
                          ),
                          Text(
                            'Age: $age',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Icon(Icons.square,
                              color: Colors.green, size: 15),
                          const SizedBox(width: 5),
                          Text(
                            'Gender: ${patient.gender}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 3),
                  // Disease detection
                  _buildDetectionRow(
                      patient.diagnosis!,
                      patient.diagnosis == 'No disease detected'
                          ? Colors.green
                          : Colors.red,
                      formattedDateTime),
                  const Divider(height: 3),
                  _buildDetectionRow(
                      patient.diagnosis!,
                      patient.diagnosis == 'No disease detected'
                          ? Colors.green
                          : Colors.red,
                      formattedDateTime),
                  const Divider(height: 3),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetectionRow(String text, Color color, String date) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.date_range, size: 15),
            Text(
              date,
              style: const TextStyle(fontSize: 12),
            ), // Replace with actual date
          ],
        ),
        Row(
          children: [
            Icon(Icons.circle, color: color, size: 15),
            Text(
              text,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}
