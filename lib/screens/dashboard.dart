import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

class _DashBoardState extends State<DashBoard> with WidgetsBindingObserver {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  String name = "Loading...";
  String userID = "Loading...";
  String email = "Loading...";
  String imageURL =
      'https://icon-library.com/images/default-profile-icon/default-profile-icon-24.jpg';
  String PostimageURL =
      'https://icon-library.com/images/default-profile-icon/default-profile-icon-24.jpg';

  void getData() async {
    String tempName = (await UserModel().getUserData(FirebaseAuth.instance.currentUser!.uid, 'Name'))!;
    String tempEmail = (await UserModel().getUserData(FirebaseAuth.instance.currentUser!.uid, 'Email'))!;
    String tempURL = (await UserModel().getUserData(FirebaseAuth.instance.currentUser!.uid, 'ImageURL'))!;
    String tempID = (await FirebaseAuth.instance.currentUser!.uid)!;
    String tempphonenumber = (await UserModel().getUserData(FirebaseAuth.instance.currentUser!.uid, 'Phone'))!;
    String tempaccount = (await UserModel().getUserData(FirebaseAuth.instance.currentUser!.uid, 'proaccount'))!;
    SharedPrefs().saveUserDataInPrefs(
      tempName,
      tempID,
      tempEmail,
      "password",
      tempphonenumber,
      tempURL,
      tempaccount,
    );

    setState(() {
      name = tempName;
      email = tempEmail;
      imageURL = tempURL;
      userID = tempID;
    });
  }

  List<Map<String, dynamic>> Posts = [];
  List<Map<String, dynamic>> Searched_Posts = [];

  // List<Map<String, dynamic>> Year_Posts = [];
  // List<Map<String, dynamic>> Company_Posts = [];

  void getPostData(bool _isChanged) async {
    if (_isChanged == false) {
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
    }
    String tempName = (await SharedPrefs().getData("name"))!;
    String tempEmail = (await SharedPrefs().getData("email"))!;
    String tempURL = (await SharedPrefs().getData("imageURL"))!;
    String tempID = (await SharedPrefs().getData("id"))!;
    print(tempID);
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
          "CC": doc[i]["CC"],
          "email": doc[i]["email"],
          "companyname": doc[i]["companyname"],
        });
      }
    }
    //Searched_Posts = Posts;
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
    // String postID = (await PostModel().getNewestDocumentId())!;
    // print(postID);
    print(Posts);
    print(_searchController.text);
    print(Posts.length);
    Searched_Posts.clear();
    for (int i = 0; i < Posts.length; i++) {
      if (Posts[i]["CC"].contains(_searchController.text)) {
        Searched_Posts.add(Posts[i]);
        print(Posts[i]["post_id"]);
      } else if (Posts[i]["CC"] == _searchController.text) {
        Searched_Posts.add(Posts[i]);
      } else if (Posts[i]["YOM"].contains(_searchController.text)) {
        Searched_Posts.add(Posts[i]);
        print(Posts[i]["post_id"]);
      } else if (Posts[i]["YOM"] == _searchController.text) {
        Searched_Posts.add(Posts[i]);
        print(Posts[i]["post_id"]);
      } else if (Posts[i]["companyname"].contains(_searchController.text)) {
        Searched_Posts.add(Posts[i]);
        print(Posts[i]["post_id"]);
      } else if (Posts[i]["companyname"] == _searchController.text) {
        Searched_Posts.add(Posts[i]);
        print(Posts[i]["post_id"]);
      } else if (_searchController.text == "All") {
        Searched_Posts.add(Posts[i]);
      } else if (_searchController.text.isEmpty) {
        Searched_Posts.add(Posts[i]);
      } else if (Posts[i]["name"] == _searchController.text) {
        Searched_Posts.add(Posts[i]);
        print(Posts[i]["post_id"]);
      } else if (Posts[i]["name"].contains(_searchController.text)) {
        Searched_Posts.add(Posts[i]);
        print(Posts[i]["post_id"]);
      }
    }

    // for (int i = 0; i < Posts.length; i++) {
    //   if (Posts[i]["CC"].contains(_searchController.text) ||
    //       Posts[i]["YOM"].contains(_searchController.text) ||
    //       Posts[i]["companyname"].contains(_searchController.text) ||
    //       Posts[i]["title"].contains(_searchController.text) ||
    //       Posts[i]["username"].contains(_searchController.text)
    //   ) {
    //     Searched_Posts.add(Posts[i]);
    //   }
    // }
    Posts.length = 0;
