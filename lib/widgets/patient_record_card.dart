import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/patient_record.dart';

class PatientRecordCard extends StatelessWidget {
  final PatientRecord patientRecord;

  PatientRecordCard({required this.patientRecord});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    // Format the date and time
    String formattedDateTime = "${now.day}/${now.month}/${now.year}";
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Image
            CachedNetworkImage(
              width: 50,
              height: 100,
              imageUrl:
                  "https://images.pexels.com/photos/2599244/pexels-photo-2599244.jpeg?auto=compress&cs=tinysrgb&w=600",
              placeholder: (context, url) => Center(child: const CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
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
                    patientRecord.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  // Age and Gender
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.square, color: Colors.red),
                          SizedBox(width: 5),
                          Text('Age: 60'),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.square, color: Colors.green),
                          SizedBox(width: 5),
                          Text('Gender: Male'),
                        ],
                      ),
                    ],
                  ),
                  const Divider(),
                  // Disease detection
                  _buildDetectionRow('No disease detected', Colors.green, formattedDateTime),
                  const Divider(),
                  _buildDetectionRow('Malaria Detected', Colors.red, formattedDateTime),
                  const Divider(),
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
            const Icon(Icons.date_range),
            const SizedBox(width: 5),
            Text(date), // Replace with actual date
          ],
        ),
        Row(
          children: [
            Icon(Icons.circle, color: color),
            const SizedBox(width: 5),
            Text(text),
          ],
        ),
      ],
    );
  }
}
