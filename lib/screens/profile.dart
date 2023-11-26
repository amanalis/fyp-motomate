import 'package:flutter/material.dart';
import 'package:motomate/reusablewidgets/post_dailog.dart';
import 'package:motomate/screens/edit_profile.dart';
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

  void getData() async {
    String tempName = (await SharedPrefs().getData("name"))!;
    String tempEmail = (await SharedPrefs().getData("email"))!;

    setState(() {
      name = tempName;
      email = tempEmail;
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
                  margin: const EdgeInsets.only(top: 20),
                  child: const CircleAvatar(
                    radius: 74,
                    backgroundColor: Colors.black,
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: AssetImage('images/bheem.jpg'),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 135),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(left: size.width * 0.175)),
                      SizedBox(
                        width: size.width * 0.05,
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
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
                        const Icon(Icons.add_circle_rounded),
                        SizedBox(
                          width: size.width * 0.01,
                        ),
                        const Text("Add Post")
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfileScreen(),
                        ));
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.edit),
                      SizedBox(
                        width: size.width * 0.01,
                      ),
                      const Text("Edit Profile")
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
