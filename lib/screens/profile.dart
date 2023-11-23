import 'package:flutter/material.dart';

import '../reusablewidgets/posttile.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(right: 10, left: 10),
        color: Colors.white,
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //       colors: [Colors.white, Colors.orange],
        //       begin: Alignment.topCenter,
        //       end: Alignment.bottomCenter),
        // ),
        constraints: const BoxConstraints.expand(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: size.height * 0.045,
            ),
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 80),
                  child: CircleAvatar(
                    radius: 74,
                    backgroundColor: Colors.black,
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: AssetImage('images/bheem.jpg'),
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: 190),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(left: size.width * 0.175)),
                        SizedBox(
                          width: size.width * 0.05,
                        ),
                        Container(
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.black,
                          ),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                        ),
                      ],
                    )),
              ],
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Text(
              "UserName",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 23,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "You valuable quotes are here xD",
                style: TextStyle(color: Colors.black54, fontSize: 15),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue[500],
                    ),
                    onPressed: () {},
                    child: Row(
                      children: [
                        Icon(Icons.add_circle_rounded),
                        SizedBox(
                          width: size.width * 0.01,
                        ),
                        Text("Add Thoughts")
                      ],
                    )),
                SizedBox(
                  width: size.width * 0.04,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.grey[500]),
                    onPressed: () {},
                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        SizedBox(
                          width: size.width * 0.01,
                        ),
                        Text("Edit Profile")
                      ],
                    )),
              ],
            ),
            SizedBox(height: size.height*0.015,),
            Divider(
              height: size.height * 0.02,
              thickness: 1,
              color: Colors.orange[700],
            ),
            SingleChildScrollView(
              child: Container(
                child: SizedBox(
                  height: size.height*0.48,
                  child: ListView.builder(
                    itemCount: 2,
                    itemBuilder: (context, index) =>
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(3),
                          child: PostTile(),
                        ),
                  ),),
              ),
            )
          ],
        ),
      ),
    );
  }
}
