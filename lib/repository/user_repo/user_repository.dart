// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:motomate/utils/database.dart';
//
// class UserRepository extends GetxController{
//   static UserRepository get instance => Get.find();
//
//   final _db = FirebaseFirestore.instance;
//
//   createUser(UserModel user) async {
//     await _db.collection("user_data").add(user.toJason()).whenComplete(
//             () => Get.snackbar("Success", "Your account has been created.",
//             snackPosition: SnackPosition.BOTTOM,
//             backgroundColor: Colors.orangeAccent.withOpacity(0.1),
//             colorText: Colors.black),
//     )
//     .catchError((error, stackTrace){
//       Get.snackbar("Error", "Something went wrong. Try again",
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.orangeAccent.withOpacity(0.1),
//           colorText: Colors.black);
//       print(error.toString());
//     });
//   }
// }