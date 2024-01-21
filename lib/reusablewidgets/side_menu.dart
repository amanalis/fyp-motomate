import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
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
            currentAccountPicture: CircleAvatar(
              radius: 74,
              backgroundColor: Colors.black,
              child: CircleAvatar(
                radius: 70,
                backgroundImage: NetworkImage(widget.imageUrl),
              ),
            ),
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
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('Chats'),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatMenu(),
                ),),
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
