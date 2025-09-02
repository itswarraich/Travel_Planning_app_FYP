// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:flutter/material.dart';
import 'package:travel_planning_fyp/UIScreens/AllBottomScreens.dart';
import 'package:travel_planning_fyp/UIScreens/SignIN.dart';
import 'package:travel_planning_fyp/adminScreens/AdminChooseScreen.dart';

class SplashService {
  void isLogin(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final user = _auth.currentUser;

    if (user != null) {
      String uid = user.uid;

      // Initialize Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Fetch user data from Firestore
      firestore.collection("Users").doc(uid).get().then((DocumentSnapshot doc) {
        if (doc.exists) {
          String role = doc["role"]; // Fetch the role field
          if (role == "admin") {
            Timer(
              const Duration(seconds: 3),
              () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Adminchoosescreen()),
              ),
            );
          } else {
            Timer(
              const Duration(seconds: 3),
              () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Allbottom(initialIndex: 0)),
              ),
            );
          }
        } else {
          // User document does not exist
          Timer(
            const Duration(seconds: 3),
            () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SignIN()),
            ),
          );
        }
      }).catchError((error) {
        debugPrint("Error fetching user data: $error");
        Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SignIN()),
          ),
        );
      });
    } else {
      // User is not logged in
      Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignIN()),
        ),
      );
    }
  }
}