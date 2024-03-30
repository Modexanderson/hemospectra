// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../exceptions/credential_actions_exception.dart';
import '../exceptions/firebase_sign_in_exceptions.dart';
import '../exceptions/messaged_firebase_auth_exception.dart';
import '../exceptions/reauth_exceptions.dart';
import '../widgets/snack_bar.dart';
import 'database/user_database_helper.dart';

class AuthentificationService {
  String getLocalizedErrorMessage(String errorCode, BuildContext context) {
    switch (errorCode) {
      case 'user-not-found':
        return 'user not found';
      case 'wrong-password':
        return 'wrong password';
      case 'too-many-requests':
        return 'too many requests';
      case 'email-already-in-use':
        return 'email already in use';
      case 'operation-not-allowed':
        return 'operation not allowed';
      case 'weak-password':
        return 'weak password';
      case 'user-mismatch':
        return 'user mismatch';
      case 'invalid-credential':
        return 'invalid credential';
      case 'invalid-email':
        return 'invalid email';
      case 'invalid-verification-code':
        return 'invalid verification code';
      case 'user-disabled':
        return 'user disabled';
      case 'invalid-verification-id':
        return 'invalid verification id';
      case 'requires-recent-login':
        return 'requires recent login';

      // Add more cases as needed for specific error messages
      default:
        return 'error occured';
    }
  }

  FirebaseAuth? _firebaseAuth;

  AuthentificationService._privateConstructor();
  static final AuthentificationService _instance =
      AuthentificationService._privateConstructor();

  FirebaseAuth get firebaseAuth {
    _firebaseAuth ??= FirebaseAuth.instance;
    return _firebaseAuth!;
  }

  factory AuthentificationService() {
    return _instance;
  }

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  Stream<User?> get userChanges => firebaseAuth.userChanges();

  Future<void> deleteUserAccount() async {
    await currentUser.delete();
    await signOut();
  }

