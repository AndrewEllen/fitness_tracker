import 'package:fitness_tracker/exports.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../models/exercise_model.dart';
import '../providers/user_exercises.dart';
import '../widgets/screen_width_container.dart';
import '../widgets/exercises_add.dart';
import '../widgets/exercises_edit.dart';

class ExercisesScreen extends StatefulWidget {
  ExercisesScreen({Key? key}) : super(key: key);

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  late List<Exercises> data;

  void initState() {
    data = context.read<UserExercisesList>().exerciseList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    context.watch<UserExercisesList>().exerciseList;

    double _height = MediaQuery.of(context).size.height/1.03;
    double _width = MediaQuery.of(context).size.width;
    double _margin = 15;
    double fontSize = 21;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appPrimaryColour,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: _height/1.118,
            maxWidth: _width,
          ),
          child: ScreenWidthContainer(
            minHeight: _height,
            maxHeight: _height,
            height: _height,
            margin: 0,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: EdgeInsets.only(top:_margin/4),
                      height: 24,
                      child: const Text(
                        "Exercises",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: (24),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 3, color: appPrimaryColour),
                      ),
                    ),
                    height: _height/1.18,
                    width: double.infinity,
                    margin: EdgeInsets.only(top:_margin/1.8),
                    child: Column(
                      children: [
                        ExercisesAdd(
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (BuildContext context, int index) {
                              context.watch<UserExercisesList>().exerciseList;
                              return ExercisesEdit(
                                key: UniqueKey(),
                                index: index,
                                category: data[index].exerciseCategory,
                                exerciseName: data[index].exerciseName,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

