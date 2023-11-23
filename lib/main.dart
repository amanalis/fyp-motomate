import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motomate/repository/authentication_repository/authentication_repostory.dart';
import 'package:motomate/screens/account.dart';
import 'package:motomate/screens/dashboard.dart';
import 'package:motomate/screens/forget_password_mail.dart';
import 'package:motomate/screens/forget_password_phone.dart';
import 'package:motomate/screens/login.dart';
import 'package:motomate/screens/otp_screen.dart';
import 'package:motomate/screens/profile.dart';
import 'package:motomate/screens/signup.dart';
import 'package:motomate/screens/splash_screen.dart';
import 'package:motomate/utils/shared_prefs.dart';
import 'firebase_options.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // ).then((value) => Get.put(AuthenticationRepository()));

  Shared_Prefs().SharedPrefsInit();

  runApp(GetMaterialApp(
    title: "MotoMate",
    home:Dashboard(),
    debugShowCheckedModeBanner: false,
    //theme: ThemeData(colorScheme:ColorScheme.fromSeed(seedColor: Colors.orange)),
  ));
// work in progress
}
