import 'package:fitness_tracker/models/routines_model.dart';
import 'package:fitness_tracker/models/training_plan_model.dart';

findRoutineID(List<WorkoutRoutine> routines, TrainingPlan trainingPlan, int index) {
  return routines.indexWhere((element) =>
    element.routineID == trainingPlan
        .routineIDs[index],
    );
}
