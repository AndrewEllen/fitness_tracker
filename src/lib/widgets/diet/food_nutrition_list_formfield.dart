import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/diet/user_nutrition_data.dart';

class FoodNutritionListFormField extends StatefulWidget {
  const FoodNutritionListFormField({Key? key, required this.controller,
    required this.formKey, required this.width,
    required this.formName, this.numbersOnly = true,
    this.secondaryController = false,
    this.recipe = false,
    this.name = false,
    this.servings = false,
    this.servingSize = false,
    this.centerForm = false,
  }) : super(key: key);

  final  TextEditingController controller;
  final  dynamic secondaryController;
  final  GlobalKey<FormState> formKey;
  final  double width;
  final  String formName;
  final  bool numbersOnly, centerForm;
  final  bool servings, servingSize, recipe, name;


  @override
  State<FoodNutritionListFormField> createState() => _FoodNutritionListFormFieldState();
}

class _FoodNutritionListFormFieldState extends State<FoodNutritionListFormField> {

  final textInputFormatter = <TextInputFormatter>[
    FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
  ];

  void SaveName () {

    if (focusNode.hasPrimaryFocus) {
      context.read<UserNutritionData>().updateRecipename(widget.controller.text);
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  void SaveServings () {

    if (focusNode.hasPrimaryFocus) {
      if (widget.servings & widget.recipe) {
        context.read<UserNutritionData>().updateRecipeServings(widget.controller.text);
      } else if (widget.servings) {
        context.read<UserNutritionData>().updateCurrentFoodItemServings(widget.controller.text);
        context.read<UserNutritionData>().updateCurrentFoodItemServingSize(widget.secondaryController.text);
      }
      else if (widget.servingSize) {
        context.read<UserNutritionData>().updateCurrentFoodItemServingSize(widget.controller.text);
        context.read<UserNutritionData>().updateCurrentFoodItemServings(widget.secondaryController.text);
      }
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: appPrimaryColour),
        ),
      ),
      child: Stack(
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
          Align(
            alignment: widget.centerForm ? Alignment.center : Alignment.centerRight,
            child: SizedBox(
              width: widget.width/1.75,
              child: Form(
                key: widget.formKey,
                child: TextFormField(
                  focusNode: focusNode,
                  inputFormatters: widget.numbersOnly ? textInputFormatter : null,
                  keyboardType: widget.numbersOnly ? TextInputType.number : TextInputType.text,
                  controller: widget.controller,
                  cursorColor: Colors.white,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: (20),
                  ),
                  textAlign: widget.centerForm ? TextAlign.center : TextAlign.left,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: (widget.width/12)/2.5, left: 5, right: 5,),
                    hintText: 'N/A',
                    hintStyle: const TextStyle(
                      color: Colors.white30,
                      fontSize: (18),
                    ),
                    errorStyle: const TextStyle(
                      height: 0,
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: appSecondaryColour,
                      ),
                    ),
                    border: InputBorder.none,
                  ),
                  onFieldSubmitted: (value) {
                    widget.name ? SaveName() : SaveServings();
                  },
                  onTapOutside: (value) {
                    widget.name ? SaveName() : SaveServings();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
