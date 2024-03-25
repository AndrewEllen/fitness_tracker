import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_tracker/widgets/general/app_default_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants.dart';
import '../../models/workout/exercise_database_model.dart';
import '../../widgets/general/app_dropdown_form.dart';
import '../../widgets/workout_new/database_search_box.dart';

class ExerciseDatabaseSearch extends StatefulWidget {
  ExerciseDatabaseSearch({Key? key}) : super(key: key);

  @override
  State<ExerciseDatabaseSearch> createState() => _ExerciseDatabaseSearchState();
}

class _ExerciseDatabaseSearchState extends State<ExerciseDatabaseSearch> {

  List exerciseDatabaseSearchList = [];
  late DocumentSnapshot lastDoc;
  bool _searchChanged = false;

  void searchExercises() async {

    if (_searchChanged) {
      exerciseDatabaseSearchList = [];
      _searchChanged = false;
    }

    dynamic snapshot;

    if (classificationDropDownMenuValue == 0) {
      if (exerciseDatabaseSearchList.isNotEmpty) {
        snapshot = await FirebaseFirestore.instance
            .collection('exercise-database')
            .startAfterDocument(lastDoc)
            .where("target-muscle", isEqualTo: targetMuscleList[targetMuscleDropDownMenuValue])
            .where("difficulty", whereIn: difficultyList.sublist(0, difficultyDropDownMenuValue+1))
            .limit(15)
            .get();
      } else {
        snapshot = await FirebaseFirestore.instance
            .collection('exercise-database')
            .where("target-muscle", isEqualTo: targetMuscleList[targetMuscleDropDownMenuValue])
            .where("difficulty", whereIn: difficultyList.sublist(0, difficultyDropDownMenuValue+1))
            .limit(15)
            .get();
      }
    } else {
      if (exerciseDatabaseSearchList.isNotEmpty) {
        snapshot = await FirebaseFirestore.instance
            .collection('exercise-database')
            .startAfterDocument(lastDoc)
            .where("target-muscle", isEqualTo: targetMuscleList[targetMuscleDropDownMenuValue])
            .where("difficulty", whereIn: difficultyList.sublist(0, difficultyDropDownMenuValue+1))
            .where("exercise-classification", isEqualTo: classificationList[classificationDropDownMenuValue])
            .limit(15)
            .get();
      } else {
        snapshot = await FirebaseFirestore.instance
            .collection('exercise-database')
            .where("target-muscle", isEqualTo: targetMuscleList[targetMuscleDropDownMenuValue])
            .where("difficulty", whereIn: difficultyList.sublist(0, difficultyDropDownMenuValue+1))
            .where("exercise-classification", isEqualTo: classificationList[classificationDropDownMenuValue])
            .limit(15)
            .get();
      }
    }

    lastDoc = snapshot.docs.last;
    for (DocumentSnapshot doc in snapshot.docs) {

      exerciseDatabaseSearchList.add(
          ExerciseDatabaseModel(
            alternatingArms: doc["alternating-arms"],
            bodyRegion: doc["body-region"],
            combinationExercises: doc["combination-exercises"],
            difficulty: doc["difficulty"],
            exercise: doc["exercise"],
            exerciseClassification: doc["exercise-classification"],
            grip: doc["grip"],
            laterality: doc["laterality"],
            loadPosition: doc["load-position"],
            longVideo: doc["long-video"],
            mechanics: doc["mechanics"],
            movementPatternOne: doc["movement-pattern-one"],
            movementPatternTwo: doc["movement-pattern-two"],
            movementPatternThree: doc["movement-pattern-three"],
            numPrimaryItems: doc["num-primary-items"],
            numSecondaryItems: doc["num-secondary-items"],
            numberOfArms: doc["number-of-arms"],
            planeOfMotionOne: doc["plane-of-motion-one"],
            planeOfMotionTwo: doc["plane-of-motion-two"],
            planeOfMotionThree: doc["plane-of-motion-three"],
            posture: doc["posture"],
            primaryEquipment: doc["primary-equipment"],
            secondaryEquipment: doc["secondary-equipment"],
            primaryMuscle: doc["primary-muscle"],
            secondaryMuscle: doc["secondary-muscle"],
            tertiaryMuscle: doc["tertiary-muscle"],
            shortVideo: doc["short-video"],
            targetMuscle: doc["target-muscle"],
          )
      );

    }
    debugPrint(snapshot.docs.length.toString());

    setState(() {});

  }







  int targetMuscleDropDownMenuValue = 0;
  List<String> targetMuscleList = <String>[
    "Biceps",
    "Triceps",
    "Forearms",
    "Shoulders",
    "Chest",
    "Back",
    "Trapezius",
    "Abdominals",
    "Glutes",
    "Quadriceps",
    "Hamstrings",
    "Abductors",
    "Adductors",
    "Calves"
  ];


