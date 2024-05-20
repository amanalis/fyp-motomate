import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../model/message.dart';
import '../utils/database.dart';
import 'chat_page.dart';
import 'dashboard.dart';

class ChatMenu extends StatefulWidget {
  const ChatMenu({Key? key}) : super(key: key);

  @override
  State<ChatMenu> createState() => _ChatMenuState();
}

class _ChatMenuState extends State<ChatMenu> with WidgetsBindingObserver {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String imageURL =
      'https://icon-library.com/images/default-profile-icon/default-profile-icon-24.jpg';

  String proAccountStatus = "";

  void getAccountStatus() async {
    proAccountStatus = (await UserModel()
        .getUserData(_auth.currentUser!.uid, 'proaccount'))!;
    setState(() {});
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
    getAccountStatus();
  }

  void setStat(String status) async {
    await _firestore.collection('user_data').doc(_auth.currentUser!.uid).update({
      'status': status
    });
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setStat('Online');
    } else {
      setStat('Offline');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const DashBoard()),
                (route) => false,
          ),
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          "Chats",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
      ),
      body: _buildUserList(),
    );
  }

  // build a list of users with whom messages have been exchanged
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

        List<DocumentSnapshot> userList = snapshot.data!.docs;

        return ListView(
          children: userList
              .map<Widget>((doc) => _buildUserListItem(doc))
              .toList(),
        );
      },
    );
  }

  // build individual user list items
  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    if (_auth.currentUser!.email != data['Email']) {
      return FutureBuilder<bool>(
        future: _hasChatRoom(data['userID']),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading...");
          }

          if (snapshot.hasError) {
            return const Text("Error");
          }

          bool hasChatRoom = snapshot.data ?? false;

          if (hasChatRoom) {
            return ListTile(
              leading: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.black,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(data['ImageURL']),
                ),
              ),
              title: Text(data['Name']),
              trailing: data['status'] == 'Online'
                  ? Icon(
                Icons.circle,
                color: Colors.green,
              )
                  : Icon(
                Icons.circle,
                color: Colors.red,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      recieveruserEmail: data['Email'],
                      recieverUserId: data['userID'],
                      recieverName: data['Name'],
                      recieverProfilePic: data['ImageURL'],
                      recieverfcmtoken: data['fcm_token'],
                    ),
                  ),
                );
              },
            );
          } else {
            return const SizedBox(); // Return an empty SizedBox if no chat room exists
          }
        },
      );
    } else {
      return Container(); // Return an empty container for the current user
    }
  }

  // Check if a chat room exists with messages exchanged
  Future<bool> _hasChatRoom(String otherUserId) async {
    String userId = _auth.currentUser!.uid;
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .get();

    return querySnapshot.docs.isNotEmpty;
  }
}