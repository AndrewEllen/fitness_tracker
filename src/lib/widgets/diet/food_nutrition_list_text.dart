import 'package:fitness_tracker/constants.dart';
import 'package:flutter/material.dart';

class FoodNutritionListText extends StatefulWidget {
  const FoodNutritionListText({Key? key,
    required this.value,
    required this.width,
    required this.title,
    this.servingSize = "100",
    this.servings = "1",

  }) : super(key: key);

  final  double width;
  final  String title, value;
  final  String servingSize;
  final  String servings;


  @override
  State<FoodNutritionListText> createState() => _FoodNutritionListTextState();
}

class _FoodNutritionListTextState extends State<FoodNutritionListText> {

  String ServingSizeCalculator(String valuePerOneHundred, String servingSize, String servings, int decimalPlaces) {

    try {
      return ((double.parse(valuePerOneHundred) / 100) * (double.parse(servingSize) * double.parse(servings))).toStringAsFixed(decimalPlaces);
    } catch (error) {
      return "-";
    }

  }

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: appPrimaryColour),
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              "${widget.title}:",
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
         Center(
             child: Padding(
               padding: const EdgeInsets.all(5.0),
               child: Text(
                 widget.value.isEmpty ? "-" : widget.value,
                 style: const TextStyle(
                   color: Colors.white,
                 ),
               ),
             ),
         ),
          Padding(
            padding: const EdgeInsets.only(
              top: 5,
              bottom: 5,
              left: 5,
              right: 45,
            ),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                widget.value.isEmpty ? "-" :
                ServingSizeCalculator(widget.value, widget.servingSize, widget.servings, 1),
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
