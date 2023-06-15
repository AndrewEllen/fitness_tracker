import 'package:fitness_tracker/models/workout/routines_model.dart';
import 'package:fitness_tracker/models/workout/training_plan_model.dart';

findRoutineID(List<WorkoutRoutine> routines, TrainingPlan trainingPlan, int index) {
  return routines.indexWhere((element) =>
    element.routineID == trainingPlan
        .routineIDs[index],
    );
}
