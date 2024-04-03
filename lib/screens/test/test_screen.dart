import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hemospectra/screens/test/disease_data.dart';
import 'package:hemospectra/widgets/pie_chart.dart';
import 'package:logger/logger.dart';
import '../../models/patient.dart';
import '../../models/patient_record.dart';
import '../../services/authentification_service.dart';
import '../../services/data_streams/users_patients_streams.dart';
import '../../services/database/patient_database_helper.dart';
import '../../widgets/search_field.dart';
import '../../widgets/patient_card.dart';
import '../../widgets/snack_bar.dart';
import '../filtered_list.dart/filtered_list.dart';
import '../manage_patients/manage_patients_screen.dart';

class TestScreen extends StatefulWidget {
  TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  TextEditingController searchController = TextEditingController();

  final UsersPatientsStream usersPatientsStream = UsersPatientsStream();
  // List<String> imageUrls = [];
  late Future<List<String>> _imageUrlsFuture; // Declare a future variable
  String _userName = '';
  List<Patient> allPatients =
      []; // List to hold all patients fetched from the database
  List<Patient> filteredPatients = [];

  @override
  void initState() {
    super.initState();
    _imageUrlsFuture = fetchImageUrls(); // Fetch image URLs only once
    fetchUserName();
    fetchPatients();
    usersPatientsStream.init();
  }

  @override
  void dispose() {
    super.dispose();
    usersPatientsStream.dispose();
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

  Future<void> fetchUserName() async {
    // Replace 'currentUserID' with your method to get the currently logged-in user's ID
    String userUid = AuthentificationService().currentUser.uid;
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(userUid)
          .get();

      if (snapshot.exists) {
        setState(() {
          _userName = snapshot.data()!['full_name'] ?? '';
        });
      }
    } catch (e) {
      print('Error fetching user name: $e');
    }
  }

  void fetchPatients() async {
    // Fetch patients from the database and populate the allPatients list
    List<Patient> fetchedPatients =
        await PatientDatabaseHelper().getUsersPatientsList();
    setState(() {
      allPatients = fetchedPatients;
      filteredPatients =
          allPatients; // Initialize filteredPatients with all patients initially
    });
  }

  void filterPatients(String query) {
    setState(() {
      // Filter the list of patients based on the search query
      filteredPatients = allPatients
          .where((patient) =>
              patient.fullName!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> refreshPage() {
    usersPatientsStream.reload();
    return Future<void>.value();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchField(
          onSubmit: (value) async {
            final query = value.toString();
            if (query.isEmpty) return;
            try {
              filterPatients(query); // Perform filtering
              if (filteredPatients.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FilteredList(
                      filteredPatients: filteredPatients,
                    ),
                  ),
                );
              } else {
                throw "No matching patients found";
              }
            } catch (e) {
              final error = e.toString();
              Logger().e(error);
              ShowSnackBar().showSnackBar(context, error);
            }
          },
        ),
         const Card(
          margin: EdgeInsets.symmetric(vertical: 20),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'History Summary',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                PieChart(),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Recent Tests'),
            TextButton(
                child: const Text('See all'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ManagePatientsScreen(),
                    ),
                  );
                }),
          ],
        ),
        Expanded(
          child: StreamBuilder(
            stream: usersPatientsStream.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final patientsIds = snapshot.data;
                if (patientsIds!.isEmpty) {
                  return const Center(
                    child: Text("Add your first Patient"),
                  );
                }
                return ListView.builder(
                    itemCount: patientsIds.length,
                    itemBuilder: (context, index) {
                      final reversedIds = patientsIds.reversed.toList();
                      return Expanded(
                        child: FutureBuilder<Patient?>(
                            future: PatientDatabaseHelper()
                                .getPatientWithID(reversedIds[index]),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: SizedBox());
                              } else if (snapshot.hasError) {
                                final error = snapshot.error;
                                Logger().e(error);
                                print(error);
                                return const Center(
                                  child: Icon(
                                    Icons.error,
                                    // color: kTextColor,
                                    size: 60,
                                  ),
                                );
                              } else if (snapshot.hasData) {
                                final patient = snapshot.data!;
                                return PatientCard(patient: patient);
                              } else {
                                // Handle the case where snapshot.data is null
                                return const Center(
                                  child: Icon(
                                    Icons.error,
                                    // color: kTextColor,
                                    size: 60,
                                  ),
                                );
                              }
                            }),
                      );
                    });
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                final error = snapshot.error;
                Logger().w(error.toString());
                return const Center(
                  child: Text(
                    'Something went wrong, Unable to connect to Database',
                  ),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ],
    );
  }
}
