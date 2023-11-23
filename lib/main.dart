import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:motomate/screens/splash_screen.dart';
import 'package:motomate/utils/shared_prefs.dart';

import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Shared_Prefs().SharedPrefsInit();

  runApp(const MaterialApp(
    title: "MotoMate",
    home: SplashScreen(),
    debugShowCheckedModeBanner: false,
    //theme: ThemeData(colorScheme:ColorScheme.fromSeed(seedColor: Colors.orange)),
  ));
}
