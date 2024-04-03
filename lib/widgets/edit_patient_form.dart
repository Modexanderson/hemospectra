// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hemospectra/models/patient.dart';
import 'package:hemospectra/services/database/patient_database_helper.dart';
import 'package:hemospectra/widgets/custom_text_form_field.dart';
import 'package:hemospectra/widgets/snack_bar.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../exceptions/local_files_handling_exception.dart';
import '../models/size_config.dart';
import '../screens/provider_models/patient_details.dart';
import '../services/authentification_service.dart';
import '../services/firestore_files_access/firestore_files_access_service.dart';
import '../services/local_files_access/local_files_access_service.dart';
import 'async_progress_dialog.dart';
import 'custom_button.dart';
import 'custom_drop_down.dart';
import 'form_field_container.dart';

class EditPatientForm extends StatefulWidget {
  final Patient? patient;
  const EditPatientForm({
    Key? key,
    this.patient,
  }) : super(key: key);

  @override
  _EditPatientFormState createState() => _EditPatientFormState();
}

class _EditPatientFormState extends State<EditPatientForm> {
  final _basicDetailsFormKey = GlobalKey<FormState>();
  final _describePatientFormKey = GlobalKey<FormState>();
  // final _tagStateKey = GlobalKey<TagsState>();

  final TextEditingController fullNameFieldController = TextEditingController();
  final TextEditingController dobFieldController = TextEditingController();
  final TextEditingController diagnosisDateFieldController =
      TextEditingController();

  final TextEditingController phoneNumberFieldController =
      TextEditingController();
  final TextEditingController emailFieldController = TextEditingController();
  final TextEditingController desciptionFieldController =
      TextEditingController();

  final List<String> genders = ['Male', 'Female', 'Other'];
  final List<String> diagnosis = [
    'No disease detected',
    'Malaria',
    'Typhoid',
    'Tuberculosis',
    'Diabetes',
    'HIV'
  ];

  String? _selectedGender;

  String? _selectedDIagnosis;

  String? selectedCountry;

  String? selectedState;
  String? selectedCity;

  List<String> stateNames = [];

  DateTime? _selectedDateOfBirth;
  DateTime _selectedDiagnosisDate = DateTime.now();
  String uid = AuthentificationService().currentUser.uid;

  bool newPatient = true;
  Patient? patient;

