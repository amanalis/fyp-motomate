import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motomate/reusablewidgets/post_dailog.dart';
import 'package:motomate/screens/edit_profile.dart';
import 'package:motomate/utils/database.dart';
import '../reusablewidgets/posttile.dart';
import '../reusablewidgets/side_menu.dart';
import '../utils/shared_prefs.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = "";
  String email = "";
  String imageUrl="https://icon-library.com/images/default-profile-icon/default-profile-icon-24.jpg";
  // String tempUrl="";

  void getData() async {
    String tempName = (await SharedPrefs().getData("name"))!;
    String tempEmail = (await SharedPrefs().getData("email"))!;
    String tempURL = (await SharedPrefs().getData("imageURL"))!;

    setState(() {
      name = tempName;
      email = tempEmail;
      imageUrl = tempURL;
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
      drawer: SideMenu(
        name: name,
        email: email,
          imageUrl: imageUrl,
      ),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: Image.asset(
          "images/motomate.png",
          height: size.height * 0.06,
        ),
        elevation: 0,
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10, left: 20),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.settings),
              color: Colors.black.withOpacity(0.6),
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: size.height * 0.02,
            ),
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: CircleAvatar(
                    radius: 74,
                    // backgroundColor: Colors.white,
                    backgroundColor: Colors.black,
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: NetworkImage(imageUrl),
                    ),
                  ),
                ),
                // Container(
                //   margin: const EdgeInsets.only(top: 20),
                //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(100),color: Colors.black),
                //   height: 160,
                //   width: 160,
                //   child: ClipRRect(
                //     borderRadius: BorderRadius.circular(100),
                //     // backgroundImage: NetworkImage(imageUrl,),
                //     child: Image.network(imageUrl,
                //       height: 140,
                //       width: 140,
                //       fit: BoxFit.cover,
                //     ),
                //   ),
                // ),
                Container(
                  margin: const EdgeInsets.only(top: 120),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(left: size.width * 0.175)),
                      SizedBox(
                        width: size.width * 0.07,
                      ),
                      Container(
                        padding: const EdgeInsets.all(0.1),
                        decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                        child: IconButton(
                          onPressed: () async{
                            ImagePicker imagePiker = ImagePicker();
                            XFile? file= await imagePiker.pickImage(source: ImageSource.gallery);
                            print('${file?.path}');

                            if(file == null) return;
                            String uniqueFileName = DateTime.now().microsecondsSinceEpoch.toString();

                            Reference referenceRoot = FirebaseStorage.instance.ref();
                            Reference referenceDirImages = referenceRoot.child('images');

                            Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

                            try{

                              await referenceImageToUpload.putFile(File(file.path));

                              imageUrl= await referenceImageToUpload.getDownloadURL();

                              String id = (await SharedPrefs().getData('id'))!;
                              await UserModel().updateUser(userID: id, key: 'ImageURL', data: imageUrl);
                              await SharedPrefs().updateImageURL(imageUrl);
                              setState(() {
                                imageUrl = imageUrl;
                              });

                            }catch(error){

                            }

                          },
                          icon: Icon(Icons.camera_alt,),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Text(
              name,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 23,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                email,
                style: const TextStyle(color: Colors.black54, fontSize: 15),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[500],
                    ),
                    onPressed: () {
                      Post_Dialog(context);
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.add_circle_rounded, color: Colors.white,),
                        SizedBox(
                          width: size.width * 0.01,
                        ),
                        const Text("Add Post",
                        style: TextStyle(color: Colors.white),)
                      ],
                    )),
                SizedBox(
                  width: size.width * 0.04,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[500],
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfileScreen(),
                        ));
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.edit,color: Colors.white),
                      SizedBox(
                        width: size.width * 0.01,
                      ),
                      const Text("Edit Profile",style: TextStyle(color: Colors.white),)
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.015,
            ),
            Divider(
              height: size.height * 0.02,
              thickness: 0.1,
              color: Colors.orange[700],
            ),
            SingleChildScrollView(
              child: SizedBox(
                height: size.height * 0.5,
                child: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) => Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const PostTile(),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
