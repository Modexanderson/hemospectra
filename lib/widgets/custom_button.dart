import 'package:flutter/material.dart';

import '../models/size_config.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  const CustomButton({required this.text, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    double doubleValue =
        MediaQuery.of(context).orientation == Orientation.landscape
            ? 150.0 // Set your double value for landscape
            : 56.0;
    return SizedBox(
      width: double.infinity,
      height: getProportionateScreenHeight(doubleValue),
      child: ElevatedButton(
        onPressed: () {
          onPressed();
          // Implement edit profile functionality
        },
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            fixedSize: MaterialStateProperty.all(const Size.fromWidth(300)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(5.0), // Adjust the value as needed
              ),
            )),
        child: Text(text),
      ),
    );
  }
}
