import 'package:flutter/cupertino.dart';

import 'messaged_firebase_auth_exception.dart';


class FirebaseSignInAuthException extends MessagedFirebaseAuthException {
  FirebaseSignInAuthException(
      {String message = "Instance of FirebaseSignInAuthException"})
      : super(message);
}

class FirebaseSignInAuthUserDisabledException
    extends FirebaseSignInAuthException {
  FirebaseSignInAuthUserDisabledException( BuildContext context,
      {String message = ""})
      : super(message: message.isNotEmpty ? message : 'user disabled');
}

class FirebaseSignInAuthUserNotFoundException
    extends FirebaseSignInAuthException {
  FirebaseSignInAuthUserNotFoundException( BuildContext context,
      {String message = ""})
      : super(message: message.isNotEmpty ? message : 'user not found');
}

class FirebaseSignInAuthInvalidEmailException
    extends FirebaseSignInAuthException {
  FirebaseSignInAuthInvalidEmailException( BuildContext context,
      {String message = ""})
      : super(message: message.isNotEmpty ? message : 'invalid email');
}

class FirebaseSignInAuthWrongPasswordException
    extends FirebaseSignInAuthException {
  FirebaseSignInAuthWrongPasswordException(BuildContext context, {String message = ""})
      : super(message: message.isNotEmpty ? message : 'wrong password');
}

class FirebaseTooManyRequestsException extends FirebaseSignInAuthException {
  FirebaseTooManyRequestsException( BuildContext context,
      {String message = ""})
      : super(message: message.isNotEmpty ? message : 'sign in failed');
}

class FirebaseSignInAuthUserNotVerifiedException
    extends FirebaseSignInAuthException {
  FirebaseSignInAuthUserNotVerifiedException( BuildContext context,
      {String message = ""})
      : super(message: message.isNotEmpty ? message : "You haven't verified your email address. This action is only allowed for verified users.");
}

class FirebaseSignInAuthUnknownReasonFailure
    extends FirebaseSignInAuthException {
  FirebaseSignInAuthUnknownReasonFailure( BuildContext context,
      {String message = ""})
      : super(message: message.isNotEmpty ? message : 'sign in failed');
}
