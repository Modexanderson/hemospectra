import 'package:flutter/material.dart';

import '../screens/authentication/sign_in_screen.dart';
import '../screens/screens.dart';
import '../services/authentification_service.dart';

class AuthentificationWrapper extends StatelessWidget {
  static const String routeName = "/authentification_wrapper";

  const AuthentificationWrapper({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthentificationService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const Screens();
        } else {
          return const SignInScreen();
        }
      },
    );
  }
}