// Search using the indexed hashmap
//     if (_searchController.text == "All") {
//       Searched_Posts.addAll(Posts);
//     } else {
//       if (Search_Posts.containsKey(_searchController.text)) {
//         Searched_Posts.addAll(Search_Posts[_searchController.text]!);
//       }
//     }

// // Print post IDs of searched posts
//     for (var post in Searched_Posts) {
//       print(post["post_id"]);
//     }

    setState(() {
      name = tempName;
      email = tempEmail;
      PostimageURL = tempURL;
      userID = tempID;
      //Searched_Posts = Posts;
    });
    if (_isChanged == false) {
      Navigator.pop(context);
    }
  }

  String proAccountStatus = "";

  void getAccountStatus() async {
    proAccountStatus = (await UserModel()
        .getUserData(_firebaseAuth.currentUser!.uid, 'proaccount'))!;
    setState(() {});
  }

  void setStat(String status) async {
    await _firestore
        .collection('user_data')
        .doc(_firebaseAuth.currentUser!.uid)
        .update({'status': status});
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //online
      setStat('Online');
    } else {
      // offline
      setStat('Offline');
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    getData();
    getPostData(false);
    getAccountStatus();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      // proAccountStatus == 'true'
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: proAccountStatus == "true"
          ? FloatingActionButton(
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
            )
          : Container(),
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
          "assets/images/motomate.png",
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
                    onChanged: (a) {
                      // Perform the search here
                      getPostData(true);
                      // LoadingAnimationWidget
                    },
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
                          getPostData(false);
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
              Container(
                height: 50,
                color: Colors.white38,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      _allItems(""),
                      SizedBox(
                        width: 10,
                      ),
                      _singleItems("70CC"),
                      SizedBox(
                        width: 10,
                      ),
                      _singleItems("100CC"),
                      SizedBox(
                        width: 10,
                      ),
                      _singleItems("110CC"),
                      SizedBox(
                        width: 10,
                      ),
                      _singleItems("125CC"),
                      SizedBox(
                        width: 10,
                      ),
                      _singleItems("150CC"),
                      SizedBox(
                        width: 10,
                      ),
                      _singleItems("200CC"),
                      SizedBox(
                        width: 10,
                      ),
                      _singleItems("Suzuki"),
                      SizedBox(
                        width: 10,
                      ),
                      _singleItems("Honda"),
                      SizedBox(
                        width: 10,
                      ),
                      _singleItems("Yamaha"),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  "Searched:${_searchController.text}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  "Home",
                  style: TextStyle(
                    fontFamily: ('GravisPersonal'),
                    fontSize: 24,
                  ),
                ),
              ),
              SizedBox(
                width: size.width,
                child: ListView.builder(
                  itemCount: Searched_Posts.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Searched_Posts.isEmpty
                        ? Text("No Posts Available.")
                        : PostTile(
                            imageUrl: Searched_Posts[index]["post_images"],
                            name: Searched_Posts[index]["name"],
                            date: Searched_Posts[index]['date'],
                            profileUrl: Searched_Posts[index]["user_image"],
                            title: Searched_Posts[index]["title"],
                            Description: Searched_Posts[index]["description"],
                            isHomeScreen: true,
                            userID: userID,
                            post_id: Searched_Posts[index]["post_id"],
                            isLiked: Searched_Posts[index]["isLiked"],
                            isApproved: Searched_Posts[index]["isApproved"],
                            YOM: Searched_Posts[index]["YOM"],
                            CC: Searched_Posts[index]["CC"],
                            email: Searched_Posts[index]["email"],
                            companyname: Searched_Posts[index]["companyname"],
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _allItems(String searchText) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          elevation: 2, backgroundColor: Colors.deepOrangeAccent),
      onPressed: () {
        setState(() {
          _searchController.text = "All";
        });
        getPostData(false);
      },
      child: Text(
        "All",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _singleItems(String searchText) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          elevation: 2, backgroundColor: Colors.deepOrangeAccent),
      onPressed: () {
        setState(() {
          _searchController.text = searchText;
        });
        getPostData(false);
      },
      child: Text(
        searchText,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
