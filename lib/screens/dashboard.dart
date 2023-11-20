import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motomate/repository/authentication_repository/authentication_repostory.dart';
import 'package:motomate/reusablewidgets/posttile.dart';
import 'package:motomate/reusablewidgets/side_menu.dart';
import 'package:motomate/utils/shared_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/database.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Dashboard_Content(),
    );
  }
}

class Dashboard_Content extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Dashboard();
}

class _Dashboard extends State<Dashboard_Content> {
  final TextEditingController _searchController = TextEditingController();
  Color _favIconColor = Colors.grey;
  String name = "";
  String email = "";

  void getData() async {
    String tempname = (await Shared_Prefs().getData("name"))!;
    String tempemail = (await Shared_Prefs().getData("email"))!;

    setState(() {
      name = tempname;
      email = tempemail;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Side_Menu(name: name, email: email),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        // leading: const IconButton(
        //   onPressed: null,
        //   icon: Icon(Icons.menu_outlined),
        //   color: Colors.black,
        // ),
        title: Image.asset(
          "images/motomate.png",
          height: 50,
        ),
        elevation: 0,
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 20, left: 7),
            child: IconButton(
              onPressed: () {

              },
              icon: Icon(Icons.person),
              color: Colors.black.withOpacity(0.6),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(30.0),
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
                          borderSide: BorderSide(color: Colors.deepOrange),
                          borderRadius: BorderRadius.circular(20)),
                      hintText: 'Search...',
                      // Add a clear button to the search bar
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () => _searchController.clear(),
                      ),
                      suffixIconColor: MaterialStateColor.resolveWith(
                          (states) => states.contains(MaterialState.focused)
                              ? Colors.deepOrange
                              : Colors.black),
                      // Add a search icon or button to the search bar
                      prefixIcon: IconButton(
                        icon: Icon(Icons.search),
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
                height: 20,
              ),
              Row(
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
              SizedBox(height: 20),
              PostTile(),
              SizedBox(height: 20),
              PostTile(),
              SizedBox(height: 20),
              PostTile(),
            ],
          ),
        ),
      ),
    );
  }
}