  Future<bool> reauthCurrentUser(BuildContext context, password) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
              email: currentUser.email!, password: password);
      userCredential = await currentUser
          .reauthenticateWithCredential(userCredential.credential!);
    } on FirebaseAuthException catch (e) {
      String errorMessage = getLocalizedErrorMessage(e.code, context);
      ShowSnackBar().showSnackBar(context, errorMessage);
    } catch (e) {
      throw FirebaseReauthUnknownReasonFailureException(message: e.toString());
    }
    return true;
  }

  String? currentUserProvider() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Check if the user signed in with Google
      if (user.providerData
          .any((provider) => provider.providerId == 'google.com')) {
        return 'google';
      }
      // Check if the user signed in with Apple
      else if (user.providerData
          .any((provider) => provider.providerId == 'apple.com')) {
        return 'apple';
      }
      // Add more checks for other sign-in methods if needed
    }
    return null;
  }

  Future<bool> signIn(BuildContext context,
      {String? email, String? password}) async {
    try {
      final UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
              email: email.toString(), password: password.toString());
      if (userCredential.user!.emailVerified) {
        return true;
      } else {
        await userCredential.user!.sendEmailVerification();
        throw FirebaseSignInAuthUserNotVerifiedException(context);
      }
    } on MessagedFirebaseAuthException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      String errorMessage = getLocalizedErrorMessage(e.code, context);
      ShowSnackBar().showSnackBar(context, errorMessage);
      return false;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> signUp(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
              email: email.toString(), password: password.toString());
      final String uid = userCredential.user!.uid;
      if (userCredential.user!.emailVerified == false) {
        await userCredential.user!.sendEmailVerification();
      }
      await UserDatabaseHelper().createNewUser(
        uid: uid,
        email: email,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      String errorMessage = getLocalizedErrorMessage(e.code, context);
      ShowSnackBar().showSnackBar(context, errorMessage);
      return false;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> signUpWithGoogle(
    BuildContext context, {
    String? fullName,
    DateTime? dateOfBirth,
    String? gender,
    String? country,
    String? state,
    String? role,
  }) async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await GoogleSignIn().signIn();

      if (googleSignInAccount == null) {
        // The user canceled the sign-in process
        return false;
      }

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential =
          await _firebaseAuth!.signInWithCredential(credential);

      final String uid = userCredential.user!.uid;
      final String email = googleSignInAccount.email;

      // Check if the user already exists in the database
      if (!(await UserDatabaseHelper().userExists(uid))) {
        // User doesn't exist, create a new user
        if (!userCredential.user!.emailVerified) {
          await userCredential.user!.sendEmailVerification();
        }

        await UserDatabaseHelper().createNewUser(
          uid: uid,
          email: email,
        );
      }

      return true;
    } on FirebaseAuthException catch (e) {
      String errorMessage = getLocalizedErrorMessage(e.code, context);
      ShowSnackBar().showSnackBar(context, errorMessage);
      print(e.message);
      return false;
    } catch (e) {
      // Handle other exceptions
      print(e.toString());
      return false;
    }
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  bool get currentUserVerified {
    currentUser.reload();
    return currentUser.emailVerified;
  }

  Future<bool> sendVerificationEmailToCurrentUser() async {
    try {
      await firebaseAuth.currentUser!.sendEmailVerification();
      return true; // Email verification succeeded
    } catch (error) {
      if (kDebugMode) {
        print("Error during email verification: $error");
      }
      return false; // Email verification failed
    }
  }

  User get currentUser {
    return firebaseAuth.currentUser!;
  }

  Future<void> updateCurrentUserDisplayName(String updatedDisplayName) async {
    await currentUser.updateProfile(displayName: updatedDisplayName);
  }

  Future<bool> resetPasswordForEmail(BuildContext context, String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } on MessagedFirebaseAuthException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      String errorMessage = getLocalizedErrorMessage(e.code, context);
      ShowSnackBar().showSnackBar(context, errorMessage);
      return false;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> changePasswordForCurrentUser(BuildContext context,
      {String? oldPassword, required String? newPassword}) async {
    try {
      bool isOldPasswordProvidedCorrect = true;
      if (oldPassword != null) {
        isOldPasswordProvidedCorrect =
            await verifyCurrentUserPassword(context, oldPassword);
      }
      if (isOldPasswordProvidedCorrect) {
        await firebaseAuth.currentUser!.updatePassword(newPassword.toString());

        return true;
      } else {
        throw FirebaseReauthWrongPasswordException();
      }
    } on MessagedFirebaseAuthException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      String errorMessage = getLocalizedErrorMessage(e.code, context);
      ShowSnackBar().showSnackBar(context, errorMessage);
      return false;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> changeEmailForCurrentUser(BuildContext context,
      {String? password, String? newEmail}) async {
    try {
      bool isPasswordProvidedCorrect = true;
      if (password != null) {
        isPasswordProvidedCorrect =
            await verifyCurrentUserPassword(context, password);
      }
      if (isPasswordProvidedCorrect) {
        await currentUser.verifyBeforeUpdateEmail(newEmail.toString());

        return true;
      } else {
        throw FirebaseReauthWrongPasswordException();
      }
    } on MessagedFirebaseAuthException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      throw FirebaseCredentialActionAuthException(message: e.code);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> verifyCurrentUserPassword(
      BuildContext context, String password) async {
    try {
      final AuthCredential authCredential = EmailAuthProvider.credential(
        email: currentUser.email.toString(),
        password: password,
      );

      final authCredentials = await currentUser
          .reauthenticateWithCredential(authCredential) as AuthCredential?;
      return authCredentials != null;
    } on MessagedFirebaseAuthException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      String errorMessage = getLocalizedErrorMessage(e.code, context);
      ShowSnackBar().showSnackBar(context, errorMessage);
      return false;
    } catch (e) {
      rethrow;
    }
  }
}
