import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'firebase_options.dart';
import 'models/body_models.dart';
import 'screens/provider_models/patient_details.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<PatientDetails>(
          create: (_) => PatientDetails(),
        ),
        ChangeNotifierProvider<ChosenImage>(
          create: (_) => ChosenImage(),
        ),
      ],
      child: const App(),
    ),
  );
}
