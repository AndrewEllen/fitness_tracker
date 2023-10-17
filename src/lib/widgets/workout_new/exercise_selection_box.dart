import 'package:fitness_tracker/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExerciseSelectionBox extends StatefulWidget {
  const ExerciseSelectionBox({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<ExerciseSelectionBox> createState() => _ExerciseSelectionBoxState();
}

class _ExerciseSelectionBoxState extends State<ExerciseSelectionBox> {

  bool _selected = false;

  void ChangeSelection(bool? value) {
    setState(() {
      _selected = value!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 40.h,
      color: appQuarternaryColour,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              widget.title,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          const Spacer(),
          Checkbox(
            checkColor: Colors.white,
            activeColor: appSecondaryColour,
            value: _selected,
            onChanged: (bool? value) => ChangeSelection(value),
          ),
        ],
      ),
    );
  }
}
