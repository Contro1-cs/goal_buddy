import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final navBarProvider =
    ChangeNotifierProvider<NavBarState>((ref) => NavBarState(currentIndex: 0));

class NavBarState extends ChangeNotifier {
  int currentIndex = 0;
  NavBarState({required this.currentIndex});

  void changeCurrentIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }
}
