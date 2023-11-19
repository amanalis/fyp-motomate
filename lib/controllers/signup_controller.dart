
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motomate/repository/authentication_repository/authentication_repostory.dart';
import 'package:motomate/repository/user_repo/user_repository.dart';
import 'package:motomate/utils/database.dart';

class SignUpController extends GetxController{
  static SignUpController get instance => Get.find();

  final email = TextEditingController();
  final password = TextEditingController();
  final fullname = TextEditingController();
  final phoneNo = TextEditingController();

  // final userRepo = Get.put(UserRepository());

  void registerUser(String email, String password, BuildContext context){
    AuthenticationRepository.instance.createUserWithEmailAndPassword(email, password, context);
  }
  // Future<void> createUser(UserModel user) async {
  //  await userRepo.createUser(user);
  //   phoneAuthentication(user.phone);
  // }
  void phoneAuthentication(String phoneNo){
    AuthenticationRepository.instance.phoneAuthentication(phoneNo);
  }
}