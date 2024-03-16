import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final huddleProvider =
    ChangeNotifierProvider<HuddleState>((ref) => HuddleState(id: ''));

class HuddleState extends ChangeNotifier {
  String id = '';
  HuddleState({required this.id});

  void changeCurrentIndex(String newId) {
    id = newId;
    notifyListeners();
  }
}
