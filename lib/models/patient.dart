import 'package:cloud_firestore/cloud_firestore.dart';

import 'model.dart';

class Patient extends Model {
  static const String image_key = "image";
  static const String scannedImage_key = "scanned_image";
  static const String fullName_key = 'full_name';
  static const String dateOfBirth_key = 'date_of_birth';
  static const String gender_key = 'gender';
  static const String maritalStatus_key = 'marital_status';
  static const String bloodGroup_key = 'blood_group';
  static const String height_key = 'height';
  static const String genotype_key = 'genotype';
  static const String email_key = 'email';
  static const String description_key = 'description';
  static const String country_key = 'country';
  static const String state_key = 'state';
  static const String city_key = 'city';
  static const String owner_key = "owner";
  static const String phone_key = "phone";
  static const String diagnosis_key = 'diagnosis';
  static const String diagnosis_date_key = 'diagnosis_date';

  String? image;
  String? scannedImage;
  String? fullName;
  DateTime? dateOfBirth;
  DateTime? diagnosisDate;
  String? gender;
  String? maritalStatus;
  String? bloodGroup;
  double? height;
  String? genotype;
  String? email;
  String? description;
  String? country;
  String? state;
  String? city;
  String owner;
  String? phone;
  String? diagnosis;

  Patient(
    String id, {
    this.image,
    this.scannedImage,
    this.fullName,
    this.dateOfBirth,
    this.diagnosisDate,
    this.gender,
    this.maritalStatus,
    this.bloodGroup,
    this.height,
    this.genotype,
    this.email,
    this.description,
    this.country,
    this.state,
    this.city,
    required this.owner,
    this.phone,
    this.diagnosis,
  }) : super(id);

  factory Patient.fromMap(Map<String, dynamic> map, {String? id}) {
    // if (map[SEARCH_TAGS_KEY] == null) {
    //   map[SEARCH_TAGS_KEY] = List<String>.empty();
    // }
    return Patient(
      id!,
      image: map[image_key], // Ensure this value is cast to String?
      scannedImage:
          map[scannedImage_key], // Ensure this value is cast to String?
      fullName: map[fullName_key],
      dateOfBirth: (map[dateOfBirth_key] as Timestamp).toDate(),
      diagnosisDate: (map[diagnosis_date_key] as Timestamp).toDate(),
      gender: map[gender_key],
      maritalStatus: map[maritalStatus_key],
      bloodGroup: map[bloodGroup_key],
      height: map[height_key],
      genotype: map[gender_key],
      email: map[email_key],
      description: map[description_key],
      country: map[country_key],
      state: map[state_key],
      city: map[city_key],
      owner: map[owner_key],
      phone: map[phone_key],
      diagnosis: map[diagnosis_key],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      image_key: image,
      scannedImage_key: scannedImage,
      fullName_key: fullName,
      dateOfBirth_key: dateOfBirth,
      diagnosis_date_key: diagnosisDate,
      gender_key: gender,
      maritalStatus_key: maritalStatus,
      bloodGroup_key: bloodGroup,
      height_key: height,
      genotype_key: genotype,
      email_key: email,
      description_key: description,
      country_key: country,
      state_key: state,
      city_key: city,
      owner_key: owner,
      phone_key: phone,
      diagnosis_key: diagnosis,
    };

    return map;
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    final map = <String, dynamic>{};
    if (image != null) map[image_key] = image;
    if (scannedImage != null) map[scannedImage_key] = scannedImage;
    if (fullName != null) map[fullName_key] = fullName;
    if (dateOfBirth != null) map[dateOfBirth_key] = dateOfBirth;
    if (diagnosisDate != null) map[diagnosis_date_key] = diagnosisDate;
    if (gender != null) map[gender_key] = gender;
    if (maritalStatus != null) map[maritalStatus_key] = maritalStatus;
    if (bloodGroup != null) map[bloodGroup_key] = bloodGroup;
    if (height != null) map[height_key] = height;
    if (genotype != null) map[genotype_key] = genotype;
    if (email != null) map[email_key] = email;
    if (description != null) map[description_key] = description;
    if (country != null) map[country_key] = country;
    if (state != null) map[state_key] = state;
    if (city != null) map[city_key] = city;
    if (owner != null) map[owner_key] = owner;
    if (phone != null) map[phone_key] = phone;
    if (diagnosis != null) map[diagnosis_key] = diagnosis;

    return map;
  }
}
