import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
  String imageUrl =
      "https://icon-library.com/images/default-profile-icon/default-profile-icon-24.jpg";
  String PostimageURL =
      'https://icon-library.com/images/default-profile-icon/default-profile-icon-24.jpg';
  String userID = "";

  // String tempUrl="";
  int tab = 0;

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
    getPostData();
  }

  List<Map<String, dynamic>> Posts = [];
  List<Map<String, dynamic>> User_Posts = [];
  List<Map<String, dynamic>> User_LikedPosts = [];

  void getPostData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: LoadingAnimationWidget.discreteCircle(
              color: const Color(0XFF00B251),
              size: 50,
              secondRingColor: const Color(0XFFF8B32B),
              thirdRingColor: const Color(0XFFF72A37),
            ),
          );
        },
      );
    });
    String tempName = (await SharedPrefs().getData("name"))!;
    String tempEmail = (await SharedPrefs().getData("email"))!;
    String tempURL = (await SharedPrefs().getData("imageURL"))!;
    String tempID = (await SharedPrefs().getData("id"))!;
    int count = await PostModel().getPostCount();
    for (int i = count - 1; i >= 0; i--) {
      var doc = await PostModel().getPostDocument();
      String? name =
      await UserModel().getUserData(doc[i]["userID"].toString(), "Name");
      String? user_image =
      await UserModel().getUserData(doc[i]["userID"], "ImageURL");
      if (doc[i]["isApproved"] == true) {
        Posts.add({
          "post_images": doc[i]["images"],
          "userID": doc[i]["userID"],
          "name": name,
          "title": doc[i]["title"],
          'description': doc[i]["description"],
          "user_image": user_image,
          "post_id": doc[i]["documentID"],
          "date": doc[i]["date"],
          "isApproved": doc[i]["isApproved"],
          "YOM": doc[i]["YOM"],
          "CC" : doc[i]["CC"],
          "email": doc[i]["email"],
          "companyname": doc[i]["companyname"],
        });
      }
    }
    // Posts.removeAt(0);
    List id = await UserModel().getLikedPost(tempID);
    for (int i = 0; i < Posts.length; i++) {
      print(id);
      if (id.isEmpty) {
        Posts[i]["isLiked"] = false;
      }
      else {
        for (int j = 0; j < id.length; j++) {
          if (Posts[i]["post_id"] == id[j]) {
            Posts[i]["isLiked"] = true;
          } else {
            Posts[i]["isLiked"] = false;
          }
        }
      }
    }
    print(Posts);
    print(tempID);
    print(Posts.length);
    for (int i = 0; i < Posts.length; i++) {
      if (Posts[i]["userID"] == tempID) {
        User_Posts.add(Posts[i]);
        print(Posts[i]["userID"]);
      }
    }

    print(id);
    for (int i = 0; i < Posts.length; i++) {
      for (int j = 0; j < id.length; j++) {
        if (Posts[i]["post_id"] == id[j]) {
          User_LikedPosts.add(Posts[i]);
        }
      }
    }
    setState(() {
      name = tempName;
      email = tempEmail;
      PostimageURL = tempURL;
      userID = tempID;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
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
                          onPressed: () async {
                            ImagePicker imagePiker = ImagePicker();
                            XFile? file = await imagePiker.pickImage(
                                source: ImageSource.gallery);
                            print('${file?.path}');

                            if (file == null) return;
                            String uniqueFileName = DateTime
                                .now()
                                .microsecondsSinceEpoch
                                .toString();

                            Reference referenceRoot =
                            FirebaseStorage.instance.ref();
                            Reference referenceDirImages =
                            referenceRoot.child('images');

                            Reference referenceImageToUpload =
                            referenceDirImages.child(uniqueFileName);

                            try {
                              await referenceImageToUpload
                                  .putFile(File(file.path));

                              imageUrl =
                              await referenceImageToUpload.getDownloadURL();

                              String id = (await SharedPrefs().getData('id'))!;
                              await UserModel().updateUser(
                                  userID: id, key: 'ImageURL', data: imageUrl);
                              await SharedPrefs().updateImageURL(imageUrl);
                              setState(() {
                                imageUrl = imageUrl;
                              });
                            } catch (error) {}
                          },
                          icon: Icon(
                            Icons.camera_alt,
                          ),
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
                      PostDailog(isEdit: false,);
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.add_circle_rounded,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: size.width * 0.01,
                        ),
                        const Text(
                          "Add Post",
                          style: TextStyle(color: Colors.white),
                        )
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
                      const Icon(Icons.edit, color: Colors.white),
                      SizedBox(
                        width: size.width * 0.01,
                      ),
                      const Text(
                        "Edit Profile",
                        style: TextStyle(color: Colors.white),
                      )
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
            DefaultTabController(
              initialIndex: 0,
              length: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: size.width,
                    height: size.height * 0.065,
                    color: Colors.transparent,
                    child: TabBar(
                      onTap: (index) {
                        setState(() {
                          tab = index;
                        });
                      },
                      //dividerColor: const Color(0XFF797979),
                      labelColor: const Color(0XFFF9622E),
                      unselectedLabelColor: const Color(0XFF797979),
                      indicatorColor: const Color(0XFFF9622E),
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0XFFF9622E),
                        fontFamily: 'Inter',
                        letterSpacing: 0.75,
                      ),
                      tabs: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.widgets),
                            SizedBox(
                              width: size.width * 0.025,
                            ),
                            const Text(
                              'My Feeds',
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.favorite),
                            SizedBox(
                              width: size.width * 0.025,
                            ),
                            const Text(
                              'Liked',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Builder(
                    builder: (_) {
                      if (tab == 0) {
                        return SizedBox(
                          width: size.width,
                          child: ListView.builder(
                            // padding: EdgeInsets.symmetric(vertical: 10,horizontal: 50),
                            itemCount: User_Posts.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 7, horizontal: 10),
                                child: PostTile(
                                  imageUrl: User_Posts[index]["post_images"],
                                  name: User_Posts[index]["name"],
                                  date: User_Posts[index]['date'],
                                  profileUrl: User_Posts[index]["user_image"],
                                  title: User_Posts[index]["title"],
                                  Description: User_Posts[index]["description"],
                                  isHomeScreen: false,
                                  userID: userID,
                                  post_id: User_Posts[index]["post_id"],
                                  isLiked: User_Posts[index]["isLiked"],
                                  isApproved: User_Posts[index]["isApproved"],
                                  YOM: Posts[index]["YOM"],
                                  CC: Posts[index]["CC"],
                                  email: Posts[index]["email"],
                                  companyname: Posts[index]["companyname"],
                                ),
                              );
                            },
                          ),
                        );
                      } else if (tab == 1) {
                        return SizedBox(
                          width: size.width,
                          child: ListView.builder(
                            itemCount: User_LikedPosts.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 7),
                                child: PostTile(
                                  imageUrl: User_LikedPosts[index]
                                  ["post_images"],
                                  name: User_LikedPosts[index]["name"],
                                  date: User_LikedPosts[index]["date"],
                                  profileUrl: User_LikedPosts[index]
                                  ["user_image"],
                                  title: User_LikedPosts[index]["title"],
                                  Description: User_LikedPosts[index]
                                  ["description"],
                                  isHomeScreen: true,
                                  userID: userID,
                                  post_id: User_LikedPosts[index]["post_id"],
                                  isLiked: User_LikedPosts[index]["isLiked"],
                                  isApproved: User_LikedPosts[index]["isApproved"],
                                  YOM: User_LikedPosts[index]["YOM"],
                                  CC: User_LikedPosts[index]["CC"],
                                  email: User_LikedPosts[index]["email"],
                                  companyname: User_LikedPosts[index]["companyname"],
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return const SizedBox(
                          width: 0,
                          height: 0,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: SizedBox(
                height: size.height * 0.5,
                child: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) =>
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        // child: const PostTile(),
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
