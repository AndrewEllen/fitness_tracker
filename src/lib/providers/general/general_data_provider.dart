
import 'package:flutter/material.dart';

import 'database_write.dart';

class GeneralDataProvider with ChangeNotifier {

  late Map<String, dynamic> _dailyStreak = {
    "lastDate": DateTime.now(),
    "dailyStreak": 0,
  };

  dynamic get dailyStreak => _dailyStreak;

  void setDailyStreak(Map<String, dynamic> newStreak) {

    print(newStreak);

    _dailyStreak = newStreak;

    SaveDailyStreak(_dailyStreak);

    notifyListeners();

  }

  void updateDailyStreak(Map<String, dynamic> newStreak) {

    _dailyStreak = {
      "lastDate": DateTime.now(),
      "dailyStreak": newStreak["dailyStreak"]+1,
    };

    print(_dailyStreak);
    SaveDailyStreak(_dailyStreak);

    notifyListeners();

  }

}