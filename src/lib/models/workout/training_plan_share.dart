
import 'package:fitness_tracker/models/workout/training_plan_week_share_model.dart';

class TrainingPlanShare {

  Map<String, dynamic> toMap() {
    return {
      'trainingPlanName': trainingPlanName,
      'trainingPlanID': trainingPlanID,
      'trainingPlanWeek': [
        for (TrainingPlanWeekShare week in trainingPlanWeeks) week.toMap()
      ],
    };
  }
  TrainingPlanShare({
    required this.trainingPlanName,
    required this.trainingPlanWeeks,
    required this.trainingPlanID,
  });

  String trainingPlanName;
  List<TrainingPlanWeekShare> trainingPlanWeeks;
  String trainingPlanID;
}