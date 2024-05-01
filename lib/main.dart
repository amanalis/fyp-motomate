import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:motomate/screens/CreditCard/add_credit_card.dart';
import 'package:motomate/screens/splash_screen.dart';
import 'package:motomate/utils/notification.dart';
import 'package:motomate/utils/shared_prefs.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
      );

  NotificationService().initAwesomeNotification();
  NotificationService().requestPermission();
  SharedPrefs().sharedPrefsInit();

  runApp(
    MaterialApp(
      title: "MotoMate",
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
        ),
      ),
    ),
  );
}
