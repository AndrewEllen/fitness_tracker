import 'package:fitness_tracker/models/workout/routines_model.dart';
import 'package:fitness_tracker/models/workout/training_plan_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../general/database_get.dart';


class TrainingPlanProvider with ChangeNotifier {
  late List<TrainingPlan> _trainingPlans = [];
  late List<WorkoutRoutine> _newTrainingPlanList = [];
  late List<String> _newTrainingPlanListIDs = [];
  late TrainingPlan _currentlySelectedPlan = TrainingPlan(trainingPlanID: "null", routineIDs: [], trainingPlanName: "");
  late String _currentlySelectedPlanID;
  late int _currentlySelectedPlanIndex = -1;

  List<WorkoutRoutine> get newTrainingPlanList => _newTrainingPlanList;
  List<String> get newTrainingPlanListIDs => _newTrainingPlanListIDs;
  List<TrainingPlan> get trainingPlans => _trainingPlans;
  TrainingPlan get currentlySelectedPlan => _currentlySelectedPlan;
  String get currentlySelectedPlanID => _currentlySelectedPlanID;
  int get currentlySelectedPlanIndex => _currentlySelectedPlanIndex;

  void selectTrainingPlan(String trainingPlanID) {
    int index = _trainingPlans.indexWhere((element) =>
    element.trainingPlanID == trainingPlanID,
    );
    _currentlySelectedPlan = _trainingPlans[index];
    _currentlySelectedPlanID = trainingPlanID;
    _currentlySelectedPlanIndex = index;
    notifyListeners();
  }

  void setTrainingPlanInititial(List<TrainingPlan> newTrainingPlans) {
    _trainingPlans = newTrainingPlans;
  }

  void updateTrainingPlan(TrainingPlan newTrainingPlan, int index) {
    _trainingPlans[index] = newTrainingPlan;
    notifyListeners();
  }

  void addNewTrainingPlan(TrainingPlan newTrainingPlan) {
    _trainingPlans.add(newTrainingPlan);
    notifyListeners();
  }

  void editExistingTrainingPlan(TrainingPlan newTrainingPlan, String trainingPlanID) {
    for (int i = 0; i < _trainingPlans.length; i++) {
      if (_trainingPlans[i].trainingPlanID == trainingPlanID) {
        _trainingPlans[i] = newTrainingPlan;
        if (i == _currentlySelectedPlanIndex) {
          _currentlySelectedPlan = newTrainingPlan;
        }
        break;
      }
    }
    notifyListeners();
  }

  void updateNewTrainingPlan(List<WorkoutRoutine> newPlanList) {
    newPlanList.forEach((item) => _newTrainingPlanListIDs.add(item.routineID));
    _newTrainingPlanList = newPlanList;
    notifyListeners();
  }
}