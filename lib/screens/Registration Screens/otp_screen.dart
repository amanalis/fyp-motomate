// ignore_for_file: use_build_context_synchronously, body_might_complete_normally_catch_error

// import 'package:email_otp/email_otp.dart';
// import 'package:auth_handler/auth_handler.dart';
// import 'package:email_auth/email_auth.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:motomate/utils/flutter_toast.dart';
import 'package:motomate/utils/shared_prefs.dart';

import '../../utils/database.dart';
import '../dashboard.dart';
import 'login.dart';

class OTPScreen extends StatefulWidget {
  final String name;
  final String phone;
  final String email;
  final String password;
  // final EmailAuth Auth;
  final EmailOTP myAuth;
  // final AuthHandler authHandler;

  const OTPScreen({
    super.key,
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
     required this.myAuth,
  });

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  String otpCode = '';

  late int userIDFromDatabase;

  // void getUserData() async {
  //   userIDFromDatabase = await UserModel().getUsersCount();
  //   print(userIDFromDatabase);
  //   userIDFromDatabase = 100 + userIDFromDatabase;
  //   print(userIDFromDatabase);
  //   setState(() {
  //
  //   });
  // }

  // ignore: non_constant_identifier_names
  Future<void> verifyOTP(String OTP) async {
    if (await widget.myAuth.verifyOTP(otp: OTP)) {

      displayToastMessage("OTP Verified", context);
      signup();
    } else {
      displayToastMessage(
        "Invalid OTP Code",
        context,
      );
    }

  }

  void signup() async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: widget.email, password: widget.password)
        .catchError(
      (errMsg) {
        if (errMsg.code == 'email-already-in-use') {
          displayToastMessage("Email already registered.", context);
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
        } else if (errMsg.code == 'invalid-email') {
          displayToastMessage("Email Format is Invalid", context);
        } else {
          displayToastMessage("Error: $errMsg", context);
        }
      },
    );

    //Save user information into Database
    await UserModel().addUser(
        userID: await FirebaseAuth.instance.currentUser!.uid,
        email: widget.email,
        name: widget.name,
        phone: widget.phone,
        imageURL:
            'https://icon-library.com/images/default-profile-icon/default-profile-icon-24.jpg');

    SharedPrefs().saveUserDataInPrefs(
      widget.name,
      await FirebaseAuth.instance.currentUser!.uid,
      widget.email,
      widget.password,
      widget.phone,
      'https://icon-library.com/images/default-profile-icon/default-profile-icon-24.jpg',
    );

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
          return const DashBoard();
        },
      ),
      (route) => false,
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.orange, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Moto\nMate",
              style: TextStyle(
                fontFamily: ('GravisPersonal'),
                fontWeight: FontWeight.normal,
                fontSize: 80,
              ),
            ),
            Text("Verification".toUpperCase(),
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(
              height: 40.0,
            ),
            const Text(
              "Enter the Verification Code sent.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20.0,
            ),
            /*OtpTextField(
              numberOfFields: 6,
              filled: true,
              fillColor: Colors.black.withOpacity(0.1),
              keyboardType: TextInputType.number,
              onCodeChanged: () {},
              onSubmit: (code) {
                otp = code;
                // verifyingOTP(code);
              },
            ),*/
            VerificationCode(
              isSecure: true,
              fullBorder: true,
              keyboardType: TextInputType.number,
              length: 6,
              onCompleted: (String value) {
                otpCode = value;
              },
              onEditing: (bool value) {},
            ),
            const SizedBox(
              height: 20.0,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  // var userId = await UserModel().getUserIdsList();
                  // int _userId = int.parse(userId.last)+1;
                  // await UserModel().addUser(userID: _userId, name: name, email: email, phone: phone);
                  verifyOTP(otpCode);

                  // verifyingOTP(otp);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange),
                child: const Text("Next",
                style: TextStyle(
                  color: Colors.white,
                ),),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/*
class OTPScreens extends StatelessWidget {
  final String name;
  final String phone;
  final String email;
  final String password;
  final EmailOTP myAuth;

  OTPScreens({
    Key? key,
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    required this.myAuth,
  }) : super(key: key);
  TextEditingController otpController = TextEditingController();

  // void verifyingOTP(String otp) async{
  //   var isVerified = await AuthenticationRepository.instance.verifyOtp(otp);
  //   isVerified ? Get.offAll((Dashboard())) : Get.back();
  // }
  String otpCode = '';

  @override
  Widget build(BuildContext context) {
    //var otpController = Get.put(OTPController());
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.orange, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Moto\nMate",
              style: TextStyle(
                fontFamily: ('GravisPersonal'),
                fontWeight: FontWeight.normal,
                fontSize: 80,
              ),
            ),
            Text("Verification".toUpperCase(),
                style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(
              height: 40.0,
            ),
            Text(
              "Enter the Verification Code sent.",
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20.0,
            ),
            */
/*OtpTextField(
              numberOfFields: 6,
              filled: true,
              fillColor: Colors.black.withOpacity(0.1),
              keyboardType: TextInputType.number,
              onCodeChanged: () {},
              onSubmit: (code) {
                otp = code;
                // verifyingOTP(code);
              },
            ),*/ /*

            VerificationCode(
              isSecure: true,
              fullBorder: true,
              keyboardType: TextInputType.number,
              length: 6,
              onCompleted: (String value) {
                print('onCompleted: $value');
                otpCode = value;
              },
              onEditing: (bool value) {
                print('onEditing: $value');
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  print("$otp,$otp.runtimeType");
                  // var userId = await UserModel().getUserIdsList();
                  // int _userId = int.parse(userId.last)+1;
                  // await UserModel().addUser(userID: _userId, name: name, email: email, phone: phone);
                  myAuth.setConfig(
                      appEmail: "bscs2012375@szabist.pk",
                      appName: "MotoMate OTP Code",
                      userEmail: email,
                      otpLength: 6,
                      otpType: OTPType.digitsOnly);
                  if (await myAuth.verifyOTP(otp: otp) == true) {
                    SignUpController.instance
                        .registerUser(email, password, context);
                    final user = UserModel()
                        .addUser(name: name, email: email, phone: phone);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Dashboard(),
                        ),
                        (route) => false);
                  } else {
                    displayToastMessage("Invalid OTP", context);
                  }

                  // verifyingOTP(otp);
                },
                child: Text("Next"),
                style: ElevatedButton.styleFrom(primary: Colors.deepOrange),
              ),
            )
          ],
        ),
      ),
    );
  }
}
*/
