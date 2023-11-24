// ignore_for_file: use_build_context_synchronously, body_might_complete_normally_catch_error

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motomate/utils/shared_prefs.dart';
import '../utils/flutter_toast.dart';
import 'Registration Screens/login.dart';
import 'dashboard.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  void getRememberMe() async {
    bool rememberMe = (await SharedPrefs().isRememberMe())!;
    if (rememberMe == true) {
      String email = (await SharedPrefs().getData('email'))!;
      String password = (await SharedPrefs().getData('password'))!;
      final user = (await FirebaseAuth.instance
              .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
              .catchError(
        (errMsg) {
          if (errMsg.code == "user-not-found") {
            displayToastMessage("Login details are incorrect", context);
          } else if (errMsg.code == "wrong-password") {
            displayToastMessage("Password is wrong", context);
          } else if (errMsg.code == "invalid-email") {
            displayToastMessage("Email format is not valid", context);
          } else if (errMsg.code == "too-many-requests") {
            displayToastMessage(
                "Too many failed attempts. Try again later.", context);
          } else {
            displayToastMessage("Error: $errMsg", context);
          }
        },
      ))
          .user;

      if (user != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const Dashboard(),
          ),
          (route) => false,
        );
        displayToastMessage("Login", context);
      } else {
        displayToastMessage("Login failed", context);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    Future.delayed(
      const Duration(seconds: 3),
      () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const Login(),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.deepOrange, Colors.orangeAccent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "images/motomate.png",
              width: size.width * 0.65,
              height: size.height * 0.65,
            ),
          ],
        ),
      ),
    );
  }
}
