import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:motomate/screens/dashboard.dart';
import 'package:motomate/screens/forget_password_mail.dart';
import 'package:motomate/screens/forget_password_phone.dart';
import 'package:motomate/screens/signup.dart';
import 'package:motomate/utils/database.dart';
import 'package:motomate/utils/shared_prefs.dart';

import '../utils/flutter_toast.dart';

class Login extends StatelessWidget {
  final appTitle = "Login";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
              child: Container(
            child: CustomLoginForm(),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.orange, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
            ),
          )),
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
  String _ErrorMessage = "";
  final firebaseAuth = FirebaseAuth.instance;
  TextEditingController EmailController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();
  String name = "";
  String phonenumber = "";
  String id = "";


  void getData(String email) async {
    id = (await UserModel().getUserID(email))!;
    print(id);
    phonenumber = (await UserModel().getUserData(id, "Phone"))!;
    print(phonenumber);
    name = (await UserModel().getUserData(id, "Name"))!;
    print(name);
    Shared_Prefs().saveUserDataInPrefs(name, id, EmailController.text, PasswordController.text, phonenumber);
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
            padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
            child: TextFormField(
                controller: EmailController,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.account_circle_rounded),
                    labelText: "Email Address",
                    border: OutlineInputBorder(
                        gapPadding: 3.3,
                        borderRadius: BorderRadius.circular(30))),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      !RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w]{2,4}")
                          .hasMatch(value)) {
                    return "Please enter Email Address";
                  }
                },
                onChanged: (value) {
                  validateEmail(value);
                }),
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
            child: TextFormField(
                controller: PasswordController,
                obscureText: true,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.key),
                    labelText: "Password",
                    border: OutlineInputBorder(
                        gapPadding: 1.3,
                        borderRadius: BorderRadius.circular(30))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter Password";
                  } else {
                    // _data.password = value;
                    // print("Data , ${_data.password}");
                  }
                }),
          ),
          SizedBox(
            height: size.height*0.01,
          ),
          Container(
            alignment: Alignment(0.80, 0),
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    builder: (BuildContext context) {
                      return bottomsheetwidget();
                    });
              },

              child: Text(
                "Forgot Password?",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: size.width * 0.036),
              ),
            ),
          ),
          SizedBox(
            height: size.height*0.02,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: size.width * 0.8,
                    height: size.height*0.05,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.deepOrange,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final user = (await firebaseAuth
                                    .signInWithEmailAndPassword(
                                        email: EmailController.text,
                                        password: PasswordController.text)
                                    .catchError(
                              (errMsg) {
                                if (errMsg.code == "user-not-found") {
                                  displayToastMessage(
                                      "Login details are incorrect", context);
                                } else if (errMsg.code == "wrong-password") {
                                  displayToastMessage(
                                      "Password is wrong", context);
                                } else if (errMsg.code == "invalid-email") {
                                  displayToastMessage(
                                      "Email format is not valid", context);
                                } else if (errMsg.code == "too-many-requests") {
                                  displayToastMessage(
                                      "Too many failed attempts. Try again later.",
                                      context);
                                } else {
                                  displayToastMessage(
                                      "Error: $errMsg", context);
                                }
                              },
                            ))
                                .user;

                            if (user != null) {
                              getData(EmailController.text);
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Dashboard(),
                                ),
                                (route) => false,
                              );
                              displayToastMessage("Login", context);
                            } else {
                              displayToastMessage("Login failed", context);
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("All is good")));
                          }
                        },
                        child: Text("Login")),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => SignUp()));
              },
              child: Text(
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

  void validateEmail(String val) {
    if (val.isEmpty) {
      setState(() {
        _ErrorMessage = "Email cannot be empty";
      });
    } else if (!RegExp(r"\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b").hasMatch(val)) {
      setState(() {
        _ErrorMessage = "Invalid Email Address";
      });
    } else {
      setState(() {
        _ErrorMessage = "";
      });
    }
  }
}

class bottomsheetwidget extends StatefulWidget {
  const bottomsheetwidget({super.key});

  @override
  State<bottomsheetwidget> createState() => _bottomsheetwidgetState();
}

class _bottomsheetwidgetState extends State<bottomsheetwidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Make Selection!",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              )),
          Text("Select one of the options given below to reset your password",
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 50.0),
          ForgetPasswordBtnWidget(
            btnIcon: Icons.mail_outline_rounded,
            title: "E-mail",
            subTitle: "Reset Via Mail Verification",
            onTap: () {
              // Navigator.pop(context);
              // Get.to(() => const ForgetPasswordMailScreen());
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ForgetPasswordMailScreen()));
            },
          ),
          const SizedBox(height: 20.0),
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
          ),
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
                Text(title, style: Theme.of(context).textTheme.headline6),
                Text(subTitle, style: Theme.of(context).textTheme.bodyText2),
              ],
            )
          ],
        ),
      ),
    );
  }
}
