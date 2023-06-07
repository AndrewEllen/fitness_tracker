import 'package:fitness_tracker/models/routines_model.dart';
import 'package:fitness_tracker/providers/exercise_list_data.dart';
import 'package:fitness_tracker/providers/user_routines_data.dart';
import 'package:fitness_tracker/widgets/exercise_display_box.dart';
import 'package:fitness_tracker/widgets/screen_width_container.dart';
import 'package:flutter/material.dart';
import 'package:fitness_tracker/constants.dart';
import 'package:provider/provider.dart';

class ShowRoutinesScreen extends StatefulWidget {
  const ShowRoutinesScreen({Key? key,
    required this.returnScreen,
    required this.routine,
  }) : super(key: key);
  final Widget returnScreen;
  final WorkoutRoutine routine;

  @override
  _ShowRoutinesScreenState createState() => _ShowRoutinesScreenState();
}

class _ShowRoutinesScreenState extends State<ShowRoutinesScreen> {
  bool _displayDropDown = false;


  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    double _margin = 15;
    double _bigContainerMin = 450;
    double _smallContainerMin = 95;
    return Scaffold(
      backgroundColor: appPrimaryColour,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
        child: ListView(
          children: [
            ScreenWidthContainer(
              minHeight: _smallContainerMin * 0.5,
              maxHeight: _smallContainerMin * 0.7,
              height: _smallContainerMin * 0.5,
              margin: _margin / 4,
              child: Container(
                margin: const EdgeInsets.all(5),
                child: Center(
                  child: Text(
                      widget.routine.routineName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                      )
                  ),
                ),
              ),
            ),
            ScreenWidthContainer(
              minHeight: _bigContainerMin * 0.96,
              maxHeight: _bigContainerMin * 1.5,
              height: (_height / 100) * 78,
              margin: _margin / 2,
              child: (widget.routine.exercises.isEmpty)
                  ? const Center(
                child: Text(
                  "Exercise List Empty",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                  ),
                ),
              ) : ListView.builder(
                  itemCount: widget.routine.exercises.length,
                  itemBuilder: (BuildContext context, int index) {
                    _displayDropDown = false;
                    return ExerciseDisplayBox(
                      title: widget.routine.exercises[index],
                      subtitle: "Tap to Log Workout",
                      icon: Icons.keyboard_arrow_right,
                      onTap: () {},
                      onTapIcon: () {},
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
