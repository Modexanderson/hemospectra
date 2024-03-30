import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/patient_record.dart';

class PatientRecordCard extends StatelessWidget {
  final PatientRecord patientRecord;

  const PatientRecordCard({super.key, required this.patientRecord});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    // Format the date and time
    String formattedDateTime = "${now.day}/${now.month}/${now.year}";
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
              imageUrl:
                  "https://images.pexels.com/photos/2599244/pexels-photo-2599244.jpeg?auto=compress&cs=tinysrgb&w=600",
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
                    patientRecord.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  // Age and Gender
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            Icons.square,
                            color: Colors.red,
                            size: 15,
                          ),
                          Text(
                            'Age: 60',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(Icons.square, color: Colors.green, size: 15),
                          SizedBox(width: 5),
                          Text(
                            'Gender: Male',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 3),
                  // Disease detection
                  _buildDetectionRow(
                      'No disease detected', Colors.green, formattedDateTime),
                  const Divider(height: 3),
                  _buildDetectionRow(
                      'Malaria Detected', Colors.red, formattedDateTime),
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
