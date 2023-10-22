
class UserDataModel {
  Map<String, dynamic> toMap() {
    return {
      'height': height,
      'weight' : weight,
      'age': age,
      'activityLevel': activityLevel,
      'weightGoal': weightGoal,
      'biologicalSex': biologicalSex,
      'calories': calories,
    };
  }
  UserDataModel({
    required this.height,
    required this.weight,
    required this.age,
    required this.activityLevel,
    required this.weightGoal,
    required this.biologicalSex,
    required this.calories,
  });

  String height;
  String weight;
  String age;
  String activityLevel;
  String weightGoal;
  String biologicalSex;
  String calories;
}