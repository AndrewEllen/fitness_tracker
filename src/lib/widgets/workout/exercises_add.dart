import 'package:fitness_tracker/constants.dart';
import 'package:fitness_tracker/providers/general/database_write.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/workout/user_exercises.dart';

class ExercisesAdd extends StatefulWidget {
  ExercisesAdd({Key? key}) : super(key: key);

  @override
  State<ExercisesAdd> createState() => _ExercisesAddState();
}

class _ExercisesAddState extends State<ExercisesAdd> {
  late TextEditingController exerciseController = TextEditingController();
  late TextEditingController categoryController = TextEditingController();
  late final exerciseKey = GlobalKey<FormState>();
  late final categoryKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return Container(
      width: _width,
      height: _height/14,
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
            decoration: BoxDecoration(
              color: appTertiaryColour,
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              border: Border.all(
                color: appQuarternaryColour,
              ),
            ),
            width: _width/3,
            height: _width/12,
            child: Center(
              child: Form(
                key: categoryKey,
                child: TextFormField(
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
            decoration: BoxDecoration(
              color: appTertiaryColour,
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              border: Border.all(
                color: appQuarternaryColour,
              ),
            ),
            width: _width/3,
            height: _width/12,
            child: Form(
              key: exerciseKey,
              child: TextFormField(
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
          Container(
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
                  FocusScope.of(context).requestFocus(new FocusNode());
                  context.read<UserExercisesList>().addExercise(
                    categoryController.text,
                    exerciseController.text,
                  );
                  UpdateUserDocumentExercises(context.read<UserExercisesList>().exerciseList);
                }
              },
            ),
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
