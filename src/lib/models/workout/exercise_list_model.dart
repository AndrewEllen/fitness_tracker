

class ExerciseListModel {

  Map<String, dynamic> toMap() {
    return {
      'exerciseName': exerciseName,
      'exerciseDate': exerciseDate,
      'category': category,
      'exerciseTrackingType': exerciseTrackingType,
    };
  }

  //Tracking type
  // 0 = reps+weight
  // 1 = reps
  // 2 = time+distance
  // 3 = time
  ExerciseListModel({
    required this.exerciseName,
    required this.exerciseDate,
    this.category,
    this.exerciseTrackingType = 0,
  });

  String exerciseName;
  String exerciseDate;
  String? category;
  int? exerciseTrackingType;
}