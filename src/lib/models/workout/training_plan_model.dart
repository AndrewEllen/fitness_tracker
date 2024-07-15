
import 'package:fitness_tracker/models/workout/training_plan_week_model.dart';

class TrainingPlan {

  Map<String, dynamic> toMap() {
    return {
      'trainingPlanName': trainingPlanName,
      'trainingPlanWeek': [
        for (TrainingPlanWeek week in trainingPlanWeeks) week.toMap()
      ],
      'trainingPlanID': trainingPlanID,
    };
  }
  TrainingPlan({
    required this.trainingPlanName,
    required this.trainingPlanWeeks,
    this.trainingPlanID,
  });

  String trainingPlanName;
  List<TrainingPlanWeek> trainingPlanWeeks;
  String? trainingPlanID;
}