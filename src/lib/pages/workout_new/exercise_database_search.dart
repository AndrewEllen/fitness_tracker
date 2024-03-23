import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_tracker/widgets/general/app_default_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants.dart';
import '../../widgets/general/app_dropdown_form.dart';

class ExerciseDatabaseSearch extends StatefulWidget {
  ExerciseDatabaseSearch({Key? key}) : super(key: key);

  @override
  State<ExerciseDatabaseSearch> createState() => _ExerciseDatabaseSearchState();
}

class _ExerciseDatabaseSearchState extends State<ExerciseDatabaseSearch> {


  void searchExercises() async {
    dynamic snapshot;

    if (classificationDropDownMenuValue == 0) {
      snapshot = await FirebaseFirestore.instance
          .collection('exercise-database')
          .where("target-muscle", isEqualTo: targetMuscleList[targetMuscleDropDownMenuValue])
          .where("difficulty", whereIn: difficultyList.sublist(0, difficultyDropDownMenuValue+1))
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

    for (DocumentSnapshot doc in snapshot) {
     print(doc.data());
    }

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
    "Olympic Weightlifting",
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
    return Column(

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
                  classificationDropDownMenuValue = value;
                });
              }
            },
          ),
        ),


        AppButton(onTap: () => searchExercises(), buttonText: "Search"),


      ],

    );
  }
}
