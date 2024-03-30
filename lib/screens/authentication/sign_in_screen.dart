import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:sign_in_button/sign_in_button.dart';

import '../../exceptions/firebase_sign_up_exception.dart';
import '../../exceptions/messaged_firebase_auth_exception.dart';
import '../../models/size_config.dart';
import '../../services/authentification_service.dart';
import '../../widgets/async_progress_dialog.dart';
import '../../widgets/no_account_text.dart';
import '../../widgets/sign_in_form.dart';
import '../../widgets/snack_bar.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  Future<void> signUpWithGoogleCallback(BuildContext context) async {
    final AuthentificationService authService = AuthentificationService();
    bool signUpStatus = false;
    String? snackbarMessage;
    try {
      final signUpFuture = authService.signUpWithGoogle(context);
      signUpFuture.then((value) {
        if (kDebugMode) {
          print('Value from signUpFuture: $value');
        }
        signUpStatus = value;
      });
      signUpStatus = await showDialog(
        context: context,
        builder: (context) {
          return AsyncProgressDialog(
            signUpFuture,
            // message: Text(AppLocalizations.of(context)!.signInProcess),
          );
        },
      );

      if (signUpStatus == true) {
      } else {
        throw FirebaseSignUpAuthUnknownReasonFailureException(context);
      }
    } on MessagedFirebaseAuthException catch (e) {
      ShowSnackBar().showSnackBar(context, e.message);
    } catch (e) {
      ShowSnackBar().showSnackBar(context, e.toString());
    } finally {
      Logger().i(snackbarMessage);
      ShowSnackBar().showSnackBar(context, snackbarMessage!);

      if (signUpStatus == true) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        
      ),
      body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            Text(
              'Welcome \nBack',
              style: TextStyle(
                fontSize: getProportionateScreenWidth(28),
                fontWeight: FontWeight.bold,
                height: 1.5,
              ),
            ),
            
            SizedBox(height: SizeConfig.screenHeight! * 0.01),
            SignInForm(),
            SizedBox(height: SizeConfig.screenHeight! * 0.02),
            const NoAccountText(),
            SizedBox(height: getProportionateScreenHeight(10)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width /
                      2.5, // Adjust the length of each line segment
                  color: Colors.grey, // Adjust the color as needed
                ),
                const SizedBox(
                    width: 5), // Adjust spacing between line and text
                const Text(
                  'OR',
                  style: TextStyle(
                    fontSize: 16, // Adjust the font size as needed
                  ),
                ),
                const SizedBox(
                    width: 5), // Adjust spacing between line and text
                Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width /
                      2.5, // Adjust the length of each line segment
                  color: Colors.grey, // Adjust the color as needed
                ),
              ],
            ),
            const SizedBox(height: 20),
            SignInButton(
              Buttons.google,
              text: 'Continue with Google',
              onPressed: () {
                signUpWithGoogleCallback(context);
              },
            ),
          ]),
    );
  }
}
