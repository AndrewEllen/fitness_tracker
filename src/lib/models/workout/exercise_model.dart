class Exercises {
  Map<String, dynamic> toMap() {
    return {
      'exerciseName': exerciseName,
      'exerciseCategory': exerciseCategory,
      'uniqueID': uniqueID,
    };
  }
  Exercises({
    required this.exerciseName,
    required this.exerciseCategory,
    required this.uniqueID,
  });

  String exerciseName;
  String exerciseCategory;
  String uniqueID;
}
