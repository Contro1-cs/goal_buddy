import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseInit {
  init() async {
    try {
      var userData = await FirebaseAuth.instance.signInAnonymously();
      print("Signed in with temporary account.");
      DocumentSnapshot huddleRef = await FirebaseFirestore.instance
          .collection('huddles')
          .doc(userData.user!.uid)
          .get();
      if (huddleRef.exists) {
        print("/////User already has huddle");
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
          "participants": [],
        });
        print("/////New huddle created");
      }
    } on FirebaseAuthException catch (e) {
      log("/////error signing in: ${e.message}.");
    }
  }
}
