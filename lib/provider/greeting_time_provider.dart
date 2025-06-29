import 'dart:async';

import 'package:flutter/material.dart';

class GreetingTimeProvider extends ChangeNotifier {
  String _greeting = '';
  Timer? _timer;

  GreetingTimeProvider(){
    _updateGreeting();
    _timer = Timer.periodic(Duration(minutes: 1), (timer){
      _updateGreeting();
    });
  }

  String get greeting => _greeting;

  void _updateGreeting() {
    final hour = DateTime.now().hour;
    String newGreeting;

    if (hour < 12) {
      newGreeting = 'Good Morning 👋';
    } else if (hour >= 12 && hour < 17) {
      newGreeting = 'Good Afternoon 👋';
    } else if (hour >= 17 && hour < 23) {
      newGreeting = 'Good Evening 👋';
    } else {
      newGreeting = 'Good Night 👋';
    }

    if (_greeting != newGreeting) {
      _greeting = newGreeting;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}