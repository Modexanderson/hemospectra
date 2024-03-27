import 'package:flutter/material.dart';

import '../models/size_config.dart';


// const kPrimaryColor = Colors.blue;
// const kPrimaryLightColor = Color(0xFFFFECDF);
// const kPrimaryGradientColor = LinearGradient(
//   begin: Alignment.topLeft,
//   end: Alignment.bottomRight,
//   colors: [Colors.blueAccent, Color(0xFFFF7643)],
// );
// const kSecondaryColor = Color(0xFF979797);
// const kTextColor = Color(0xFF757575);

// const kAnimationDuration = Duration(milliseconds: 200);

const double screenPadding = 10;

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);
class AppStrings {
  static String getEmailNullError(BuildContext context) {
    return 'Enter your email';
  }
  static String getInvalidEmailError(BuildContext context) {
    return 'Enter valid email';
  }

  static String getPassNullError(BuildContext context) {
    return 'Enter your password';
  }

  static String getShortPassError(BuildContext context) {
    return 'Password is too short';
  }

  static String getMatchPassError(BuildContext context) {
    return "Passwords don't match";
  }

  static String getFieldRequiredMessage(BuildContext context) {
    return 'This field is required';
  }
}

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: const BorderSide(color: Colors.grey),
  );
}
