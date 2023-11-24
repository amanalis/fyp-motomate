// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:motomate/screens/profile.dart';
import 'package:motomate/utils/database.dart';
import 'package:motomate/utils/flutter_toast.dart';
import 'package:regexed_validator/regexed_validator.dart';
import '../utils/shared_prefs.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  bool _isEditable = false;
  String name = '';
  String email = '';
  bool _isObscured = true;
  final _formKey = GlobalKey<FormState>();

  void getData() async {
    String tempName = (await SharedPrefs().getData("name"))!;
    String tempEmail = (await SharedPrefs().getData("email"))!;
    String tempPhone = (await SharedPrefs().getData("phonenumber"))!;
    String tempPassword = (await SharedPrefs().getData("password"))!;

    setState(() {
      nameController.text = tempName;
      name = tempName;
      emailController.text = tempEmail;
      email = tempEmail;
      phoneController.text = tempPhone;
      passwordController.text = tempPassword;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      /*drawer: SideMenu(name: name, email: email),*/
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.black,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.settings_outlined,
                color: Colors.black,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: size.height * 0.01,
                ),
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: const CircleAvatar(
                        radius: 74,
                        // backgroundColor: Colors.white,
                        backgroundColor: Colors.black,
                        child: CircleAvatar(
                          radius: 70,
                          backgroundImage: AssetImage('images/bheem.jpg'),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 130),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                              padding:
                                  EdgeInsets.only(left: size.width * 0.175)),
                          SizedBox(
                            width: size.width * 0.05,
                          ),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    enabled: false,
                    controller: emailController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.attach_email_outlined),
                      labelText: "Email Address",
                      border: OutlineInputBorder(
                        gapPadding: 3.3,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    /*validator: (value) {
                      if (value!.isEmpty ||
                          !RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w]{2,4}")
                              .hasMatch(value)) {
                        return "Enter correct email address.";
                      }
                    },*/
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: nameController,
                    enabled: _isEditable,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.account_circle_rounded),
                      labelText: "Full Name",
                      border: OutlineInputBorder(
                        gapPadding: 3.3,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    validator: (value) {
                      if (validator.name(value!)) {
                        return "Enter correct name.";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    enabled: _isEditable,
                    controller: phoneController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.add_ic_call_outlined),
                      labelText: "Phone",
                      hintText: "+92",
                      border: OutlineInputBorder(
                        gapPadding: 3.3,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty ||
                          !RegExp(r"[0-9]{11}").hasMatch(value)) {
                        return "Enter correct number.";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    enabled: _isEditable,
                    controller: passwordController,
                    obscureText: _isObscured,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.key),
                      suffixIcon: IconButton(
                        padding: const EdgeInsetsDirectional.only(end: 12.0),
                        icon: _isObscured
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isObscured = !_isObscured;
                          });
                        },
                      ),
                      labelText: "Password",
                      border: OutlineInputBorder(
                        gapPadding: 1.3,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    validator: (value) {
                      if (!validator.mediumPassword(value!)) {
                        return "Please enter valid Password";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
                  child: SizedBox(
                    height: size.height * 0.05,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          side: BorderSide.none,
                          shape: const StadiumBorder()),
                      onPressed: _isEditable
                          ? () async {
                              if (_formKey.currentState!.validate()) {
                                await SharedPrefs().updateUserDataInPrefs(
                                  nameController.text,
                                  passwordController.text,
                                  phoneController.text,
                                );
                                String id =
                                    (await SharedPrefs().getData('id'))!;
                                await UserModel().updateUser(
                                    userID: id,
                                    key: 'Name',
                                    data: nameController.text);
                                await UserModel().updateUser(
                                    userID: id,
                                    key: 'Phone',
                                    data: phoneController.text);
                                await FirebaseAuth.instance.currentUser!
                                    .updatePassword(passwordController.text);
                                setState(() {
                                  _isEditable = false;
                                });
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ProfileScreen(),
                                  ),
                                  (route) => false,
                                );
                              } else {
                                displayToastMessage(
                                    "Enter valid information", context);
                              }
                            }
                          : () {
                              setState(() {
                                _isEditable = true;
                              });
                            },
                      child: Text(
                        _isEditable ? "Save Profile" : "Edit Profile",
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
