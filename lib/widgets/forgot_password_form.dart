import 'package:flutter/material.dart';
import 'package:hemospectra/widgets/custom_button.dart';
import 'package:hemospectra/widgets/custom_text_form_field.dart';
import 'package:logger/logger.dart';

import '../exceptions/credential_actions_exception.dart';
import '../exceptions/messaged_firebase_auth_exception.dart';
import '../models/size_config.dart';
import '../services/authentification_service.dart';
import '../utils/constants.dart';
import 'async_progress_dialog.dart';
import 'no_account_text.dart';
import 'snack_bar.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailFieldController = TextEditingController();
  @override
  void dispose() {
    emailFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          CustomButton(
            text: 'Send verification email',
            onPressed: sendVerificationEmailButtonCallback,
          ),
          SizedBox(height: SizeConfig.screenHeight! * 0.1),
          const NoAccountText(),
          SizedBox(height: getProportionateScreenHeight(30)),
        ],
      ),
    );
  }

  CustomTextFormField buildEmailFormField() {
    return CustomTextFormField(
      controller: emailFieldController,
      keyboardType: TextInputType.emailAddress,
      hintText: 'Email',
      suffixIcon: const Icon(
        Icons.mail_outline,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return AppStrings.getEmailNullError(context);
          
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          return AppStrings.getInvalidEmailError(context);
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Future<void> sendVerificationEmailButtonCallback() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final String emailInput = emailFieldController.text.trim();
      bool resultStatus;
      String? snackbarMessage;
      try {
        final resultFuture =
            AuthentificationService().resetPasswordForEmail(context, emailInput);
        resultFuture.then((value) => resultStatus = value);
        resultStatus = await showDialog(
          context: context,
          builder: (context) {
            return AsyncProgressDialog(
              resultFuture,
              // message:
              //     Text(AppLocalizations.of(context)!.sendingVerificationEmail),
            );
          },
        );
        if (resultStatus == true) {
          snackbarMessage = 'Password Reset Link sent to your email';
        } else {
          throw FirebaseCredentialActionAuthUnknownReasonFailureException(
              message: 'Sorry, could not process your request now, try again later');
        }
      } on MessagedFirebaseAuthException catch (e) {
        snackbarMessage = e.message;
      } catch (e) {
        snackbarMessage = e.toString();
      } finally {
        Logger().i(snackbarMessage);
        ShowSnackBar().showSnackBar(context, snackbarMessage!);
      }
    }
  }
}
