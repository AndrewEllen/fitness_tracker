
class TrainingPlanWeek {

  Map<String, dynamic> toMap() {
    return {
      'weekNumber': weekNumber,
      'monday': mondayRoutineID,
      'tuesday': tuesdayRoutineID,
      'wednesday': wednesdayRoutineID,
      'thursday': thursdayRoutineID,
      'friday': fridayRoutineID,
      'saturday': saturdayRoutineID,
      'sunday': sundayRoutineID,
    };
  }
  TrainingPlanWeek({
    required this.weekNumber,
    required this.mondayRoutineID,
    required this.tuesdayRoutineID,
    required this.wednesdayRoutineID,
    required this.thursdayRoutineID,
    required this.fridayRoutineID,
    required this.saturdayRoutineID,
    required this.sundayRoutineID,
  });

  int weekNumber;
  String mondayRoutineID;
  String tuesdayRoutineID;
  String wednesdayRoutineID;
  String thursdayRoutineID;
  String fridayRoutineID;
  String saturdayRoutineID;
  String sundayRoutineID;
}