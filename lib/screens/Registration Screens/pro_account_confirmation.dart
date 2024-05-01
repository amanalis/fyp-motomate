import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:motomate/screens/CreditCard/add_credit_card.dart';
import 'package:motomate/screens/dashboard.dart';

import '../../utils/database.dart';
import '../../utils/flutter_toast.dart';

class Pro_Account_Confirmation extends StatefulWidget {
  const Pro_Account_Confirmation({super.key});

  @override
  State<Pro_Account_Confirmation> createState() =>
      _Pro_Account_ConfirmationState();
}

class _Pro_Account_ConfirmationState extends State<Pro_Account_Confirmation> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String proAccountStatus = "";

  void getAccountStatus() async {
    proAccountStatus = (await UserModel()
        .getUserData(_firebaseAuth.currentUser!.uid, 'proaccount'))!;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAccountStatus();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        // title: Image.asset(
        //   "assets/images/motomate.png",
        //   height: size.height * 0.06,
        // ),
        actions: [
          IconButton(
              onPressed: () async => await UserModel().signOut(context),
              icon: const Icon(Icons.logout))
        ],
        elevation: 0,
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
      ),
      body: proAccountStatus == "true"
          ? Row(
              children: [
                Container(
                  width: size.width * 0.9999,
                  height: size.height * 0.99,
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
                        "assets/images/motomate.png",
                        width: size.width * 0.65,
                        height: size.height * 0.65,
                      ),
                      Text("Already have an Pro-Account!")
                    ],
                  ),
                )
              ],
            )
          : Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.deepOrange, Colors.orangeAccent],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/images/motomate.png",
                    width: size.width * 0.55,
                    height: size.height * 0.28,
                  ),
                  Text(
                    "Get Yourself a",
                    style: TextStyle(fontSize: 35,fontWeight: FontWeight.w200,),
                  ),
                  Text(
                    "Pro Account",
                    style: TextStyle(fontSize: 55,fontWeight: FontWeight.w700,),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Text(
                    "Perks:",
                    style: TextStyle(fontSize: 35,fontWeight: FontWeight.w300),
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Text(
                    "Chatting \n Posting \n Sharing",
                    style: TextStyle(fontSize: 35,fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Text(
                    "In just 100Rs per Month!",
                    style: TextStyle(fontSize: 35,fontWeight: FontWeight.w300),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrangeAccent,
                        minimumSize: const Size(double.infinity, 56),
                      ),
                      onPressed: () async {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddCardScreen()),
                                (route) => false);
                        displayToastMessage("Enter Your Details!", context);
                      },
                      child: Text("UPGRADE",style: TextStyle(color: Colors.white,),),),
                  ),
                ],
              ),
            ),
    );
  }
}
