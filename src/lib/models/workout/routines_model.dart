class WorkoutRoutine {
  Map<String, dynamic> toMap() {
    return {
      'routineID': routineID,
      'routineName': routineName,
      'exercises': exercises,
    };
  }
  WorkoutRoutine({
    required this.routineID,
    required this.routineName,
    required this.exercises,
  });

  String routineID;
  String routineName;
  List<String> exercises;
}