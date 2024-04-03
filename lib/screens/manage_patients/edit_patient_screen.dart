
import 'package:flutter/material.dart';
import 'package:hemospectra/models/patient.dart';
import 'package:provider/provider.dart';

import '../../models/size_config.dart';
import '../../utils/constants.dart';
import '../../widgets/edit_patient_form.dart';

class EditPatientScreen extends StatelessWidget {
  final Patient? patientToEdit;

  const EditPatientScreen({Key? key, required this.patientToEdit})
      : super(key: key);
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
      body: SingleChildScrollView(
        
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(screenPadding)),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(height: getProportionateScreenHeight(10)),
                Text(
                  "Fill Patient Details",
                  style: headingStyle,
                ),
                SizedBox(height: getProportionateScreenHeight(30)),
                EditPatientForm(patient: patientToEdit),
                SizedBox(height: getProportionateScreenHeight(30)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
