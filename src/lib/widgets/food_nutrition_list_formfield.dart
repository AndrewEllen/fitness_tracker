import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../providers/user_nutrition_data.dart';

class FoodNutritionListFormField extends StatefulWidget {
  FoodNutritionListFormField({Key? key, required this.controller,
    required this.formKey, required this.width,
    required this.formName, this.numbersOnly = true,
    this.servings = false,
    this.servingSize = false,
  }) : super(key: key);

  late TextEditingController controller;
  late GlobalKey<FormState> formKey;
  late double width;
  late String formName;
  late bool numbersOnly;
  late bool servings, servingSize;


  @override
  State<FoodNutritionListFormField> createState() => _FoodNutritionListFormFieldState();
}

class _FoodNutritionListFormFieldState extends State<FoodNutritionListFormField> {

  final textInputFormatter = <TextInputFormatter>[
    FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
  ];

  void SaveServings () {
    if (widget.servings) {
      context.read<UserNutritionData>().updateCurrentFoodItemServings(widget.controller.text);
    }
    if (widget.servingSize) {
      context.read<UserNutritionData>().updateCurrentFoodItemServingSize(widget.controller.text);
    }
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            "${widget.formName}:",
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        Form(
          key: widget.formKey,
          child: TextFormField(
            inputFormatters: widget.numbersOnly ? textInputFormatter : null,
            keyboardType: widget.numbersOnly ? TextInputType.number : TextInputType.text,
            controller: widget.controller,
            cursorColor: Colors.white,
            style: const TextStyle(
              color: Colors.white,
              fontSize: (20),
            ),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(bottom: (widget.width/12)/2.5, left: 5, right: 5,),
              hintText: '-',
              hintStyle: const TextStyle(
                color: Colors.white54,
                fontSize: (18),
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
            onFieldSubmitted: (value) {
              SaveServings();
            },
            onTapOutside: (value) {
              SaveServings();
            },
          ),
        ),
      ],
    );
  }
}