  int difficultyDropDownMenuValue = 0;
  List<String> difficultyList = <String>[
    "Beginner",
    "Novice",
    "Intermediate",
    "Advanced",
    "Expert",
    "Master",
  ];

  int classificationDropDownMenuValue = 0;
  List<String> classificationList = <String>[
    "Any",
    "Bodybuilding",
    "Powerlifting",
    "Olympic Weightlifting ",
    "Calisthenics",
    "Yoga", ///Postural in the database
    "Balance",
    "Mobility",
    "Plyometric",
    "Animal Flow",
    "Grinds", ///These two sometimes have a hybrid field "Hybrid - Ballistics & Grinds"
    "Ballistics",
  ];


  @override
  Widget build(BuildContext context) {
    targetMuscleList.sort();
    return SingleChildScrollView(
      child: Column(
      
        children: [
      
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 50.0, right: 50.0),
            child: DropdownMenu(
              initialSelection: 0,
              enableSearch: false,
              requestFocusOnTap: false,
              width: 294.w,
              hintText: "Select Exercise Type *",
              textStyle: boldTextStyle,
              menuStyle: MenuStyle(
                backgroundColor: MaterialStateProperty.all<Color>(appQuinaryColour),
              ),
              trailingIcon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
              ),
              selectedTrailingIcon: const Icon(
                Icons.arrow_drop_up,
                color: Colors.white,
              ),
              inputDecorationTheme: const InputDecorationTheme(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: appQuarternaryColour,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: appSecondaryColour,
                    )
                ),
              ),
              dropdownMenuEntries:
      
                  List.generate(targetMuscleList.length, (int index) => DropdownMenuEntry(
                    value: index,
                    label: targetMuscleList[index],
                    style: ButtonStyle(
                      textStyle: MaterialStateProperty.all<TextStyle>(boldTextStyle),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    ),
                  )),
      
              onSelected: (value) {
                if (value != null) {
                  setState(() {
                    _searchChanged = true;
                    targetMuscleDropDownMenuValue = value;
                  });
                }
              },
            ),
          ),
      
      
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 50.0, right: 50.0),
            child: DropdownMenu(
              initialSelection: 0,
              enableSearch: false,
              requestFocusOnTap: false,
              width: 294.w,
              hintText: "Select Exercise Type *",
              textStyle: boldTextStyle,
              menuStyle: MenuStyle(
                backgroundColor: MaterialStateProperty.all<Color>(appQuinaryColour),
              ),
              trailingIcon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
              ),
              selectedTrailingIcon: const Icon(
                Icons.arrow_drop_up,
                color: Colors.white,
              ),
              inputDecorationTheme: const InputDecorationTheme(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: appQuarternaryColour,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: appSecondaryColour,
                    )
                ),
              ),
              dropdownMenuEntries:
      
              List.generate(difficultyList.length, (int index) => DropdownMenuEntry(
                value: index,
                label: difficultyList[index],
                style: ButtonStyle(
                  textStyle: MaterialStateProperty.all<TextStyle>(boldTextStyle),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                ),
              )),
      
              onSelected: (value) {
                if (value != null) {
                  setState(() {
                    _searchChanged = true;
                    difficultyDropDownMenuValue = value;
                  });
                }
              },
            ),
          ),
      
      
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 50.0, right: 50.0),
            child: DropdownMenu(
              initialSelection: 0,
              enableSearch: false,
              requestFocusOnTap: false,
              width: 294.w,
              hintText: "Select Exercise Type *",
              textStyle: boldTextStyle,
              menuStyle: MenuStyle(
                backgroundColor: MaterialStateProperty.all<Color>(appQuinaryColour),
              ),
              trailingIcon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
              ),
              selectedTrailingIcon: const Icon(
                Icons.arrow_drop_up,
                color: Colors.white,
              ),
              inputDecorationTheme: const InputDecorationTheme(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: appQuarternaryColour,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: appSecondaryColour,
                    )
                ),
              ),
              dropdownMenuEntries:
      
              List.generate(classificationList.length, (int index) => DropdownMenuEntry(
                value: index,
                label: classificationList[index],
                style: ButtonStyle(
                  textStyle: MaterialStateProperty.all<TextStyle>(boldTextStyle),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                ),
              )),
      
              onSelected: (value) {
                if (value != null) {
                  setState(() {
                    _searchChanged = true;
                    classificationDropDownMenuValue = value;
                  });
                }
              },
            ),
          ),
      
      
          AppButton(onTap: () => searchExercises(), buttonText: "Search"),
      
      
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: exerciseDatabaseSearchList.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                key: UniqueKey(),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DatabaseSearchBox(
                    exerciseModel: exerciseDatabaseSearchList[index],
                  ),
                ],
              );
      
            },
          ),
      
        ],
      
      ),
    );
  }
}
