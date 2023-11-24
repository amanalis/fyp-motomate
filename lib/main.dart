import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:motomate/screens/splash_screen.dart';
import 'package:motomate/utils/shared_prefs.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
      //options: DefaultFirebaseOptions.currentPlatform,
      );

  SharedPrefs().sharedPrefsInit();

  runApp(
    MaterialApp(
      title: "MotoMate",
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
        ),
      ),
    ),
  );
}
