import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userIdProvider =
    ChangeNotifierProvider<UserIdModel>((ref) => UserIdModel(userId: ''));

class UserIdModel extends ChangeNotifier {
  String userId = '';
  UserIdModel({required this.userId});

  void setUserId(String id) async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(id).get();
    if (userDoc.exists) {
      debugPrint('/////Existing user: $id');
    } else {
      FirebaseFirestore.instance.collection('users').doc(id).set(
        {
          "userId": id,
          "goals": [],
        },
      );
    }
    userId = id;
    notifyListeners();
  }
}
