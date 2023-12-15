import 'package:flutter/material.dart';
import 'package:motomate/reusablewidgets/post_dailog.dart';
import 'package:motomate/reusablewidgets/posttile.dart';
import 'package:motomate/reusablewidgets/side_menu.dart';
import 'package:motomate/utils/database.dart';
import 'package:motomate/utils/shared_prefs.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: DashboardContent(),
    );
  }
}

class DashboardContent extends StatefulWidget {
  const DashboardContent({super.key});

  @override
  State<StatefulWidget> createState() => _Dashboard();
}

class _Dashboard extends State<DashboardContent> {
  final TextEditingController _searchController = TextEditingController();
  String name = "";
  String email = "";
  String imageURL =
      'https://icon-library.com/images/default-profile-icon/default-profile-icon-24.jpg';
  List<Map<String, dynamic>> Posts = [];

  void getData() async {
    String tempName = (await SharedPrefs().getData("name"))!;
    String tempEmail = (await SharedPrefs().getData("email"))!;
    String tempURL = (await SharedPrefs().getData("imageURL"))!;
    int count = await PostModel().getPostCount();
    for (int i = 2; i < count; i++) {
      var doc = await PostModel().getPostDocument(i.toString());
      String? name = await UserModel().getUserData(doc["user_id"], "Name");
      Posts.add({
        "user_id": doc["user_id"],
        "name": name,
        "title": doc["title"],
        'description': doc["description"],
        "images": doc["images"]
      });
    }
    print(Posts);

    setState(() {
      name = tempName;
      email = tempEmail;
      imageURL = tempURL;
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Post_Dialog(context);
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
                          imageUrl: Posts[index]["images"],
                          name: Posts[index]["name"],
                          date: 'date');
                    },
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
