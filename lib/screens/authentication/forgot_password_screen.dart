import 'package:flutter/material.dart';

import '../../models/size_config.dart';
import '../../utils/constants.dart';
import '../../widgets/forgot_password_form.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: Navigator.of(context).pop,
        ),
      ),
      body: ListView(
      children: [
        SizedBox(height: SizeConfig.screenHeight! * 0.04),
                Text('Forgot Password',
                  style: headingStyle,
                ),
                const Text(
                  'Please enter the email address linked to your account',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.screenHeight! * 0.1),
                ForgotPasswordForm(),
      ]
    ),
    );
  }
}