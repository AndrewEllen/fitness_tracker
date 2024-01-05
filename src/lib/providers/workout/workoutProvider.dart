import 'package:fitness_tracker/models/stats/stats_model.dart';
import 'package:fitness_tracker/models/workout/exercise_list_model.dart';
import 'package:flutter/cupertino.dart';
import '../../models/workout/exercise_model.dart';
import '../../models/workout/reps_weight_stats_model.dart';
import '../../models/workout/routines_model.dart';

class WorkoutProvider with ChangeNotifier {

  late List<RoutinesModel> _routinesList = [
    RoutinesModel(
      routineID: "1",
      routineName: "Test Routine 1",
      routineDate: "05/01/2024",
      exercises: [
        ExerciseListModel(
          exerciseName: "Test Exercise 1",
          exerciseDate: "05/01/2024"
        ),
        ExerciseListModel(
          exerciseName: "Test Exercise 2",
            exerciseDate: "01/11/2023"
        ),
        ExerciseListModel(
          exerciseName: "Test Exercise 3",
            exerciseDate: "05/12/2023"
        ),
        ExerciseListModel(
          exerciseName: "Test Exercise 4",
            exerciseDate: "02/01/2024"
        ),
        ExerciseListModel(
          exerciseName: "Test Exercise 5",
            exerciseDate: "05/01/2024"
        ),
      ],
    ),

    RoutinesModel(
      routineID: "2",
      routineName: "Test Routine 2",
      routineDate: "05/01/2024",
      exercises: [
        ExerciseListModel(
            exerciseName: "Test Exercise 5",
            exerciseDate: "05/01/2024"
        ),
        ExerciseListModel(
            exerciseName: "Test Exercise 6",
            exerciseDate: "01/01/2024"
        ),
        ExerciseListModel(
            exerciseName: "Test Exercise 7",
            exerciseDate: "02/01/2024"
        ),
        ExerciseListModel(
            exerciseName: "Test Exercise 8",
            exerciseDate: "03/01/2024"
        ),
        ExerciseListModel(
            exerciseName: "Test Exercise 9",
            exerciseDate: "04/01/2024"
        ),
      ],
    )

  ];

  List<RoutinesModel> get routinesList => _routinesList;



  late final List<ExerciseModel> _exerciseList = [

    ExerciseModel(
        exerciseName: "Test Exercise 5",
        exerciseTrackingData: RepsWeightStatsMeasurement(
              measurementName: "Test Exercise 5",
              weightValues: [
                16,
                14,
                14,
                12,
                12,
              ],
              repValues: [
                8,
                10,
                10,
                12,
                12,
              ],
              measurementDates: [
                "05/01/2024",
                "04/01/2024",
                "03/01/2024",
                "02/01/2024",
                "01/01/2024",
              ],
          )
    ),

    ExerciseModel(
        exerciseName: "Test Exercise 6",
        exerciseTrackingData: RepsWeightStatsMeasurement(
          measurementName: "Test Exercise 6",
          weightValues: [
            160,
            140,
            140,
            120,
            120,
          ],
          repValues: [
            3,
            5,
            5,
            7,
            8,
          ],
          measurementDates: [
            "15/11/2023",
            "14/11/2023",
            "13/11/2023",
            "12/11/2023",
            "11/11/2023",
          ],
        )
    ),

  ];

  List<ExerciseModel> get exerciseList => _exerciseList;


  bool checkForExerciseData(String exerciseNameToCheck) {

    if (_exerciseList.any((value) => value.exerciseName == exerciseNameToCheck)) {
      return true;
    } else {
      return false;
    }

  }



}