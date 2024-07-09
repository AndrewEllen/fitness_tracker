
import 'package:fitness_tracker/models/workout/training_plan_week_model.dart';

class TrainingPlan {

  Map<String, dynamic> toMap() {
    return {
      'trainingPlanName': trainingPlanName,
      'trainingPlanWeek': trainingPlanWeeks,
    };
  }
  TrainingPlan({
    required this.trainingPlanName,
    required this.trainingPlanWeeks,
  });

  String trainingPlanName;
  List<TrainingPlanWeek> trainingPlanWeeks;
}