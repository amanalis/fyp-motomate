import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Side_Menu extends StatelessWidget{
  const Side_Menu({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
              accountName: Text("Aman Ali"),
              accountEmail: Text("aman.salim@gmail.com"),
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
            onTap: () => print("Tapped Account"),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => print("Tapped Settings"),
          ),ListTile(
            leading: Icon(Icons.logout),
            title: Text('Log Out'),
            onTap: () => print("Tapped Log Out"),
          ),
        ],
      ),
    );
  }

}