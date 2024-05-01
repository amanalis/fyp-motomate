import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:motomate/reusablewidgets/posttile.dart';
import 'package:motomate/screens/Admin/admin_posttile.dart';
import 'package:motomate/utils/database.dart';

import '../../utils/shared_prefs.dart';

class PostToApprove extends StatefulWidget {
  const PostToApprove({super.key});

  @override
  State<PostToApprove> createState() => _PostToApproveState();
}

class _PostToApproveState extends State<PostToApprove> {
  String name = "Loading...";
  String userID = "Loading...";
  String email = "Loading...";
  String imageURL =
      'https://icon-library.com/images/default-profile-icon/default-profile-icon-24.jpg';
  List<Map<String, dynamic>> Posts = [];

  void getData() async {

    //loader animator
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
    setState(() {
      name = tempName;
      email = tempEmail;
      imageURL = tempURL;
      userID = tempID;
    });
    int count = await PostModel().getPostCount();

    for (int i = count-1; i >= 0; i--) {
      var doc = await PostModel().getPostDocument();

      String? name =
          await UserModel().getUserData(doc[i]["userID"].toString(), "Name");
      String? user_image =
          await UserModel().getUserData(doc[i]["userID"], "ImageURL");
      if (doc[i]["isApproved"] == false && doc[i]["isRejected"] == false) {
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
          "isRejected": doc[i]["isRejected"],
          "YOM": doc[i]["YOM"],
          "CC" : doc[i]["CC"],
          "companyname": doc[i]["companyname"],
          "email": doc[i]["email"],
        });
      }
    }
    setState(() {});
    Navigator.pop(context);
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
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: Image.asset(
          "assets/images/motomate.png",
          height: size.height * 0.06,
        ),
        elevation: 0,
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height * 0.02,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: [
                    Text(
                      "Post to Approve.",
                      style: TextStyle(
                        fontFamily: ('GravisPersonal'),
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                  width: size.width,
                  child: ListView.builder(
                    itemCount: Posts.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return AdminPosttile(
                        imageUrl: Posts[index]["post_images"],
                        name: Posts[index]["name"],
                        date: Posts[index]['date'],
                        profileUrl: Posts[index]["user_image"],
                        title: Posts[index]["title"],
                        Description: Posts[index]["description"],
                        isHomeScreen: true,
                        userID: userID,
                        post_id: Posts[index]["post_id"],
                        isApproved: Posts[index]["isApproved"],
                        isRejected: Posts[index]['isRejected'],
                        isApprovingPost: true,
                        YOM: Posts[index]["YOM"],
                        CC: Posts[index]['CC'],
                        companyname: Posts[index]['companyname'],
                        email: Posts[index]['email'],
                      );
                    },
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
