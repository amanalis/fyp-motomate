import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:motomate/screens/Registration%20Screens/login.dart';

class UserModel {
  Future<String?> addUser({
    required int userID,
    required String name,
    required String email,
    required String phone,
    required String imageURL,
  }) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('user_data');
      // Call the user's CollectionReference to add a new user
      await users.doc(userID.toString()).set({
        'Email': email,
        'Name': name,
        'Phone': phone,
        'ImageURL' : imageURL,
      });
      return 'success';
    } catch (e) {
      return 'Error adding user';
    }
  }

  Future<List<Map<String, dynamic>>> usersList() async {
    List<Map<String, dynamic>> usersList = [];
    List<String> userIDs = await getUserIdsList();
    CollectionReference users =
        FirebaseFirestore.instance.collection('user_data');
    for (int i = 0; i < userIDs.length; i++) {
      final snapshot = await users.doc(userIDs[i]).get();
      final data = snapshot.data() as Map<String, dynamic>;
      usersList.add(
        {'userID': userIDs[i], 'name': data['Name'], 'email': data['Email'], 'imageURL' : data['ImageURL'], 'phone': data['Phone']},
      );
    }
    return usersList;
  }

  Future<List<String>> getUserIdsList() async {
    List<String> usersIDs = [];
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('user_data').get();
    for (var doc in snapshot.docs) {
      usersIDs.add(doc.id);
    }
    return usersIDs;
  }

  Future<String?> updateUser({
    required String userID,
    required String key,
    required String data,
  }) async {
    try {
      FirebaseFirestore.instance.collection('user_data').doc(userID).update({
        key: data,
      });
      return 'success';
    } catch (e) {
      return 'Error adding user';
    }
  }

  Future<String?> getUserID(String email) async {
    try {
      String? id;
      await FirebaseFirestore.instance
          .collection('user_data')
          .where('Email', isEqualTo: email)
          .get()
          .then((value) {
        id = value.docs.first.id;
      });
      return id;
    } catch (e) {
      return 'Error fetching user';
    }
  }

  Future<String?> getUserData(String userID, String key) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('user_data');
      final snapshot = await users.doc(userID).get();
      final data = snapshot.data() as Map<String, dynamic>;
      return data[key];
    } catch (e) {
      return 'Error fetching user';
    }
  }

  Future<bool> checkIfEmailExists(String email) async {
    bool isExists = false;
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('user_data')
          .where(
            'Email',
            isEqualTo: email,
          )
          .get();

      if (snapshot.docs.isNotEmpty) {
        isExists = true;
      }
      return isExists;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getUsersCount() async {
    int count = await FirebaseFirestore.instance
        .collection('user_data')
        .get()
        .then((value) => value.size);
    return count;
  }

  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut().then(
          (value) => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const Login(),
            ),
            (route) => false,
          ),
        );
  }
}

class PostModel{

  Future<String?> addPost({
    required int postID,
    required String userID,
    required String title,
    required String description,
    required List imageURL,
  }) async {
    try {
      CollectionReference posts =
      FirebaseFirestore.instance.collection('posts');
      // Call the user's CollectionReference to add a new user
      await posts.doc(postID.toString()).set({
        'user_id' : userID,
        'title' : title,
        'description' : description,
        'images' : imageURL,
      });
      return 'Added post Successfully.';
    } catch (e) {
      return 'Error adding post.';
    }
  }

  Future<List<String>> getPostIdsList() async {
    List<String> postIDs = [];
    QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection('posts').get();
    for (var doc in snapshot.docs) {
      postIDs.add(doc.id);
    }
    return postIDs;
  }

  // Future<List<Map<String, dynamic>>> usersList() async {
  //   List<Map<String, dynamic>> usersList = [];
  //   List<String> postIDs = await getPostIdsList();
  //   CollectionReference users =
  //   FirebaseFirestore.instance.collection('posts');
  //   for (int i = 0; i < postIDs.length; i++) {
  //     final snapshot = await users.doc(postIDs[i]).get();
  //     final data = snapshot.data() as Map<String, dynamic>;
  //     usersList.add(
  //       {'userID': userIDs[i], 'name': data['Name'], 'email': data['Email'], 'imageURL' : data['ImageURL'], 'phone': data['Phone']},
  //     );
  //   }
  //   return usersList;
  // }

  Future<String?> updatePost({
    required String postID,
    required String key,
    required String data,
  }) async {
    try {
      FirebaseFirestore.instance.collection('posts').doc(postID).update({
        key: data,
      });
      return 'Post Updated';
    } catch (e) {
      return 'Error updating Post';
    }
  }

  Future<String?> getPostID(String userID) async {
    try {
      String? id;
      await FirebaseFirestore.instance
          .collection('posts')
          .where('user_id', isEqualTo: userID)
          .get()
          .then((value) {
        id = value.docs.first.id;
      });
      return id;
    } catch (e) {
      return 'Error fetching post';
    }
  }

  Future<String?> getPostData(String postID, String key) async {
    try {
      CollectionReference users =
      FirebaseFirestore.instance.collection('posts');
      final snapshot = await users.doc(postID).get();
      final data = snapshot.data() as Map<String, dynamic>;
      return data[key];
    } catch (e) {
      return 'Error fetching post';
    }
  }

  Future<int> getPostCount() async {
    int count = await FirebaseFirestore.instance
        .collection('posts')
        .get()
        .then((value) => value.size);
    return count;
  }
}
