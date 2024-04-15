import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:motomate/screens/dashboard.dart';

import '../../utils/database.dart';

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
        title: Image.asset(
          "images/motomate.png",
          height: size.height * 0.06,
        ),
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
                        "images/motomate.png",
                        width: size.width * 0.65,
                        height: size.height * 0.65,
                      ),
                      Text("Already have an Pro-Account!")
                    ],
                  ),
                )
              ],
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 90),
                  child: Container(
                      height: size.height * 0.55,
                      width: size.width * 0.75,
                      color: Colors.orangeAccent,
                      child: Column(
                        children: [
                          Text(
                            "Convert Your Account to",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontFamily: ('')),
                          ),
                          Text(
                            "PRO",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: ('GravisPersonal'),
                              //color: Colors.white,
                              fontSize: 80,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.star_border_outlined,
                                  color: Colors.white),
                              Text(
                                "Chatting",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 35,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.star_border_outlined,
                                  color: Colors.white),
                              Text(
                                "Posting",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 35,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 80),
                      child: SizedBox(
                        width: size.width * 0.6,
                        height: size.height * 0.05,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            await UserModel().updateUser(
                                userID: _firebaseAuth.currentUser!.uid,
                                key: 'proaccount',
                                data: "true");
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DashBoard()),
                                (route) => false);
                          },
                          child: const Text(
                            "Upgrade",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: GestureDetector(
                        onTap: () async {
                          await UserModel().updateUser(
                              userID: _firebaseAuth.currentUser!.uid,
                              key: 'proaccount',
                              data: "false");
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DashBoard()),
                              (route) => false);
                        },
                        child: Text(
                          "NOT NOW!",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
    );
  }
}
