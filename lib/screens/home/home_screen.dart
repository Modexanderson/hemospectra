import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../models/patient_record.dart';
import '../../widgets/custom_search_bar.dart';
import '../../widgets/patient_record_card.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const Text(
                'Hi Name',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              CarouselSlider(
                items: carouselItems.map((item) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                        ),
                        child: Center(
                          child: Text(
                            item,
                            style: const TextStyle(fontSize: 16.0),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
                options: CarouselOptions(
                  autoPlay: true,
                  height: 130.0,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: CarouselIndicator(
                  height: 10,
                  cornerRadius: 20,
                  width: 10,
                  activeColor: Colors.blue,
                  color: Colors.black54,
                  count: carouselItems.length,
                  index: _currentIndex,
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Patient Records', style: TextStyle(fontSize: 16),),
                  Text('See all'),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: patientRecords.length,
                  itemBuilder: (context, index) {
                    return PatientRecordCard(
                        patientRecord: patientRecords[index]);
                  },
                ),
              ),
            ],
          );
  }
}
