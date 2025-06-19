import 'package:flutter/material.dart';

class BottomNavigationProvider extends ChangeNotifier{
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setIndexNav(int index){
    _currentIndex = index;
    notifyListeners();
  }
}