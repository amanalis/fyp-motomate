import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:motomate/screens/login.dart';

class UserModel {
  Future<String?> addUser(
      {required int userID,
      required String name,
      required String email,
      required String phone}) async {
    try {
      print("inside Add USer func");
      CollectionReference users =
          FirebaseFirestore.instance.collection('user_data');
      // Call the user's CollectionReference to add a new user
      await users.doc(userID.toString()).set({
        'Email': email,
        'Name': name,
        'Phone': phone,
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
        {'userID': userIDs[i], 'name': data['name'], 'email': data['email']},
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
          .where('email',
              isEqualTo:
                  email) // Search for documents with email field equal to user's input
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

  Future<void> signout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => Login(),
        ),
        (route) => false);
  }
}
