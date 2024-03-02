import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routine_app/main.dart';

final userIdProvider =
    ChangeNotifierProvider<UserIdModel>((ref) => UserIdModel(userId: ''));

class UserIdModel extends ChangeNotifier {
  String userId;
  UserIdModel({required this.userId});

  void checkUserId(String id) async {
    debugPrint('////checking id: $id');
    try {
      var data =
          await supabase.from('users').select('id').eq('token', id).single();
      debugPrint('////Existing user found');
      debugPrint('////User id: ${data['id']}');
      userId = data['id'];
    } catch (e) {
      var data = await supabase
          .from('users')
          .insert({'token': id})
          .select('id')
          .single();
      debugPrint('////Creating new user');
      debugPrint('////new user id: ${data['id']}');
      userId = data['id'];
    }
  }

  void setUserId(String id) {
    userId = id;
    debugPrint('////Updating id: $id');
    notifyListeners();
  }
}
