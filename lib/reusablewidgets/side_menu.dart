import 'package:flutter/material.dart';

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
            accountName: Text(widget.name),
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
            onTap: () =>  AuthenticationRepository.instance.logout(),
          ),
        ],
      ),
    );
  }
}


/*class Side_Menu extends StatelessWidget{

  const Side_Menu({super.key, required this.name, required this.email});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
              accountName: Text(name),
              accountEmail: Text(email),
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

}*/