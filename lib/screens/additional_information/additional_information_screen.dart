// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';

import '../../models/size_config.dart';
import '../../services/authentification_service.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/form_field_container.dart';
import '../screens.dart';

class AdditionalInformationScreen extends StatefulWidget {
  const AdditionalInformationScreen({super.key});

  @override
  State<AdditionalInformationScreen> createState() =>
      _AdditionalInformationScreenState();
}

class _AdditionalInformationScreenState
    extends State<AdditionalInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  String userUid = AuthentificationService().currentUser.uid;

  final TextEditingController dobController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final List<String> genders = ['Male', 'Female', 'Other'];
  final List<String> roles = [
    'Pharmacist',
    'Medical Dr',
    'Nurse',
    'Community health agent'
  ];

  String? _selectedGender;
  String? _selectedRole;
  String? selectedCountry;
  String? selectedState;
  String? selectedCity;

  List<String> stateNames = [];

  Future<void> saveProfile() async {
    final Map<String, dynamic> profileData = {
      'full_name': fullNameController.text,
      'date_of_birth': dobController.text,
      'gender': _selectedGender,
      'country': selectedCountry,
      'state': selectedState,
      'city': selectedCity,
      'role': _selectedRole,
    };

    try {
      // Get current user ID or any identifier
      // final userId = 'user_id_example';
      // Save the profile data to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .update(profileData);
      print('Profile data saved to Firestore successfully');
    } catch (e) {
      print('Error saving profile data to Firestore: $e');
      // Handle error as needed
    }
  }

  DateTime? _selectedDate;

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: _selectedDate,
  //     firstDate: DateTime(1900),
  //     lastDate: DateTime.now(),
  //   );
  //   if (picked != null && picked != _selectedDate) {
  //     setState(() {
  //       _selectedDate = picked;
  //       dobController.text =
  //           _selectedDate.toString(); // Update text field with selected date
  //     });
  //     // Save the selected date to Firestore
  //     // await saveDateOfBirthToFirestore(_selectedDate);
  //   }
  // }

  @override
  void dispose() {
    fullNameController.dispose();
    dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Add additional \nInfromation',
              style: TextStyle(
                fontSize: getProportionateScreenWidth(28),
                fontWeight: FontWeight.bold,
                height: 1.5,
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  CustomTextFormField(
                    hintText: 'Fullname',
                    controller: fullNameController,
                  ),
                  FormFieldContainer(
                    label: 'Date of Birth',
                    child: CustomDropdown(
                      hintText: _selectedDate != null
                          ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                          : 'Select Date of Birth',
                      onPressed: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _selectedDate = pickedDate;
                            dobController.text =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                          });
                        }
                      },
                    ),
                  ),
                  FormFieldContainer(
                      label: 'Gender',
                      child: CustomDropdown(
                        hintText: _selectedGender != null
                            ? _selectedGender!
                            : 'Select Gender',
                        onPressed: () {
                          // Call your function to handle gender selection
                          // For example, show a modal bottom sheet with gender options
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: genders.map((gender) {
                                  return ListTile(
                                    title: Text(gender),
                                    onTap: () {
                                      // Update the selected gender and close the bottom sheet
                                      setState(() {
                                        _selectedGender = gender;
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  );
                                }).toList(),
                              );
                            },
                          );
                        },
                      )),
                  const SizedBox(height: 16.0),
                  FormFieldContainer(
                    label: 'Region',
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.white),
                      child: SelectState(
                        // style: TextStyle(backgroundColor: ),
                        onCountryChanged: (value) {
                          setState(() {
                            selectedCountry = value;
                            // Reset selected state when country changes
                            selectedState = null;
                          });
                        },
                        onStateChanged: (value) {
                          setState(() {
                            selectedState = value;
                          });
                        },
                        onCityChanged: (value) {
                          setState(() {
                            selectedCity = value;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  FormFieldContainer(
                      label: 'Role Selection',
                      child: CustomDropdown(
                        hintText: _selectedRole != null
                            ? _selectedRole!
                            : 'Select Role',
                        onPressed: () {
                          // Call your function to handle role selection
                          // For example, show a modal bottom sheet with role options
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: roles.map((role) {
                                  return ListTile(
                                    title: Text(role),
                                    onTap: () {
                                      // Update the selected role and close the bottom sheet
                                      setState(() {
                                        _selectedRole = role;
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  );
                                }).toList(),
                              );
                            },
                          );
                        },
                      )),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await saveProfile();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Screens(),
                  ),
                );
                // Implement edit profile functionality
              },
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                fixedSize: MaterialStateProperty.all(const Size.fromWidth(300)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
              child: const Text('Complete Registration'),
            ),
          ],
        ),
      ),
    );
  }
}
