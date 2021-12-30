import 'package:flutter/material.dart';

class NavButtonProvider extends ChangeNotifier {
  int index = 0;

  void changeIndex(int _index) {
    index = _index;
    notifyListeners();
  }
}
