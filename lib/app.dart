

import 'package:flutter/material.dart';

import 'screens/additional_information/additional_information_screen.dart';
import 'screens/authentication/sign_in_screen.dart';
import 'screens/screens.dart';
import 'widgets/authentification_wrapper.dart';

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hemospectra',
      theme: ThemeData(
      // TextTheme(),
      useMaterial3: true,
      textSelectionTheme: const TextSelectionThemeData(
        selectionHandleColor: Colors.blue,
        cursorColor: Colors.blue,
        selectionColor: Colors.blue,
      ),
      textTheme: const TextTheme(displayLarge:  TextStyle(fontSize: 30), displayMedium: TextStyle(fontSize: 22), displaySmall: TextStyle(fontSize: 14)
      
      ,),
      inputDecorationTheme: InputDecorationTheme(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(width: 1.5, color: Colors.black),
        ),
        border: const OutlineInputBorder(
          borderSide:
              BorderSide(color: Colors.black), // Set your border color here
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.0),
        ),
      ),
      expansionTileTheme: ExpansionTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.0),
        ),
      ),
      drawerTheme: const  DrawerThemeData(backgroundColor: Colors.blue,),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: const AppBarTheme(
        // backgroundColor: Colors.blue,
      ),
      cardTheme: CardTheme(
        color: Theme.of(context).secondaryHeaderColor,
        surfaceTintColor: Colors.white,
        clipBehavior: Clip.antiAlias,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.0),
        ),
      ),
      disabledColor: Colors.grey[600],
      brightness: Brightness.light,
      snackBarTheme:
          SnackBarThemeData(backgroundColor: Theme.of(context).cardColor),
      indicatorColor: Colors.blue,
      progressIndicatorTheme: const ProgressIndicatorThemeData()
          .copyWith(color: Colors.blue),
      iconTheme: IconThemeData(
        color: Colors.grey[900],
        opacity: 1.0,
        size: 24.0,
      ),
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),

    ),
      home:  const AuthentificationWrapper(),
    );
  }
}
