import 'package:fitness_tracker/constants.dart';
import 'package:fitness_tracker/models/stats_model.dart';
import 'package:fitness_tracker/providers/user_exercises.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/database_write.dart';
import '../providers/page_change_provider.dart';
import '../providers/user_measurements.dart';
import 'app_default_button.dart';

class ExercisesEdit extends StatefulWidget {
  ExercisesEdit({Key? key, required this.index, required this.category, required this.exerciseName}) : super(key: key);
  late int index;
  late String category, exerciseName;

  @override
  State<ExercisesEdit> createState() => _ExercisesEditState();
}

class _ExercisesEditState extends State<ExercisesEdit> {
  late TextEditingController exerciseController = TextEditingController();
  late TextEditingController categoryController = TextEditingController();
  late final exerciseKey = GlobalKey<FormState>();
  late final categoryKey = GlobalKey<FormState>();

  bool _editData = false;

  @override
  void initState() {
    exerciseController.text = widget.exerciseName;
    categoryController.text = widget.category;
    super.initState();
  }

  deleteStat(BuildContext context, int index, String value, double width) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: appTertiaryColour,
          title: const Text(
            "Deletion Confirmation",
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          content: RichText(
            text: TextSpan(text: 'Are you sure you would like to delete the exercise: ',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
              children: <TextSpan>[
                TextSpan(text: '$value',
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Container(
                height: 30,
                child: AppButton(
                  buttonText: "Cancel",
                  onTap: () {
                    Navigator.pop(context);
                  },
                )
            ),
            Container(
                height: 30,
                child: AppButton(
                  primaryColor: Colors.red,
                  buttonText: "Delete",
                  onTap: () {
                    context.read<UserExercisesList>().deleteExercise(
                      widget.index,
                    );
                    UpdateUserDocumentExercises(context.read<UserExercisesList>().exerciseList);
                    Navigator.pop(context);
                  },
                )
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return Container(
      width: _width,
      height: _editData ? _height/14 : _height/20,
      margin: const EdgeInsets.only(
        left: 8,
        right: 8,
        top: 8,
      ),
      decoration: const BoxDecoration(
        color: appQuinaryColour,
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Row(
        children: [
          const Spacer(flex: 1),
          Container(
            decoration: _editData ? BoxDecoration(
              color: appTertiaryColour,
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              border: Border.all(
                color: appQuarternaryColour,
              ),
            ) : null,
            width: _width/3,
            height: _width/12,
            child: Center(
              child: Form(
                key: categoryKey,
                child: TextFormField(
                  enabled: _editData,
                  controller: categoryController,
                  cursorColor: Colors.white,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: (17),
                  ),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: (_width/12)/2.5, left: 5, right: 5,),
                    hintText: 'Enter Category...',
                    hintStyle: const TextStyle(
                      color: Colors.white54,
                      fontSize: (17),
                    ),
                    errorStyle: const TextStyle(
                      height: 0,
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: appSecondaryColour,
                      ),
                    ),
                  ),
                  validator: (String? value) {
                    if (value!.isNotEmpty) {
                      return null;
                    }
                    return "";
                  },
                ),
              ),
            ),
          ),
          const Spacer(flex: 1),
          Container(
            decoration: _editData ? BoxDecoration(
              color: appTertiaryColour,
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              border: Border.all(
                color: appQuarternaryColour,
              ),
            ) : null,
            width: _width/3,
            height: _width/12,
            child: Form(
              key: exerciseKey,
              child: TextFormField(
                enabled: _editData,
                controller: exerciseController,
                cursorColor: Colors.white,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: (17),
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: (_width/12)/2.5, left: 5, right: 5,),
                  hintText: 'Enter Exercise...',
                  hintStyle: const TextStyle(
                    color: Colors.white54,
                    fontSize: (17),
                  ),
                  errorStyle: const TextStyle(
                    height: 0,
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: appSecondaryColour,
                    ),
                  ),
                ),
                validator: (String? value) {
                  if (value!.isNotEmpty) {
                    return null;
                  }
                  return "";
                },
              ),
            ),
          ),
          const Spacer(flex: 1),
          _editData ? Container(
            decoration: BoxDecoration(
              color: appSecondaryColour,
              borderRadius: const BorderRadius.all(Radius.circular(45)),
              border: Border.all(
                color: appQuarternaryColour,
              ),
            ),
            width: _width/10,
            height: _width/10,
            child: IconButton(
              icon: const Icon(
                Icons.save,
                color: Colors.white,
              ),
              onPressed: () {
                if (exerciseKey.currentState!.validate() && categoryKey.currentState!.validate()) {
                  setState(() {
                    context.read<UserExercisesList>().updateExercise(
                      categoryController.text,
                      exerciseController.text,
                      widget.index,
                    );
                    UpdateUserDocumentExercises(context.read<UserExercisesList>().exerciseList);
                    _editData = false;
                  });
                }
              },
            ),
          ) : Row(
            children: [
              SizedBox(
                width: _width/10,
                height: _width/10,
                child: IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    deleteStat(
                      this.context,
                      widget.index,
                      widget.exerciseName,
                      _width,
                    );
                  },
                ),
              ),
              SizedBox(
                width: _width/10,
                height: _width/10,
                child: IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _editData = true;
                    });
                  },
                ),
              ),
            ],
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
