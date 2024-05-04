import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:motomate/screens/Registration%20Screens/pro_account_confirmation.dart';
import 'package:motomate/screens/chats_menu.dart';
import 'package:motomate/screens/dashboard.dart';
import 'package:motomate/screens/profile.dart';
import 'package:motomate/utils/database.dart';

class SideMenu extends StatefulWidget {
  final String name;
  final String email;
  final String imageUrl;

  const SideMenu({
    super.key,
    required this.name,
    required this.email,
    required this.imageUrl,
  });

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String proAccountStatus = "";

  void getAccountStatus() async {
    proAccountStatus = (await UserModel()
        .getUserData(_firebaseAuth.currentUser!.uid, 'proaccount'))!;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAccountStatus();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              widget.name,
            ),
            accountEmail: Text(
              widget.email,
            ),
            currentAccountPicture: Stack(children: [
              CircleAvatar(
                radius: 74,
                backgroundColor: Colors.black,
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: NetworkImage(widget.imageUrl),
                ),
              ),
              proAccountStatus == "true"
              ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: Container(
                      height: size.height * 0.03,
                      decoration: const BoxDecoration(
                          borderRadius:
                          BorderRadius.all(Radius.circular(100))),
                      child: Image.asset("assets/images/Premium_Bagde.png",height: size.height * 0.06,),
                    ),
                  ),
                ],
              )
                  :Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: Container(
                      height: size.height * 0.03,
                      decoration: const BoxDecoration(
                          borderRadius:
                          BorderRadius.all(Radius.circular(100))),
                    ),
                  ),
                ],
              ),
            ]),
            decoration: const BoxDecoration(color: Colors.deepOrangeAccent),
          ),
          ListTile(
            leading: const Icon(Icons.account_circle_outlined),
            title: const Text('Account'),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                )),
          ),
          ListTile(
            leading: const Icon(Icons.home_filled),
            title: const Text('Home'),
            onTap: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const DashBoard(),
                ),
                (route) => false),
          ),
          proAccountStatus == "true"
          ? ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('Chats'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChatMenu(),
              ),
            ),
          )
          :Container(),
          ListTile(
            leading: const Icon(Icons.rocket),
            title: const Text('Get Pro-Account'),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Pro_Account_Confirmation(),
                )),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () => print("Tapped Settings"),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log Out'),
            onTap: () async => await UserModel().signOut(context),
          ),
        ],
      ),
    );
  }
}
