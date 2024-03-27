// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hemospectra/widgets/custom_button.dart';
import 'package:hemospectra/widgets/custom_text_form_field.dart';
import 'package:logger/logger.dart';

import '../exceptions/firebase_sign_in_exceptions.dart';
import '../exceptions/messaged_firebase_auth_exception.dart';
import '../models/size_config.dart';
import '../screens/authentication/forgot_password_screen.dart';
import '../services/authentification_service.dart';
import '../utils/constants.dart';
import 'async_progress_dialog.dart';
import 'snack_bar.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formkey = GlobalKey<FormState>();
  bool isPasswordVisible = false;

  final TextEditingController emailFieldController = TextEditingController();
  final TextEditingController passwordFieldController = TextEditingController();

  @override
  void dispose() {
    emailFieldController.dispose();
    passwordFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(screenPadding)),
        child: Column(
          children: [
            buildEmailFormField(),
            SizedBox(height: getProportionateScreenHeight(30)),
            buildPasswordFormField(),
            SizedBox(height: getProportionateScreenHeight(30)),
            buildForgotPasswordWidget(context),
            SizedBox(height: getProportionateScreenHeight(30)),
            CustomButton(
              text: 'Sign In',
              onPressed: signInButtonCallback,
            ),
          ],
        ),
      ),
    );
  }

  Row buildForgotPasswordWidget(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ForgotPasswordScreen(),
                ));
          },
          child: const Text(
            'Forgot Password',
            style: TextStyle(
              decoration: TextDecoration.underline,
            ),
          ),
        )
      ],
    );
  }

  Widget buildPasswordFormField() {
    return CustomTextFormField(
      controller: passwordFieldController,
      obscureText: !isPasswordVisible,
      hintText: 'Enter password',
      labelText: 'Password',
      suffixIcon: GestureDetector(
        onTap: () {
          // Toggle the visibility of the password
          setState(() {
            isPasswordVisible = !isPasswordVisible;
          });
        },
        child: Icon(
          isPasswordVisible ? Icons.visibility : Icons.visibility_off,
        ),
      ),
      validator: (value) {
        if (passwordFieldController.text.isEmpty) {
          return AppStrings.getPassNullError(context);
        } else if (passwordFieldController.text.length < 8) {
          return AppStrings.getShortPassError(context);
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildEmailFormField() {
    return CustomTextFormField(
      controller: emailFieldController,
      keyboardType: TextInputType.emailAddress,
      hintText: 'Enter email',
      labelText: 'Email',
      suffixIcon: const Icon(
        Icons.mail,
      ),
      validator: (value) {
        if (emailFieldController.text.isEmpty) {
          return AppStrings.getEmailNullError(context);
        } else if (!emailValidatorRegExp.hasMatch(emailFieldController.text)) {
          return AppStrings.getInvalidEmailError(context);
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Future<void> signInButtonCallback() async {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      final AuthentificationService authService = AuthentificationService();
      bool signInStatus = false;
      String? snackbarMessage;
      try {
        final signInFuture = authService.signIn(
          context,
          email: emailFieldController.text.trim(),
          password: passwordFieldController.text.trim(),
        );
        //signInFuture.then((value) => signInStatus = value);
        signInStatus = await showDialog(
          context: context,
          builder: (context) {
            return AsyncProgressDialog(
              signInFuture,
              // message: Text(AppLocalizations.of(context)!.signInProcess),
              onError: (e) {
                snackbarMessage = e.toString();
              },
            );
          },
        );
        if (signInStatus == true) {
          snackbarMessage = 'Signed In Successfully';
        } else {
          if (snackbarMessage == null) {
            throw FirebaseSignInAuthUnknownReasonFailure(context);
          } else {
            throw FirebaseSignInAuthUnknownReasonFailure(context,
                message: snackbarMessage!);
          }
        }
      } on MessagedFirebaseAuthException catch (e) {
        snackbarMessage = e.message;
      } catch (e) {
        // snackbarMessage = e.toString();
      } finally {
        Logger().i(snackbarMessage);
        ShowSnackBar().showSnackBar(context, snackbarMessage!);
      }
    }
  }
}
