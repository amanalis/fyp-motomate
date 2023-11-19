
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motomate/exceptions/signup_email_password_failure.dart';
import 'package:motomate/screens/dashboard.dart';
import 'package:motomate/screens/login.dart';
import 'package:motomate/screens/otp_screen.dart';
import 'package:motomate/screens/splash_screen.dart';

import '../../utils/flutter_toast.dart';

class AuthenticationRepository extends GetxController{
  static AuthenticationRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;
  var verficationId = ''.obs;

  void onReady(){
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setinitialScreen);
  }

  _setinitialScreen(User? user) {
    user == null ? Get.offAll(() => Login()) : Get.offAll(()=> Dashboard());
  }

  Future<void> phoneAuthentication(String phoneNo) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNo,
        verificationCompleted: (credential) async{
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (e) {
          if(e.code == 'Invalid phone-number'){
            Get.snackbar('Error', 'The provided phone number is not valid.');
          } else{
            Get.snackbar('Error', 'Something went wrong. Try again');
          }
        },
        codeSent: (verificationId, resendToken) {
          this.verficationId.value = verificationId;
        },
        codeAutoRetrievalTimeout: (verificationId) {
          this.verficationId.value = verificationId;
        },
    );
  }

  Future<bool> verifyOtp(String otp) async{
    var credentials = await _auth.
    signInWithCredential(PhoneAuthProvider.credential(verificationId: this.verficationId.value, smsCode: otp));
    return credentials.user != null ? true : false;
}

  Future<dynamic> createUserWithEmailAndPassword(String email, String password, BuildContext context) async {
      try{
        final user = (await FirebaseAuth.instance
            .signInWithEmailAndPassword(
            email: email,
            password: password)
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
        return user;
      }
      catch(e){
        displayToastMessage("error occur try again later", context);
      }
    // try {
    //   await _auth.createUserWithEmailAndPassword(
    //       email: email, password: password);
    //   firebaseUser.value != null ? Get.offAll(() => OTPScreens()) : Get.offAll(()=> SplashScreen());
    // } on FirebaseAuthException catch(e){
    //   final ex =SignUpWithEmailAndPasswordFailure.code(e.code);
    //   print("FIREBASE AUTH EXCEPTION - ${ex.message}");
    //   throw ex;
    // } catch (_){
    //   final ex = SignUpWithEmailAndPasswordFailure();
    //   print("EXCEPTION - ${ex.message}");
    //   throw ex;
    // }
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch(e){
    } catch (_){}
  }

  Future<void> logout() async => await _auth.signOut();
}