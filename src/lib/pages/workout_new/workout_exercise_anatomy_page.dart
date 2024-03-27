import 'package:fitness_tracker/models/workout/exercise_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/workout_new/anatomy_diagram.dart';


class AnatomyDiagramPage extends StatelessWidget {
  AnatomyDiagramPage({Key? key, required this.exerciseModel}) : super(key: key);
  ExerciseModel exerciseModel;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0,-120.h),
      child: AnatomyDiagram(
        exerciseModel: exerciseModel,
      ),
    );
  }
}
