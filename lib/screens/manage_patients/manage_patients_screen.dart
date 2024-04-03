// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hemospectra/models/patient.dart';
import 'package:hemospectra/screens/patient_details/patient_details_screen.dart';
import 'package:hemospectra/widgets/patient_short_detail_card.dart';
import 'package:logger/logger.dart';

import '../../models/size_config.dart';
import '../../services/data_streams/users_patients_streams.dart';
import '../../services/database/patient_database_helper.dart';
import '../../services/firestore_files_access/firestore_files_access_service.dart';
import '../../utils/constants.dart';
import '../../widgets/show_confirmation_dialog.dart';
import '../../widgets/snack_bar.dart';
import 'edit_patient_screen.dart';

class ManagePatientsScreen extends StatefulWidget {
  @override
  _ManagePatientsScreenState createState() => _ManagePatientsScreenState();
}

class _ManagePatientsScreenState extends State<ManagePatientsScreen> {
  final UsersPatientsStream usersPatientsStream = UsersPatientsStream();

  @override
  void initState() {
    super.initState();
    usersPatientsStream.init();
  }

  @override
  void dispose() {
    super.dispose();
    usersPatientsStream.dispose();
  }

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
      ),
      body: RefreshIndicator(
        onRefresh: refreshPage,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(screenPadding)),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(height: getProportionateScreenHeight(20)),
                  Text("Your Patients", style: headingStyle),
                  const Text(
                    "Swipe LEFT to Edit, Swipe RIGHT to Delete",
                    style: TextStyle(fontSize: 12),
                  ),
                  SizedBox(height: getProportionateScreenHeight(10)),
                  SizedBox(
                    height: SizeConfig.screenHeight! * 0.7,
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
                              return buildPatientsCard(reversedIds[index]);
                            },
                          );
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                  SizedBox(height: getProportionateScreenHeight(60)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> refreshPage() {
    usersPatientsStream.reload();
    return Future<void>.value();
  }

  Widget buildPatientsCard(String patientId) {
    return FutureBuilder<Patient?>(
      future: PatientDatabaseHelper().getPatientWithID(patientId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: SizedBox());
        } else if (snapshot.hasError) {
          final error = snapshot.error;
          Logger().e(error);
          print(error);
          return  const Center(
            child: 
            Icon(
              Icons.error,
              // color: kTextColor,
              size: 60,
            ),
          );
        } else if (snapshot.hasData) {
          final patient = snapshot.data!;
          return buildPatientDismissible(patient);
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
      },
    );
  }

  Widget buildPatientDismissible(Patient patient) {
    return Dismissible(
      key: Key(patient.id),
      direction: DismissDirection.horizontal,
      background: buildDismissibleSecondaryBackground(),
      secondaryBackground: buildDismissiblePrimaryBackground(),
      dismissThresholds: const {
        DismissDirection.endToStart: 0.65,
        DismissDirection.startToEnd: 0.65,
      },
      child: PatientShortDetailCard(
        patientId: patient.id,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PatientDetailsScreen(
                patientId: patient.id,
              ),
            ),
          );
        },
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          bool confirmation = await showConfirmationDialog(
              context, "Are you sure to Delete Patient?");
          if (confirmation) {
            await performDeleteOperations(patient);
          }
          return confirmation;
        } else if (direction == DismissDirection.endToStart) {
          bool confirmation = await showConfirmationDialog(
              context, "Are you sure to Edit Patient?");
          if (confirmation) {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditPatientScreen(
                  patientToEdit: patient,
                ),
              ),
            );
          }
          return confirmation;
        }
        return false;
      },
      onDismissed: (direction) async {
        await refreshPage();
      },
    );
  }

  // Function to handle deletion operations
  Future<void> performDeleteOperations(Patient patient) async {
    for (int i = 0; i < patient.image!.length; i++) {
      String path =
          PatientDatabaseHelper().getPathForPatientImage(patient.id, i);
      await FirestoreFilesAccess().deleteFileFromPath(path);
    }

    bool patientInfoDeleted =
        await PatientDatabaseHelper().deleteUserPatient(patient.id);
    String snackbarMessage = patientInfoDeleted
        ? "Patient deleted successfully"
        : "Couldn't delete patient, please retry";

    Logger().i(snackbarMessage);
    ShowSnackBar().showSnackBar(context, snackbarMessage);

    await refreshPage();
  }

  Widget buildDismissiblePrimaryBackground() {
    return Container(
      padding: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        // color: Colors.green,
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(
            Icons.edit,
            // color: Colors.white,
          ),
          SizedBox(width: 4),
          Text(
            "Edit",
            style: TextStyle(
              // color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDismissibleSecondaryBackground() {
    return Container(
      padding: const EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Delete",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          SizedBox(width: 4),
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
