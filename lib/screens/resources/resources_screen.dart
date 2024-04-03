import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/patient_record.dart';
import '../../widgets/articles.dart';
import '../../widgets/search_field.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  TextEditingController searchController = TextEditingController();

  final List<PatientRecord> patientRecords = [
    PatientRecord(id: 1, name: 'John Doe', diagnosis: 'Hypertension'),
    PatientRecord(id: 2, name: 'Jane Smith', diagnosis: 'Diabetes'),
    // Add more sample patient records as needed
  ];

  late Future<List<String>> _imageUrlsFuture;
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    _imageUrlsFuture = fetchImageUrls(); // Fetch image URLs only once
  }

  Future<List<String>> fetchImageUrls() async {
    try {
      // Fetch image URLs from Firestore
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('carousel_images')
              .doc('home_screen') // Assuming 'home_screen' is the document ID
              .get();

      // Check if the document exists
      if (snapshot.exists) {
        // Access the 'images' field from the document data
        List<String> imageUrls =
            (snapshot.data()!['images'] as List<dynamic>).cast<String>();
        return imageUrls;
      } else {
        // Document doesn't exist, return an empty list
        return [];
      }
    } catch (e) {
      print('Error fetching image URLs: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchField(
            onSubmit: (value) async {
              
            },
          ),
        const SizedBox(
          height: 5,
        ),
        const Text(
          'Test Guides',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const Text(
          'Get more explanation from our user friendly test guides',
        ),
        const SizedBox(
          height: 5,
        ),
        FutureBuilder<List<String>>(
          future: _imageUrlsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child:
                       CircularProgressIndicator()); // or any other loading indicator
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<String>? imageUrls = snapshot.data;
              if (imageUrls != null && imageUrls.isNotEmpty) {
                return Column(
                  children: [
                    CarouselSlider(
                      items: imageUrls.map((imageUrl) {
                        return CachedNetworkImage(
                          imageUrl: imageUrl,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          // fit: BoxFit.cover,
                        );
                      }).toList(),
                      options: CarouselOptions(
                        autoPlay: true,
                        aspectRatio: 2,
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
                        count: imageUrls.length,
                        index: _currentIndex,
                      ),
                    ),
                  ],
                );
              } else {
                return const Text('No images found');
              }
            }
          },
        ),
        const SizedBox(height: 5),
        const Divider(height: 3,),
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
        const Articles(),
      ],
    );
  }
}
