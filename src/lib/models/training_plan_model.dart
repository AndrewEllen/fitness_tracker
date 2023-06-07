class TrainingPlan {
  Map<String, dynamic> toMap() {
    return {
      'trainingPlanID': trainingPlanID,
      'trainingPlanName': trainingPlanName,
      'routineIDs': routineIDs,
    };
  }
  TrainingPlan({
    required this.trainingPlanID,
    required this.routineIDs,
    required this.trainingPlanName,
  });

  String trainingPlanID;
  List<String> routineIDs;
  String trainingPlanName;
}