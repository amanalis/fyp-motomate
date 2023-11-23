import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:motomate/screens/account.dart';
import 'package:motomate/screens/dashboard.dart';

import '../repository/authentication_repository/authentication_repostory.dart';

class Side_Menu extends StatefulWidget {
  final String name;
  final String email;
  const Side_Menu({super.key, required this.name, required this.email});
  @override
  State<Side_Menu> createState() => _Side_MenuState();
}

class _Side_MenuState extends State<Side_Menu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(widget.name, ),
            accountEmail: Text(widget.email),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset("images/bheem.jpg"),
              ),
            ),
            decoration: BoxDecoration(
                color:Colors.deepOrangeAccent
            ),
          ),
          ListTile(
            leading: Icon(Icons.account_circle_outlined),
            title: Text('Account'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Account(),)),
          ),
          ListTile(
            leading: Icon(Icons.home_filled),
            title: Text('Home'),
            onTap: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Dashboard(),),(route) => false),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => print("Tapped Settings"),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Log Out'),
            onTap: () async => await AuthenticationRepository().logout(),
          ),
        ],
      ),
    );
  }
}