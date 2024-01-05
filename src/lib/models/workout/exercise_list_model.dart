

class ExerciseListModel {

  Map<String, dynamic> toMap() {
    return {
      'exerciseName': exerciseName,
      'exerciseDate': exerciseDate,
    };
  }

  ExerciseListModel({
    required this.exerciseName,
    required this.exerciseDate,
  });

  String exerciseName;
  String exerciseDate;
}