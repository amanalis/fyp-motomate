import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'chat_page.dart';
import 'dashboard.dart';

class ChatMenu extends StatefulWidget {
  const ChatMenu({super.key});

  @override
  State<ChatMenu> createState() => _ChatMenuState();
}

class _ChatMenuState extends State<ChatMenu> with WidgetsBindingObserver {
  // instance of auth
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //profile picture
  String imageURL =
      'https://icon-library.com/images/default-profile-icon/default-profile-icon-24.jpg';

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    // TODO: implement initState
    super.initState();
  }

  void setStat(String status) async {
    await _firestore.collection('user_data').doc(_auth.currentUser!.uid).update({
      'status' : status
    });
  }

  void didChangeAppLifecycleState(AppLifecycleState state){
    if(state == AppLifecycleState.resumed){
      //online
      setStat('Online');
    }
    else{
      // offline
      setStat('Offline');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const DashBoard(),
              ),
                  (route) => false), icon: Icon(Icons.arrow_back),),
          title: Text(
            "Chats",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.deepOrange,
          centerTitle: true,
        ),
        body: _buildUserList());
  }

  // build a list of user except for the current logged in user
  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('user_data').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("error");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading..");
        }

        return ListView(
          children: snapshot.data!.docs
              .map<Widget>((doc) => _buildUserListItem(doc))
              .toList(),
        );
      },
    );
  }

  // build individual user list items
  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    // display all users except current user
    if (_auth.currentUser!.email != data['Email']) {
      return ListTile(
        leading: CircleAvatar(
          radius: 18,
          backgroundColor: Colors.black,
          child: CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(data['ImageURL']),
          ),
        ),
        // Icon(
        //   Icons.account_circle_outlined,
        //   color: Colors.deepOrangeAccent,
        // ),
        title: Text(data['Name']),
        trailing:
          data['status'] == 'Online'
        ? Icon(Icons.circle,color: Colors.green,)
        : Icon(Icons.circle,color: Colors.red,),
        onTap: () {
          // pass the clicked user's UID to the chat page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                recieveruserEmail: data['Email'],
                recieverUserId: data['userID'],
                recieverName: data['Name'],
                recieverProfilePic: data['ImageURL'],
              ),
            ),
          );
        },
      );
    } else {
      //return empty container
      return Container();
    }
  }
}
