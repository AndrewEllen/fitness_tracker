import 'package:fitness_tracker/models/workout/routines_model.dart';
import 'package:fitness_tracker/models/workout/training_plan_model.dart';

findRoutines(List<WorkoutRoutine> routines, TrainingPlan trainingPlan) {
  return List<WorkoutRoutine>.generate(trainingPlan.routineIDs.length, (int index) {
    return routines[
    routines.indexWhere((element) =>
    element.routineID == trainingPlan
        .routineIDs[index],
    )
    ];
  });
}
