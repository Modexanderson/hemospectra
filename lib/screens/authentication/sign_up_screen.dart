import 'package:flutter/material.dart';

import '../../models/size_config.dart';
import '../../utils/constants.dart';
import '../../widgets/sign_up_form.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
      body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            SizedBox(height: SizeConfig.screenHeight! * 0.02),
            Text(
              'Create a new \naccount',
              style: headingStyle,
            ),
            SizedBox(height: SizeConfig.screenHeight! * 0.07),
            const SignUpForm(),
            SizedBox(height: getProportionateScreenHeight(20)),
          ]),
    );
  }
}
