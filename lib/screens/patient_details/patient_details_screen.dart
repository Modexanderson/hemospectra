import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hemospectra/models/patient.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../models/size_config.dart';
import '../../services/database/patient_database_helper.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_listtile.dart';
import '../../widgets/patient_image.dart';

class PatientDetailsScreen extends StatelessWidget {
  final String patientId;

  const PatientDetailsScreen({
    Key? key,
    required this.patientId,
  }) : super(key: key);

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
    return Scaffold(
      // backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: Navigator.of(context).pop,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(screenPadding)),
          child: FutureBuilder<Patient?>(
            future: PatientDatabaseHelper().getPatientWithID(patientId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final patient = snapshot.data;
                int age = _calculateAge(patient!.dateOfBirth!);
                return Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              PatientImage(patient: patient),
                              SizedBox(height: getProportionateScreenHeight(5)),
                              Text(
                                patient.fullName!,
                                style: const TextStyle(
                                    fontSize: 26, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(5)),
                    const Text(
                      'Patient Information',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // CustomListTile(
                    //   title: 'Name',
                    //   subtitle: profileData?['full_name'] ?? '',
                    // ),
                    CustomListTile(
                      title: 'Age',
                      subtitle: '$age' ?? '',
                    ),
                    CustomListTile(
                      title: 'Gender',
                      subtitle: patient.gender ?? '',
                    ),
                    CustomListTile(
                      title: 'Marital Status',
                      subtitle: patient.maritalStatus ?? '',
                    ),
                    CustomListTile(
                      title: 'Blood Group',
                      subtitle: patient.bloodGroup ?? '',
                    ),
                    CustomListTile(
                      title: 'Height',
                      subtitle: '${patient.height}cm' ?? '',
                    ),
                    CustomListTile(
                      title: 'Genotype',
                      subtitle: patient.genotype ?? '',
                    ),
                    CustomListTile(
                      title: 'Email',
                      subtitle: patient.email ?? '',
                    ),
                    CustomListTile(
                      title: 'Phone Number',
                      subtitle: patient.phone ?? '',
                    ),
                    CustomListTile(
                      title: 'Date of Birth',
                      subtitle: '${patient.dateOfBirth}' ?? '',
                    ),
                    CustomListTile(
                      title: 'Country',
                      subtitle: '${patient.country}' ?? '',
                    ),
                    CustomListTile(
                      title: 'State',
                      subtitle: '${patient.state}' ?? '',
                    ),
                    CustomListTile(
                      title: 'City',
                      subtitle: '${patient.city}' ?? '',
                    ),
                    SizedBox(height: getProportionateScreenHeight(5)),
                    const Text(
                      'Patient Diagnosis',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CustomListTile(
                      title: 'Diagnosis',
                      subtitle: patient.diagnosis ?? '',
                    ),
                    CustomListTile(
                      title: 'Date of Diagnosis',
                      subtitle: '${patient.diagnosisDate}' ?? '',
                    ),
                    CustomListTile(
                      title: 'Description',
                      subtitle: '${patient.description}' ?? '',
                    ),

                    SizedBox(height: getProportionateScreenHeight(5)),
                    SizedBox(
                      height: 200,
                      width: 100,
                      child: CachedNetworkImage(
                        imageUrl: patient.scannedImage ?? '',
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        imageBuilder: (context, imageProvider) => Container(
                          height: MediaQuery.of(context).size.height / 3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                10), // Adjust the value as needed
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                        // color: kPrimaryColor,
                        ));
              } else if (snapshot.hasError) {
                final error = snapshot.error.toString();
                Logger().e(error);
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
        ),
      ),
    );
  }
}
