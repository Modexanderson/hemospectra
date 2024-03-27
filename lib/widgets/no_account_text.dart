import 'package:flutter/material.dart';

import '../models/size_config.dart';
import '../screens/authentication/sign_up_screen.dart';

class NoAccountText extends StatelessWidget {
  const NoAccountText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account?",
          style: TextStyle(
            fontSize: getProportionateScreenWidth(16),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignUpScreen()));
          },
          child: Text(
            'Sign Up',
            style: TextStyle(
              decoration: TextDecoration.underline,
              fontSize: getProportionateScreenWidth(16),
              // color: kPrimaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
