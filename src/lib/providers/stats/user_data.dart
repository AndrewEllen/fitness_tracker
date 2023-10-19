import 'package:flutter/cupertino.dart';
import '../../models/stats/user_data_model.dart';
import '../general/database_write.dart';

class UserData with ChangeNotifier {

  late UserDataModel _userData = UserDataModel(
      height: '',
      weight: '',
      age: '',
      activityLevel: '0',
      weightGoal: '0',
      biologicalSex: '0',
      calories: ''

  );

  UserDataModel get userData => _userData;


  void setUserBioData(UserDataModel newUserData) {
    _userData = newUserData;

  }

  void updateUserBioData(UserDataModel newUserData) {
    _userData = newUserData;

    writeUserBiometric(_userData);

    notifyListeners();
  }

  void updateUserBioHeight(String newData) {
    _userData.height = newData;

    writeUserBiometric(_userData);

    notifyListeners();
  }
  void updateUserBioWeight(String newData) {
    _userData.weight = newData;

    writeUserBiometric(_userData);

    notifyListeners();
  }
  void updateUserBioAge(String newData) {
    _userData.age = newData;

    writeUserBiometric(_userData);

    notifyListeners();
  }
  void updateUserActivityLevel(String newData) {
    _userData.activityLevel = newData;

    writeUserBiometric(_userData);

    notifyListeners();
  }
  void updateUserWeightGoal(String newData) {
    _userData.weightGoal = newData;

    writeUserBiometric(_userData);

    notifyListeners();
  }
  void updateUserBiologicalSex(String newData) {
    _userData.biologicalSex = newData;

    writeUserBiometric(_userData);

    notifyListeners();
  }
  void updateUserCalories(String newData) {
    _userData.calories = newData;

    writeUserBiometric(_userData);

    notifyListeners();
  }

}