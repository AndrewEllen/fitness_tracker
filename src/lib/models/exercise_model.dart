class Exercises {
  Map<String, dynamic> toMap() {
    return {
      'exerciseName': exerciseName,
      'exerciseCategory': exerciseCategory,
    };
  }
  Exercises({
    required this.exerciseName,
    required this.exerciseCategory,
  });

  String exerciseName;
  String exerciseCategory;
}
