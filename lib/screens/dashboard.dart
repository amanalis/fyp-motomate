import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:motomate/reusablewidgets/post_dailog.dart';
import 'package:motomate/reusablewidgets/posttile.dart';
import 'package:motomate/reusablewidgets/side_menu.dart';
import 'package:motomate/utils/database.dart';
import 'package:motomate/utils/shared_prefs.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final TextEditingController _searchController = TextEditingController();
  String name = "Loading...";
  String userID = "Loading...";
  String email = "Loading...";
  String imageURL =
      'https://icon-library.com/images/default-profile-icon/default-profile-icon-24.jpg';
  List<Map<String, dynamic>> Posts = [];

  void getData() async {

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
      // String? status= 'Online';
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
    print(id);

    for (int i = 0; i < Posts.length; i++) {
      if (id.isEmpty) {
        Posts[i]["isLiked"] = false;
      } else {
        for (int j = 0; j < id.length; j++) {
          if (Posts[i]["post_id"] == id[j]) {
            Posts[i]["isLiked"] = true;
          } else {
            Posts[i]["isLiked"] = false;
          }
        }
      }
    }
    setState(() {
    });
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostDailog(
                isEdit: false,
              ),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.deepOrange,
        elevation: 0,
      ),
      drawer: SideMenu(
        name: name,
        email: email,
        imageUrl: imageURL,
      ),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        // leading: const IconButton(
        //   onPressed: null,
        //   icon: Icon(Icons.menu_outlined),
        //   color: Colors.black,
        // ),
        title: Image.asset(
          "images/motomate.png",
          height: size.height * 0.06,
        ),
        elevation: 0,
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 14),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.black,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(imageURL),
              ),
            ),
          )
          // Container(
          //   margin: const EdgeInsets.only(right: 10, left: 20),
          //   child: IconButton(
          //     onPressed: () {},
          //     icon: const Icon(Icons.person),
          //     color: Colors.black.withOpacity(0.6),
          //   ),
          // )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  // Add padding around the search bar
                  padding: const EdgeInsets.symmetric(horizontal: 1.0),
                  // Use a Material design search bar
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.deepOrange),
                          borderRadius: BorderRadius.circular(20)),
                      hintText: 'Search...',
                      // Add a clear button to the search bar
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => _searchController.clear(),
                      ),
                      suffixIconColor: MaterialStateColor.resolveWith(
                          (states) => states.contains(MaterialState.focused)
                              ? Colors.deepOrange
                              : Colors.black),
                      // Add a search icon or button to the search bar
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          // Perform the search here
                        },
                      ),
                      prefixIconColor: MaterialStateColor.resolveWith(
                          (states) => states.contains(MaterialState.focused)
                              ? Colors.deepOrange
                              : Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: [
                    Text(
                      "Home",
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
                      return PostTile(
                        imageUrl: Posts[index]["post_images"],
                        name: Posts[index]["name"],
                        date: Posts[index]['date'],
                        profileUrl: Posts[index]["user_image"],
                        title: Posts[index]["title"],
                        Description: Posts[index]["description"],
                        isHomeScreen: true,
                        userID: userID,
                        post_id: Posts[index]["post_id"],
                        isLiked: Posts[index]["isLiked"],
                        isApproved: Posts[index]["isApproved"],
                        YOM: Posts[index]["YOM"],
                        CC: Posts[index]["CC"],
                        email: Posts[index]["email"],
                        companyname: Posts[index]["companyname"],
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
