/*
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:motomate/repository/authentication_repository/authentication_repostory.dart';
import 'package:motomate/screens/dashboard.dart';

class OTPController extends GetxController {
  static OTPController get instance => Get.find();

  void verifyingOTP(String otp) async{
    var isVerified = await AuthenticationRepository.instance.verifyOtp(otp);
    isVerified ? Get.offAll((Dashboard())) : Get.back();
  }
}*/
