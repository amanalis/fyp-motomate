// ignore_for_file: body_might_complete_normally_catch_error, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:motomate/screens/Registration%20Screens/forget_password_mail.dart';
import 'package:motomate/screens/Registration%20Screens/signup.dart';
import 'package:motomate/screens/dashboard.dart';
import 'package:motomate/utils/database.dart';
import 'package:motomate/utils/shared_prefs.dart';
import 'package:regexed_validator/regexed_validator.dart';

import '../../utils/flutter_toast.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.orange,
                Colors.white,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: const CustomLoginForm(),
        ),
      ),
    );
  }
}

class CustomLoginForm extends StatefulWidget {
  const CustomLoginForm({super.key});

  @override
  State<CustomLoginForm> createState() => _CustomLoginFormState();
}

class _CustomLoginFormState extends State<CustomLoginForm> {
  final _formKey = GlobalKey<FormState>();
  final firebaseAuth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String name = "";
  String phoneNumber = "";
  String id = "";
  String imageUrl = "";
  bool _isRememberMe = false;

  Future<void> getData(String email) async {
    id = (await UserModel().getUserID(email))!;
    phoneNumber = (await UserModel().getUserData(id, "Phone"))!;
    name = (await UserModel().getUserData(id, "Name"))!;
    imageUrl = (await UserModel().getUserData(id, "ImageURL"))!;
    await SharedPrefs().saveUserDataInPrefs(
      name,
      id,
      emailController.text,
      passwordController.text,
      phoneNumber,
      imageUrl,
    );
    await SharedPrefs().rememberMe(_isRememberMe);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: size.height * 0.17,
          ),
          Center(
            child: Image.asset(
              "images/motomate.png",
              width: size.width * 0.75,
              // height: 220,
            ),
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          Center(
            child: Text(
              "Login",
              style: TextStyle(
                fontFamily: ('GravisPersonal'),
                fontSize: size.width * 0.07,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.account_circle_rounded),
                labelText: "Email Address",
                border: OutlineInputBorder(
                  gapPadding: 3.3,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              validator: (value) {
                if (!validator.email(value!)) {
                  return "Please enter Email Address";
                }
                return null;
              },
            ),
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.key),
                  labelText: "Password",
                  border: OutlineInputBorder(
                      gapPadding: 1.3,
                      borderRadius: BorderRadius.circular(30))),
              validator: (value) {
                if (!validator.mediumPassword(value!)) {
                  return "Please enter Password";
                }
                return null;
              },
            ),
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Checkbox(
                      onChanged: (value) {
                        setState(() {
                          _isRememberMe = value!;
                        });
                      },
                      value: _isRememberMe,
                    ),
                    const Text(
                      "Remember Me.",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        builder: (BuildContext context) {
                          return const BottomSheetWidget();
                        },
                      );
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: size.width * 0.036,
                      ),
                    ),
                  ),
                ),
                /*SizedBox(
              height: size.height * 0.02,
            ),*/
              ],
            ),
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: size.width * 0.8,
                  height: size.height * 0.05,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final user = (await firebaseAuth
                                .signInWithEmailAndPassword(
                                    email: emailController.text,
                                    password: passwordController.text)
                                .catchError(
                          (errMsg) {
                            if (errMsg.code == "user-not-found") {
                              displayToastMessage(
                                  "Login details are incorrect", context);
                            } else if (errMsg.code == "wrong-password") {
                              displayToastMessage("Password is wrong", context);
                            } else if (errMsg.code == "invalid-email") {
                              displayToastMessage(
                                  "Email format is not valid", context);
                            } else if (errMsg.code == "too-many-requests") {
                              displayToastMessage(
                                  "Too many failed attempts. Try again later.",
                                  context);
                            } else {
                              displayToastMessage("Error: $errMsg", context);
                            }
                          },
                        ))
                            .user;

                        if (user != null) {
                          getData(emailController.text);
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
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const SignUp()));
              },
              child: const Text(
                "Don't have an account? Sign-Up",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomSheetWidget extends StatefulWidget {
  const BottomSheetWidget({super.key});

  @override
  State<BottomSheetWidget> createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Make Selection!",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            "Select one of the options given below to reset your password",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 50.0),
          ForgetPasswordBtnWidget(
            btnIcon: Icons.mail_outline_rounded,
            title: "E-mail",
            subTitle: "Reset Via Mail Verification",
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ForgetPasswordMailScreen()));
            },
          ),
          /*const SizedBox(height: 20.0),
          ForgetPasswordBtnWidget(
            btnIcon: Icons.mobile_friendly_rounded,
            title: "Phone No",
            subTitle: "Reset Via Phone Verification",
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ForgetPasswordPhoneScreen()));
            },
          ),*/
        ],
      ),
    );
  }
}

class ForgetPasswordBtnWidget extends StatelessWidget {
  const ForgetPasswordBtnWidget({
    required this.btnIcon,
    required this.title,
    required this.subTitle,
    required this.onTap,
    super.key,
  });

  final IconData btnIcon;
  final String title, subTitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.grey.shade200),
        child: Row(
          children: [
            Icon(btnIcon, size: 60.0),
            const SizedBox(width: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  subTitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
