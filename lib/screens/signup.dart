import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:motomate/screens/otp_screen.dart';
import 'package:motomate/utils/flutter_toast.dart';
import 'login.dart';

class SignUp extends StatelessWidget {
  var appTitle = "Signup";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.orange, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: const CustomSignUpForm(),
      )),
    );
  }
}

class CustomSignUpForm extends StatefulWidget {
  const CustomSignUpForm({super.key});

  @override
  State<CustomSignUpForm> createState() => _CustomSignUpFormState();
}

class _CustomSignUpFormState extends State<CustomSignUpForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final firebaseAuth = FirebaseAuth.instance;
  EmailOTP myAuth = EmailOTP();
  var _isObscured;

  void initState() {
    super.initState();
    _isObscured = true;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Size size = MediaQuery.of(context).size;
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             SizedBox(
              height: size.height * 0.12,
            ),
            Center(
              child: Image.asset(
                "images/motomate.png",
                width: size.width * 0.5
                // height: 220,
              ),
            ),
            const Center(
              child: Text(
                "Sign-Up",
                style: TextStyle(
                  fontFamily: ('GravisPersonal'),
                  fontSize: 24,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 0.0),
              child: TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.account_circle_rounded),
                    labelText: "Full Name",
                    border: OutlineInputBorder(
                        gapPadding: 3.3,
                        borderRadius: BorderRadius.circular(20))),
                validator: (value) {
                  if (value!.isEmpty ||
                      !RegExp(r"[a-zA-Z]+|\s").hasMatch(value!)) {
                    return "Enter correct name.";
                  } else {
                    return null;
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 0.0),
              child: TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.attach_email_outlined),
                    labelText: "Email Address",
                    border: OutlineInputBorder(
                        gapPadding: 3.3,
                        borderRadius: BorderRadius.circular(20))),
                validator: (value) {
                  if (value!.isEmpty ||
                      !RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w]{2,4}")
                          .hasMatch(value)) {
                    return "Enter correct email address.";
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 0.0),
              child: TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.add_ic_call_outlined),
                    labelText: "Phone",
                    hintText: "+92",
                    border: OutlineInputBorder(
                        gapPadding: 3.3,
                        borderRadius: BorderRadius.circular(20))),
                validator: (value) {
                  if (value!.isEmpty ||
                      !RegExp(r"[0-9]{11}").hasMatch(value!)) {
                    return "Enter correct number.";
                  } else {
                    return null;
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 0.0),
              child: TextFormField(
                  controller: passwordController,
                  obscureText: _isObscured,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.key),
                      suffixIcon: IconButton(
                        padding: EdgeInsetsDirectional.only(end: 12.0),
                        icon: _isObscured
                            ? Icon(Icons.visibility)
                            : Icon(Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isObscured = !_isObscured;
                          });
                        },
                      ),
                      labelText: "Password",
                      border: OutlineInputBorder(
                          gapPadding: 1.3,
                          borderRadius: BorderRadius.circular(20))),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !RegExp(r"((?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[\W]).{8,64})")
                            .hasMatch(value)) {
                      return "Please enter Password";
                    } else {
                      // _data.password = value;
                      // print("Data , ${_data.password}");
                    }
                  }),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 0.0),
              child: TextFormField(
                  obscureText: _isObscured,
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.key),
                      suffixIcon: IconButton(
                        padding: EdgeInsetsDirectional.only(end: 12.0),
                        icon: _isObscured
                            ? Icon(Icons.visibility)
                            : Icon(Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isObscured = !_isObscured;
                          });
                        },
                      ),
                      labelText: "Re-Enter Password",
                      border: OutlineInputBorder(
                          gapPadding: 1.3,
                          borderRadius: BorderRadius.circular(20))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please re-enter Password";
                    }
                    if (value != passwordController.text){
                      return "Match the password.";
                    }
                    return null;
                  }),
            ),
             SizedBox(
              height: size.height * 0.03,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: size.width * 0.86,
                      height: size.height * 0.06,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.deepOrange,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                          ),
                          
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              // SignUpController.instance.registerUser(controller.email.text.trim(), controller.password.text.trim(),context);
                              // SignUpController.instance.phoneAuthentication(
                              //     controller.phoneNo.text.trim());
                              // print(controller.fullname.text.trim());
                              myAuth.setConfig(
                                appEmail: "bscs2012375@szabist.pk",
                                appName: "MotoMate OTP Code",
                                userEmail: emailController.text,
                                otpLength: 6,
                                otpType: OTPType.digitsOnly,
                              );
                              if (await myAuth.sendOTP() == true) {
                                displayToastMessage(
                                  'We have sent you OTP on the entered email',
                                  context,
                                );

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OTPScreen(
                                      name: nameController.text,
                                      phone: phoneController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                      myAuth: myAuth,
                                    ),
                                  ),
                                );
                              } else {
                                displayToastMessage('Try again', context);
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("All is good")));
                            }
                          },
                          child: const Text("Sign-Up")),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(35.0, 0.0, 0.0, 0.0),
              child: TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Login()));
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(50.0, 0.0, 0.0, 0.0),
                  child: const Text(
                    "Already have an account? Log-In",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

// validator: (value) {
//   if (value == null || value.isEmpty) {
//     return "Please enter Email Address";
//   }
// },
// onChanged:
//     (value) {
//   validateEmail(value);
// }
