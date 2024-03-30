// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../services/authentification_service.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/form_field_container.dart';

class EditProfileScreen extends StatefulWidget {
  final String userUid;
  final Map<String, dynamic> profileData;
  const EditProfileScreen(
      {required this.userUid, required this.profileData, super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // final _formKey = GlobalKey<FormState>();

  String userUid = AuthentificationService().currentUser.uid;

  final TextEditingController dobController = TextEditingController();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final List<String> genders = ['Male', 'Female', 'Other'];

  final List<String> roles = ['Role 1', 'Role 2', 'Role 3'];

  String? _selectedGender;

  String? _selectedRole;

  String? selectedCountry;

  String? selectedState;
  String? selectedCity;

  List<String> stateNames = [];

  DateTime? _selectedDate;

  Future<void> _updateProfile() async {
    final Map<String, dynamic> profileData = {
      'user_email': emailController.text,
      'phone': phoneNumberController.text,
      'full_name': nameController.text,
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

  @override
  void initState() {
    super.initState();
    // Set initial values for controllers
    nameController.text = widget.profileData['full_name'] ?? '';
    emailController.text = widget.profileData['user_email'] ?? '';
    phoneNumberController.text = widget.profileData['phone'] ?? '';
    dobController.text = widget.profileData['date_of_birth'] ?? '';
  }

  @override
  void dispose() {
    emailController.dispose();
    phoneNumberController.dispose();
    nameController.dispose();
    dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: Navigator.of(context).pop,
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  CustomTextFormField(
                    labelText: 'Name',
                    // initialValue: nameController.text,
                    hintText: 'Enter your name',
                    controller: nameController,
                  ),
                  FormFieldContainer(
                    label: 'Gender',
                    child: CustomDropdown(
                      hintText: widget.profileData['gender'] ??
                          (_selectedGender != null
                              ? _selectedGender!
                              : 'Select Gender'),
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
                    ),
                  ),
                  CustomTextFormField(
                    labelText: 'Email',
                    // initialValue: emailController.text,
                    hintText: 'Enter your email',
                    controller: emailController,
                  ),
                  CustomTextFormField(
                    labelText: 'Phone Number',
                    // initialValue: profileData['phone'] ?? '',
                    hintText: 'Enter your phone number',
                    keyboardType: TextInputType.phone,
                    controller: phoneNumberController,
                  ),
                  FormFieldContainer(
                    label: 'Date of Birth',
                    child: CustomDropdown(
                      hintText: widget.profileData['date_of_birth'] ??
                          (_selectedDate != null
                              ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                              : 'Select Date of Birth'),
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
                  const SizedBox(height: 20),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await _updateProfile();
                Navigator.pop(context);
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
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Save Changes'),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.save),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
