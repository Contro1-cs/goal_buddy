import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseInit {
  init() async {
    try {
      var userData = await FirebaseAuth.instance.signInAnonymously();
      DocumentSnapshot huddleRef = await FirebaseFirestore.instance
          .collection('huddles')
          .doc(userData.user!.uid)
          .get();
      if (huddleRef.exists) {
      } else {
        FirebaseFirestore.instance
            .collection('users')
            .doc(userData.user!.uid)
            .set({
          "id": userData.user!.uid,
          "huddles": [],
        });

        FirebaseFirestore.instance
            .collection('huddles')
            .doc(userData.user!.uid)
            .set({
          "owner": userData.user!.uid,
          "name": "Untitled",
          "participants": [userData.user!.uid],
        });
      }
    } on FirebaseAuthException catch (e) {
      log("/////error signing in: ${e.message}.");
    }
  }

  Future<void> initFcmToken() async {
    var userData = await FirebaseAuth.instance.signInAnonymously();

    final firebaseMessaging = FirebaseMessaging.instance;
    await firebaseMessaging.requestPermission();
    final fcmToken = await firebaseMessaging.getToken();
    debugPrint('/////token: $fcmToken');
    FirebaseFirestore.instance
        .collection('users')
        .doc(userData.user!.uid)
        .update({"fcm": fcmToken});
  }
}
