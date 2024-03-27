import 'package:flutter/material.dart';

import 'messaged_firebase_auth_exception.dart';


class FirebaseSignUpAuthException extends MessagedFirebaseAuthException {
  FirebaseSignUpAuthException(
      {String message = "Instance of FirebaseSignUpAuthException"})
      : super(message);
}

class FirebaseSignUpAuthEmailAlreadyInUseException
    extends FirebaseSignUpAuthException {
  FirebaseSignUpAuthEmailAlreadyInUseException( BuildContext context,
      {String message = ""})
      : super(message: message.isNotEmpty ? message : 'email already in use');
}


class FirebaseSignUpAuthInvalidEmailException
    extends FirebaseSignUpAuthException {
  FirebaseSignUpAuthInvalidEmailException( BuildContext context,
      {String message = ""})
      : super(message: message.isNotEmpty ? message : 'invalid email');
}

class FirebaseSignUpAuthOperationNotAllowedException
    extends FirebaseSignUpAuthException {
  FirebaseSignUpAuthOperationNotAllowedException( BuildContext context,
      {String message = ""})
      : super(message: message.isNotEmpty ? message : 'sign in failed');
}

class FirebaseSignUpAuthWeakPasswordException
    extends FirebaseSignUpAuthException {
  FirebaseSignUpAuthWeakPasswordException( BuildContext context,
      {String message = ""})
      : super(message: message.isNotEmpty ? message : 'weak password');
}

class FirebaseSignUpAuthUnknownReasonFailureException
    extends FirebaseSignUpAuthException {
  FirebaseSignUpAuthUnknownReasonFailureException( BuildContext context,
      {String message = ""})
      : super(message: message.isNotEmpty ? message : 'sign in failed');
}
