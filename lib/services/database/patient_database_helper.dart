import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hemospectra/models/patient.dart';

import '../authentification_service.dart';

class PatientDatabaseHelper {
  static const String PATIENTS_COLLECTION_NAME = "patients";
  static const String REVIEWS_COLLECTOIN_NAME = "reviews";

  PatientDatabaseHelper._privateConstructor();
  static PatientDatabaseHelper _instance =
      PatientDatabaseHelper._privateConstructor();
  factory PatientDatabaseHelper() {
    return _instance;
  }
  FirebaseFirestore? _firebaseFirestore;
  FirebaseFirestore get firestore {
    if (_firebaseFirestore == null) {
      _firebaseFirestore = FirebaseFirestore.instance;
    }
    return _firebaseFirestore!;
  }

  Future<Patient?> getPatientWithID(String patientId) async {
    final docSnapshot = await firestore
        .collection(PATIENTS_COLLECTION_NAME)
        .doc(patientId)
        .get();

    if (docSnapshot.exists) {
      return Patient.fromMap(docSnapshot.data() ?? {}, id: docSnapshot.id);
    }
    // Return null if the document does not exist
    return Patient.fromMap(docSnapshot.data() ?? {}, id: docSnapshot.id);
  }

  Future<String> addUsersPatient(Patient patient) async {
    String uid = AuthentificationService().currentUser.uid;
    // final patientMap = patient.toMap();
    patient.owner = uid;

    final patientsCollectionReference =
        firestore.collection(PATIENTS_COLLECTION_NAME);
    final docRef = await patientsCollectionReference.add(patient.toMap());

    return docRef.id;
  }


  Stream<Map<String, int>> fetchDiagnosisForUserPatients(String userId) {
  StreamController<Map<String, int>> controller = StreamController();

  Future<void> fetchData() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference patientsCollection = firestore.collection('patients');

      QuerySnapshot querySnapshot = await patientsCollection
          .where('owner', isEqualTo: userId)
          .get();

      Map<String, int> diagnosisCountMap = {};

      querySnapshot.docs.forEach((doc) {
        String? diagnosis = doc['diagnosis'];
        if (diagnosis != null && diagnosis.isNotEmpty) {
          if (diagnosisCountMap.containsKey(diagnosis)) {
            diagnosisCountMap[diagnosis] = diagnosisCountMap[diagnosis]! + 1;
          } else {
            diagnosisCountMap[diagnosis] = 1;
          }
        }
      });

      controller.add(diagnosisCountMap);
      controller.close();
    } catch (e) {
      controller.addError(e);
    }
  }

  fetchData();
  return controller.stream;
}


  Future<bool> deleteUserPatient(String patientId) async {
    final patientsCollectionReference =
        firestore.collection(PATIENTS_COLLECTION_NAME);
    await patientsCollectionReference.doc(patientId).delete();
    return true;
  }

  Future<String> updateUsersPatient(Patient patient) async {
    final patientMap = patient.toUpdateMap();
    final patientsCollectionReference =
        firestore.collection(PATIENTS_COLLECTION_NAME);
    final docRef = patientsCollectionReference.doc(patient.id);
    await docRef.update(patientMap);

    return docRef.id;
  }

  Future<List<Patient>> getUsersPatientsList() async {
    String uid = AuthentificationService().currentUser.uid;
    final querySnapshot = await firestore
        .collection(PATIENTS_COLLECTION_NAME)
        .where(Patient.owner_key, isEqualTo: uid)
        .get();
    List<Patient> usersPatients = [];
    querySnapshot.docs.forEach((doc) {
      usersPatients.add(Patient.fromMap(doc.data(), id: doc.id));
    });
    return usersPatients;
  }

  Future<List<String>> get usersPatientsList async {
    String uid = AuthentificationService().currentUser.uid;
    final patientsCollectionReference =
        firestore.collection(PATIENTS_COLLECTION_NAME);
    final querySnapshot = await patientsCollectionReference
        .where(Patient.owner_key, isEqualTo: uid)
        .get();
    List<String> usersPatients = [];
    querySnapshot.docs.forEach((doc) {
      usersPatients.add(doc.id);
    });
    return usersPatients;
  }

  Future<List<String>> get allPatientsList async {
    final patients = await firestore.collection(PATIENTS_COLLECTION_NAME).get();
    List<String> patientsId = [];
    for (final patient in patients.docs) {
      final id = patient.id;
      patientsId.add(id);
    }
    return patientsId;
  }

  Future<bool> updatePatientsImage(String patientId, String imgUrl) async {
    String uid = AuthentificationService().currentUser.uid;
    final Patient updatePatient = Patient(
      patientId,
      image: imgUrl,
      owner: uid,
    );
    final docRef =
        firestore.collection(PATIENTS_COLLECTION_NAME).doc(patientId);
    await docRef.update(updatePatient.toUpdateMap());
    return true;
  }

  String getPathForPatientImage(String id, int index) {
    String path = "patients/image/$id";
    return path + "_$index";
  }
}
