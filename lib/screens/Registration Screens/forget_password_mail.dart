import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:motomate/utils/flutter_toast.dart';
import 'package:regexed_validator/regexed_validator.dart';

import '../../utils/notification.dart';
import 'login.dart';

class ForgetPasswordMailScreen extends StatefulWidget {
  const ForgetPasswordMailScreen({super.key});

  @override
  State<ForgetPasswordMailScreen> createState() =>
      _ForgetPasswordMailScreenState();
}

class _ForgetPasswordMailScreenState extends State<ForgetPasswordMailScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailcontroller =TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                Colors.orange,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.1,
              ),
              Image.asset(
                "images/forgetpassword.png",
                height: 200,
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              Text(
                "Forget Password",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: size.width * 0.07),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Text(
                "Please enter your e-mail address below to receive a link for resting your password",
                style: TextStyle(fontSize: size.width * 0.04),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: size.height * 0.04,
              ),
              Form(
                key: _formKey,
                child: Container(
                  constraints: const BoxConstraints(minHeight: 50),
                  child: TextFormField(
                    controller: emailcontroller,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.account_circle_rounded),
                          labelText: "Email Address",
                          border: OutlineInputBorder(
                              gapPadding: 3.3,
                              borderRadius: BorderRadius.circular(20))),
                      validator: (value) {
                        if (!validator.email(value!)) {
                          return "Please enter valid email address";
                        }
                        return null;
                      }),
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              SizedBox(
                width: size.width,
                height: 50,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          return Colors.deepOrange;
                        }),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)))),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        //
                        // setState(() {
                        //   _data.name = _data.name;
                        // });
                        resetPassword(context, emailcontroller.text);

                      }
                    },
                    child: const Text("Submit")),
              )
            ],
          ),
        ),
      ),
    );
  }

  void resetPassword(BuildContext context, String email) async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email)
          .then(
            (value) {
          Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(
                transitionDuration: const Duration(seconds: 1),
                transitionsBuilder: (context, animation, animationTime, child) {
                  animation = CurvedAnimation(
                      parent: animation, curve: Curves.fastLinearToSlowEaseIn);
                  return ScaleTransition(
                    scale: animation,
                    alignment: Alignment.center,
                    child: child,
                  );
                },
                pageBuilder: (context, animation, animationTime) {
                  return const Login();
                },
              ),
                  (route) => false);
          NotificationService().pushNotification(
              'Reset password link has been send to your given Email.');
        },
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        displayToastMessage("User not exist",context,);
      } else if (e.code == 'invalid-email') {
        displayToastMessage("Invalid email",context,);
      }
    }
  }
}
