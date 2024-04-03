// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:flutter/material.dart';
import 'package:hemospectra/services/database/user_database_helper.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../../services/authentification_service.dart';
import '../../widgets/async_progress_dialog.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/form_field_container.dart';
import '../../widgets/snack_bar.dart';

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

  DateTime? _selectedDate;

  Future<void> updateProfileButtonCallback() async {
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

    String? userId;
    String? snackbarMessage;

    try {
      final usertUpdateFuture =
          UserDatabaseHelper().updateUserProfile(profileData);
      usertUpdateFuture.then((value) {
        userId = value;
      });
      await showDialog(
        context: context,
        builder: (context) {
          return AsyncProgressDialog(
            usertUpdateFuture,
            progress: const CircularProgressIndicator(),
          );
        },
      );
      if (userId != null) {
        snackbarMessage = "Patient Info updated successfully";
      } else {
        throw "Couldn't update patient info due to some unknown issue";
      }
      snackbarMessage = 'Profile data saved to Firestore successfully';
    } on FirebaseException catch (e) {
      Logger().w("Firebase Exception: $e");
      snackbarMessage = "Something went wrong";
    } catch (e) {
      Logger().w("Unknown Exception: $e");
      snackbarMessage = e.toString();
    } finally {
      Logger().i(snackbarMessage);
      ShowSnackBar().showSnackBar(context, snackbarMessage!);
    }
    Navigator.pop(context);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // Set initial values for controllers
    nameController.text = widget.profileData['full_name'];
    emailController.text = widget.profileData['user_email'];
    phoneNumberController.text = widget.profileData['phone'];
    dobController.text = widget.profileData['date_of_birth'];
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
                      label: 'Role Selection',
                      child: CustomDropdown(
                        hintText: widget.profileData['role'] ??
                            (_selectedRole != null
                                ? _selectedRole!
                                : 'Select Role'),
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
              onPressed: () {
                updateProfileButtonCallback();

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