  @override
  void dispose() {
    fullNameFieldController.dispose();
    dobFieldController.dispose();
    diagnosisDateFieldController.dispose();
    phoneNumberFieldController.dispose();
    emailFieldController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.patient == null) {
      patient = Patient(owner: uid, '');
      newPatient = true;
    } else {
      patient = widget.patient;
      newPatient = false;
      final patientDetails =
          Provider.of<PatientDetails>(context, listen: false);
      patientDetails.selectedImage = CustomImage(
        imgType: ImageType.network,
        path: widget.patient!.image!, // Assuming this is a single image path
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final column = Column(
      children: [
        buildUploadImagesTile(context),
        SizedBox(height: getProportionateScreenHeight(10)),
        buildBasicDetailsTile(context),
        SizedBox(height: getProportionateScreenHeight(10)),
        buildDescribePatientTile(context),
        SizedBox(height: getProportionateScreenHeight(10)),
        CustomButton(
            text: "Save Patient",
            onPressed: () {
              savePatientButtonCallback(context);
            }),
        SizedBox(height: getProportionateScreenHeight(10)),
      ],
    );
    if (newPatient == false) {
      fullNameFieldController.text = patient!.fullName.toString();
      dobFieldController.text = patient!.dateOfBirth.toString();
      phoneNumberFieldController.text = patient!.phone.toString();
      emailFieldController.text = patient!.email.toString();
      desciptionFieldController.text = patient!.description!;
    }
    return column;
  }

  Widget buildBasicDetailsTile(BuildContext context) {
    return Form(
      key: _basicDetailsFormKey,
      child: ExpansionTile(
        // iconColor: kPrimaryColor,
        // textColor: kPrimaryColor,
        maintainState: true,
        title: Text(
          "Patient Basic Details",
          style: Theme.of(context).textTheme.headline6,
        ),
        leading: const Icon(
          Icons.shop,
        ),
        childrenPadding:
            EdgeInsets.symmetric(vertical: getProportionateScreenHeight(20)),
        children: [
          buildFullNameField(),
          SizedBox(height: getProportionateScreenHeight(20)),
          buildEmailField(),
          SizedBox(height: getProportionateScreenHeight(20)),
          buildPhoneNumberField(),
          SizedBox(height: getProportionateScreenHeight(20)),
          buildGenderField(),
          SizedBox(height: getProportionateScreenHeight(20)),
          buildDateOfBirthField(),
          SizedBox(height: getProportionateScreenHeight(20)),
        ],
      ),
    );
  }

  bool validateBasicDetailsForm() {
    if (_basicDetailsFormKey.currentState!.validate()) {
      _basicDetailsFormKey.currentState!.save();
      patient?.fullName = fullNameFieldController.text;
      patient?.email = emailFieldController.text;
      patient?.phone = phoneNumberFieldController.text;
      patient?.gender = _selectedGender;
      patient?.dateOfBirth = _selectedDateOfBirth;

      return true;
    }
    return false;
  }

  Widget buildDescribePatientTile(BuildContext context) {
    return Form(
      key: _describePatientFormKey,
      child: ExpansionTile(
        // iconColor: kPrimaryColor,
        // textColor: kPrimaryColor,
        maintainState: true,
        title: Text(
          "Describe Patient",
          style: Theme.of(context).textTheme.headline6,
        ),
        leading: const Icon(
          Icons.description,
        ),
        childrenPadding:
            EdgeInsets.symmetric(vertical: getProportionateScreenHeight(20)),
        children: [
          buildDiagnosisField(),
          SizedBox(height: getProportionateScreenHeight(20)),
          buildDiagnosisDateField(),
          SizedBox(height: getProportionateScreenHeight(20)),
          buildLocationField(),
          SizedBox(height: getProportionateScreenHeight(20)),
          buildDescriptionField(),
          SizedBox(height: getProportionateScreenHeight(20)),
        ],
      ),
    );
  }

  bool validateDescribePatientForm() {
    if (_describePatientFormKey.currentState!.validate()) {
      _describePatientFormKey.currentState!.save();
      patient?.diagnosis = _selectedDIagnosis;
      patient?.diagnosisDate = _selectedDiagnosisDate;
      patient?.country = selectedCountry;
      patient?.state = selectedState;
      patient?.city = selectedCity;
      patient?.description = desciptionFieldController.text;
      return true;
    }
    return false;
  }

  Widget buildUploadImagesTile(BuildContext context) {
    return ExpansionTile(
      // iconColor: kPrimaryColor,
      // textColor: kPrimaryColor,
      title: Text(
        "Upload Image",
        style: Theme.of(context).textTheme.titleLarge,
      ),
      leading: const Icon(Icons.image),
      childrenPadding:
          EdgeInsets.symmetric(vertical: getProportionateScreenHeight(20)),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: IconButton(
              icon: const Icon(
                Icons.add_a_photo,
              ),
              // color: kTextColor,
              onPressed: () {
                addImageButtonCallback();
              }),
        ),
        Consumer<PatientDetails>(
          builder: (context, patientDetails, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: GestureDetector(
                      onTap: () {
                        // Handle tap on the selected image
                        addImageButtonCallback(); // Assuming index 0 for the single image
                      },
                      child: patientDetails.selectedImage != null
                          ? (patientDetails.selectedImage!.imgType ==
                                  ImageType.local
                              ? Image.memory(
                                  File(patientDetails.selectedImage!.path)
                                      .readAsBytesSync())
                              : CachedNetworkImage(
                                  imageUrl: patientDetails.selectedImage!.path,
                                  placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                  fit: BoxFit.contain, // Adjust the image's fit
                                ))
                          : const Placeholder(), // Placeholder widget if no image is selected
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      patientDetails.clearSelectedImage();
                    },
                    icon: const Icon(Icons.cancel_outlined))
              ],
            );
          },
        ),
      ],
    );
  }

  Widget buildFullNameField() {
    return CustomTextFormField(
      controller: fullNameFieldController,
      keyboardType: TextInputType.name,
      hintText: 'e.g., John Smith',
      labelText: 'Patient Full Name',
      validator: (_) {
        if (fullNameFieldController.text.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildEmailField() {
    return CustomTextFormField(
      controller: emailFieldController,
      keyboardType: TextInputType.name,
      hintText: 'e.g., johnsmith@gmail.com',
      labelText: 'Patient Email',
      validator: (_) {
        if (emailFieldController.text.isEmpty) {
          return 'This Field is required';
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildPhoneNumberField() {
    return CustomTextFormField(
      labelText: 'Phone Number',
      // initialValue: profileData['phone'] ?? '',
      hintText: 'e.g., +234 999 999 999',
      keyboardType: TextInputType.phone,
      controller: phoneNumberFieldController,
    );
  }

  Widget buildDescriptionField() {
    return CustomTextFormField(
      controller: desciptionFieldController,
      keyboardType: TextInputType.multiline,
      hintText: 'e.g., This Patient has been diagnosed with fever',
      labelText: "Description",
      validator: (_) {
        if (desciptionFieldController.text.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLines: null,
    );
  }

  Widget buildDateOfBirthField() {
    return FormFieldContainer(
      label: 'Date of Birth',
      child: CustomDropdown(
        hintText: _selectedDateOfBirth != null
            ? DateFormat('yyyy-MM-dd').format(_selectedDateOfBirth!)
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
              _selectedDateOfBirth = pickedDate;
              dobFieldController.text =
                  DateFormat('yyyy-MM-dd').format(pickedDate);
            });
          }
        },
      ),
    );
  }

  Widget buildDiagnosisDateField() {
    return FormFieldContainer(
      label: 'Date of DIagnosis',
      child: CustomDropdown(
        hintText: _selectedDiagnosisDate.toString(),
        onPressed: () async {
          final DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (pickedDate != null) {
            setState(() {
              _selectedDiagnosisDate = pickedDate;
              diagnosisDateFieldController.text =
                  DateFormat('yyyy-MM-dd').format(pickedDate);
            });
          }
        },
      ),
    );
  }

  Widget buildLocationField() {
    return FormFieldContainer(
      label: 'Region',
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0), color: Colors.white),
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
    );
  }

  Widget buildGenderField() {
    return FormFieldContainer(
      label: 'Gender',
      child: CustomDropdown(
        hintText: _selectedGender != null ? _selectedGender! : 'Select Gender',
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
    );
  }

  Widget buildDiagnosisField() {
    return FormFieldContainer(
      label: 'DIagnosis',
      child: CustomDropdown(
        hintText: _selectedDIagnosis != null
            ? _selectedDIagnosis!
            : 'Select Diagnosis',
        onPressed: () {
          // Call your function to handle gender selection
          // For example, show a modal bottom sheet with gender options
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: diagnosis.map((diagnosis) {
                  return ListTile(
                    title: Text(diagnosis),
                    onTap: () {
                      // Update the selected gender and close the bottom sheet
                      setState(() {
                        _selectedDIagnosis = diagnosis;
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
    );
  }

  Future<void> savePatientButtonCallback(BuildContext context) async {
    if (validateBasicDetailsForm() == false) {
      ShowSnackBar().showSnackBar(context, 'Erros in Basic Details Form');

      return;
    }
    if (validateDescribePatientForm() == false) {
      ShowSnackBar().showSnackBar(context, 'Errors in Describe Patient Form');

      return;
    }
    final patientDetails = Provider.of<PatientDetails>(context, listen: false);
    if (patientDetails.selectedImage == null) {
      ShowSnackBar().showSnackBar(context, 'Upload One Image of Patient');

      return;
    }

    String? patientId;
    String? snackbarMessage;
    try {
      final patientUploadFuture = newPatient
          ? PatientDatabaseHelper().addUsersPatient(patient!)
          : PatientDatabaseHelper().updateUsersPatient(patient!);
      patientUploadFuture.then((value) {
        patientId = value;
      });
      await showDialog(
        context: context,
        builder: (context) {
          return AsyncProgressDialog(
            patientUploadFuture,
            progress: const CircularProgressIndicator(),
          );
        },
      );
      if (patientId != null) {
        snackbarMessage = "Patient Info updated successfully";
      } else {
        throw "Couldn't update patient info due to some unknown issue";
      }
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
    if (patientId == null) return;
    bool allImagesUploaded = false;
    try {
      allImagesUploaded = await uploadPatientImage(patientId!);
      if (allImagesUploaded == true) {
        snackbarMessage = "All images uploaded successfully";
      } else {
        throw "Some images couldn't be uploaded, please try again";
      }
    } on FirebaseException catch (e) {
      Logger().w("Firebase Exception: $e");
      snackbarMessage = "Something went wrong";
    } catch (e) {
      Logger().w("Unknown Exception: $e");
      snackbarMessage = "Something went wrong";
    } finally {
      Logger().i(snackbarMessage);
      ShowSnackBar().showSnackBar(context, snackbarMessage!);
    }
    String? downloadUrl;
    if (patientDetails.selectedImage != null &&
        patientDetails.selectedImage!.imgType == ImageType.network) {
      downloadUrl = patientDetails.selectedImage!.path;
    }
    bool patientFinalizeUpdate = false;
    try {
      final updatePatientFuture =
          PatientDatabaseHelper().updatePatientsImage(patientId!, downloadUrl!);
      patientFinalizeUpdate = await showDialog(
        context: context,
        builder: (context) {
          return AsyncProgressDialog(
            updatePatientFuture,
          );
        },
      );
      if (patientFinalizeUpdate == true) {
        snackbarMessage = "Patient uploaded successfully";
      } else {
        throw "Couldn't upload patient properly, please retry";
      }
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
  }

  Future<bool> uploadPatientImage(String patientId) async {
    bool imageUpdated = false;
    final patientDetails = Provider.of<PatientDetails>(context, listen: false);

    if (patientDetails.selectedImage != null &&
        patientDetails.selectedImage!.imgType == ImageType.local) {
      String? downloadUrl;

      try {
        final imgUploadFuture = FirestoreFilesAccess().uploadFileToPath(
          File(patientDetails.selectedImage!.path),
          PatientDatabaseHelper().getPathForPatientImage(patientId, 0),
        );
        downloadUrl = await showDialog(
          context: context,
          builder: (context) {
            return AsyncProgressDialog(
              imgUploadFuture,
              progress: const CircularProgressIndicator(),
              // message: Text("Uploading Image"),
            );
          },
        );
      } on FirebaseException catch (e) {
        Logger().w("Firebase Exception: $e");
      } catch (e) {
        Logger().w("Firebase Exception: $e");
      }

      if (downloadUrl != null) {
        patientDetails.selectedImage = CustomImage(
          imgType: ImageType.network,
          path: downloadUrl,
        );
        imageUpdated = true;
      } else {
        ShowSnackBar()
            .showSnackBar(context, "Couldn't upload image due to some issue");
      }
    }

    return imageUpdated;
  }

  Future<void> addImageButtonCallback() async {
    final patientDetails = Provider.of<PatientDetails>(context, listen: false);

    // Check if maximum number of images has been reached
    if (patientDetails.selectedImage != null) {
      ShowSnackBar().showSnackBar(context, "Max 1 image can be uploaded");

      return;
    }

    String? path;
    String? snackbarMessage;
    try {
      path = await choseImageFromLocalFiles(context);
    } on LocalFileHandlingException catch (e) {
      Logger().i("Local File Handling Exception: $e");
      snackbarMessage = e.toString();
    } catch (e) {
      Logger().i("Unknown Exception: $e");
      snackbarMessage = e.toString();
    } finally {
      if (snackbarMessage != null) {
        Logger().i(snackbarMessage);
        ShowSnackBar().showSnackBar(context, snackbarMessage);
      }
    }

    if (path != null) {
      patientDetails.selectedImage = CustomImage(
        imgType: ImageType.local,
        path: path,
      );
    }
  }
}
