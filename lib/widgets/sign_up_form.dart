// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:hemospectra/widgets/custom_text_form_field.dart';
import 'package:logger/logger.dart';

import '../exceptions/firebase_sign_up_exception.dart';
import '../exceptions/messaged_firebase_auth_exception.dart';
import '../models/size_config.dart';
import '../screens/additional_information/additional_information_screen.dart';
import '../services/authentification_service.dart';
import '../utils/constants.dart';
import 'async_progress_dialog.dart';
import 'custom_button.dart';
import 'snack_bar.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool isPasswordVisible = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailFieldController = TextEditingController();
  final TextEditingController passwordFieldController = TextEditingController();
  final TextEditingController confirmPasswordFieldController =
      TextEditingController();

  @override
  void dispose() {
    emailFieldController.dispose();
    passwordFieldController.dispose();
    confirmPasswordFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          buildPasswordFormField(),
          buildConfirmPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(40)),
          CustomButton(
            text: 'Sign Up',
            onPressed: signUpButtonCallback,
          ),
        ],
      ),
    );
  }

  Widget buildConfirmPasswordFormField() {
    return CustomTextFormField(
      controller: confirmPasswordFieldController,
      obscureText: !isPasswordVisible,
      hintText: 'Re-enter password',
      suffixIcon: GestureDetector(
        onTap: () {
          // Toggle the visibility of the password
          setState(() {
            isPasswordVisible = !isPasswordVisible;
          });
        },
        child: Icon(
          isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        ),
      ),
      validator: (value) {
        if (confirmPasswordFieldController.text.isEmpty) {
          return AppStrings.getPassNullError(context);
        } else if (confirmPasswordFieldController.text !=
            passwordFieldController.text) {
          return AppStrings.getMatchPassError(context);
        } else if (confirmPasswordFieldController.text.length < 8) {
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
      hintText: 'Email',
      suffixIcon: const Icon(Icons.mail_outline),
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

  Widget buildPasswordFormField() {
    return CustomTextFormField(
      controller: passwordFieldController,
      obscureText: !isPasswordVisible,
      hintText: 'Password',
      suffixIcon: GestureDetector(
        onTap: () {
          // Toggle the visibility of the password
          setState(() {
            isPasswordVisible = !isPasswordVisible;
          });
        },
        child: Icon(
          isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
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

  Future<void> signUpButtonCallback() async {
    if (_formKey.currentState!.validate()) {
      final AuthentificationService authService = AuthentificationService();
      bool signUpStatus = false;
      String? snackbarMessage;

      try {
        signUpStatus = await showDialog(
          context: context,
          builder: (context) {
            return AsyncProgressDialog(
              authService.signUp(
                context,
                email: emailFieldController.text,
                password: passwordFieldController.text,
              ),
              // message: Text(AppLocalizations.of(context)!.creatingNewAccount),
            );
          },
        );

        if (signUpStatus == true) {
          snackbarMessage =
              'Registered successfully, Please verify your email id';
          // Navigator.pop(context);
          Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdditionalInformationScreen(),
                    ));
        } else {
          throw FirebaseSignUpAuthUnknownReasonFailureException(context);
        }
      } on MessagedFirebaseAuthException catch (e) {
        snackbarMessage = e.message;
      } catch (e) {
        // snackbarMessage = e.toString();
        // throw FirebaseSignUpAuthUnknownReasonFailureException( context,
        //     message: snackbarMessage);
      } finally {
        Logger().i(snackbarMessage);
        ShowSnackBar().showSnackBar(context, snackbarMessage!);
      }
    }
  }
}
