import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../models/patient_record.dart';
import '../../widgets/articles.dart';
import '../../widgets/custom_search_bar.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen>
     {
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
  int _selectedIndex = 0;

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
          height: 20,
        ),
        const Text(
          'Test Guides',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const Text(
          'Get more explanation from our user friendly test guides',
        ),
        const SizedBox(
          height: 10,
        ),
        CarouselSlider(
          items: carouselItems.map((item) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
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
            height: 150.0,
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
            cornerRadius: 10,
            width: 20,
            activeColor: Colors.blue,
            color: Colors.black54,
            count: carouselItems.length,
            index: _currentIndex,
          ),
        ),
        const SizedBox(height: 10),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Articles',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            IconButton(onPressed: () {}, icon: const Icon(Icons.sort_outlined)),
          ],
        ),
        const SizedBox(height: 10),
        const Articles(),
      ],
    );
  }
}
