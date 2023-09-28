import 'package:fitness_tracker/constants.dart';
import 'package:flutter/material.dart';

class FoodNutritionListText extends StatefulWidget {
  const FoodNutritionListText({Key? key,
    required this.value,
    required this.width,
    required this.title,
    this.units = "mg",
    this.servingSize = "100",
    this.servings = "1",
    this.decimalPlacesToRound = 2,

  }) : super(key: key);

  final  double width;
  final  String title, value;
  final  String servingSize;
  final  String servings;
  final  String units;
  final  int decimalPlacesToRound;


  @override
  State<FoodNutritionListText> createState() => _FoodNutritionListTextState();
}

class _FoodNutritionListTextState extends State<FoodNutritionListText> {

  String ServingSizeCalculator(String valuePerOneHundred, String servingSize, String servings, int decimalPlaces) {

    try {
      if (((double.parse(valuePerOneHundred) / 100) * (double.parse(servingSize) * double.parse(servings))) < 0.1) {
        return ((double.parse(valuePerOneHundred) / 100) * (double.parse(servingSize) * double.parse(servings))).toStringAsFixed(decimalPlaces+1).replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), '');
      }
      return ((double.parse(valuePerOneHundred) / 100) * (double.parse(servingSize) * double.parse(servings))).toStringAsFixed(decimalPlaces).replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), '');
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
                 widget.value.isEmpty || widget.value == "0.00" || widget.value == "0" ? "-" : widget.value + " ${widget.units}",
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
                widget.value.isEmpty || widget.value == "0.00" || widget.value == "0" ? "-" :
                ServingSizeCalculator(widget.value, widget.servingSize, widget.servings, widget.decimalPlacesToRound) + " ${widget.units}",
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
