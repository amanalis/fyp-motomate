/*
import 'package:flutter/material.dart';
import 'package:motomate/reusablewidgets/posttile.dart';
import '../reusablewidgets/side_menu.dart';
import '../utils/shared_prefs.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  String name = "";
  String email = "";

  void getData() async {
    String tempname = (await SharedPrefs().getData("name"))!;
    String tempemail = (await SharedPrefs().getData("email"))!;

    setState(() {
      name = tempname;
      email = tempemail;
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
      drawer: SideMenu(name: name, email: email),
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
        child: Column(children: [
          SizedBox(
            height: size.height * 0.04,
          ),
          Align(
            alignment: Alignment.center,
            child: ClipOval(
              child: Container(
                color: Colors.orangeAccent,
                height: size.height * 0.25,
                width: size.height * 0.25,
                child: Image.asset(
                  "images/bheem.jpg",
                  height: size.height * 0.25,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          Text(
            name,
            style: const TextStyle(color: Colors.orange),
          ),
          Text(
            email,
            style: const TextStyle(color: Colors.orange),
          ),
          const Divider(thickness: 0.1),
          SizedBox(
            height: size.height * 0.5,
            child: ListView.builder(
              itemCount: 2,
              itemBuilder: (context, index) => 
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const PostTile(),
                  ),
            ),
          )
        ]),
      ),
    );
  }
}
*/
