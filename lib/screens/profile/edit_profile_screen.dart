import 'package:flutter/material.dart';

import '../../widgets/custom_text_form_field.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          // const CustomTextFormField(
          //   labelText: 'Name',
          //     initialValue: 'John Doe',
          //     hintText: 'Enter your name',
          //   ),
          //   const CustomTextFormField(
          //     labelText: 'Gender',
          //     initialValue: 'Male',
          //     hintText: 'Enter your gender',
          //   ),
          //   const CustomTextFormField(
          //     labelText: 'Email',
          //     initialValue: 'johndoe@example.com',
          //     hintText: 'Enter your email',
          //   ),
          //   const CustomTextFormField(
          //     labelText: 'Phone Number',
          //     initialValue: '+1234567890',
          //     hintText: 'Enter your phone number',
          //   ),
          //   const CustomTextFormField(
          //     labelText: 'Date of Birth',
          //     initialValue: 'January 1, 1990',
          //     hintText: 'Enter your date of birth',
          //   ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Implement edit profile functionality
            },
            style: ButtonStyle(
              foregroundColor:
                  MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.blue),
              fixedSize: MaterialStateProperty.all(
                  const Size.fromWidth(300)),
              shape: MaterialStateProperty.all<
                  RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      5.0),
                ),
              ),
            ),
            child: const Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Text('Save Changes'),
                const SizedBox(
                  width: 10,
                ),
                Icon(Icons.save),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: EditProfileScreen(),
  ));
}
