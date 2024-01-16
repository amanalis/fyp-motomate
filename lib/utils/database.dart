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
        'ImageURL': imageURL,
        "liked_post_id": []
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
        {
          'userID': userIDs[i],
          'name': data['Name'],
          'email': data['Email'],
          'imageURL': data['ImageURL'],
          'phone': data['Phone']
        },
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


  Future<String?> updateLikedPostId({
    required String postId,
    required String userID,
  }) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> res = await FirebaseFirestore
          .instance
          .collection("user_data")
          .doc(userID)
          .get();

      final tempData = res.data();
      List<dynamic> likedPostIds = tempData?['liked_post_id'] ?? [];

      // Check if the post ID already exists in the list
      if (!likedPostIds.contains(postId)) {
        likedPostIds.add(postId);

        await FirebaseFirestore.instance.collection('user_data').doc(userID).update({
          "liked_post_id": likedPostIds,
        });

        return 'success';
      } else {
        // If the post ID already exists, you can return a message or handle it accordingly
        return 'Post ID already exists in the liked list';
      }
    } catch (e) {
      return 'Error adding user';
    }
  }

  Future<String?> delete_liked_post_id({
    required String post_id,
    required String userID,
  }) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> res = await FirebaseFirestore
          .instance
          .collection("user_data")
          .doc(userID)
          .get();

      final tempdata = res.data();
      List Post_id = tempdata!['liked_post_id'];
      print(Post_id);
      Post_id.remove(post_id);
      FirebaseFirestore.instance.collection('user_data').doc(userID).update({
        "liked_post_id": Post_id,
      });
      print(Post_id);
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

  Future<List> getLikedPost(
    String userID,
  ) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('user_data');
      final snapshot = await users.doc(userID).get();
      final data = snapshot.data() as Map<String, dynamic>;
      return data["liked_post_id"];
    } catch (e) {
      return [];
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

class PostModel {
  Future<String?> addPost({
    required String date,
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
        'user_id': userID,
        'title': title,
        'description': description,
        'images': imageURL,
        'date':date,
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

  void delete_post(String id) async {
    await FirebaseFirestore.instance.collection("posts").doc(id).delete();
    // UserModel().update_liked_post_id(post_id: post_id, userID: userID)
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
    required String date,
    required String postID,
    required String title,
    required String description,
    required List imageURL,
  }) async {
    try {
      FirebaseFirestore.instance.collection('posts').doc(postID).update({
        'title': title,'description': description,'images':imageURL,'date':date
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

  // Future<dynamic> getPostDocument(String postID) async {
  //   try {
  //     var collectionReference =
  //     FirebaseFirestore.instance.collection('posts');
  //     var doc = await collectionReference.doc(postID).get();
  //     return doc.data() as Map<String, dynamic>;
  //   } catch (e) {
  //     rethrow;
  //   }
  Future<List<Map<String, dynamic>>> getPostDocument() async {
    // Replace 'yourCollection' with the actual name of your Firestore collection
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('posts').get();

    List<Map<String, dynamic>> dataList = [];

    querySnapshot.docs.forEach((DocumentSnapshot<Map<String, dynamic>> doc) {
      Map<String, dynamic> data = doc.data()!;
      // Add document ID to the data
      data['documentID'] = doc.id;
      dataList.add(data);
    });
    return dataList;
  }
}

// message

// class Message {
//   final String senderId;
//   final String senderEmail;
//   final String receiverId;
//   final String message;
//   final Timestamp timestamp;
//
//   Message({
//     required this.senderId,
//     required this.senderEmail,
//     required this.receiverId,
//     required this.message,
//     required this.timestamp,
//   });
//
//   //convert to a map
//   Map<String, dynamic> toMap(){
//     return {
//       'senderId' : senderId,
//       'senderEmail' : senderEmail,
//       'receiverId' : receiverId,
//       'message' : message,
//       'timestamp' : timestamp
//     };
//   }
//
// }