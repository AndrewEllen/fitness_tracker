import 'package:flutter/material.dart';
import 'package:fitness_tracker/constants.dart';
import 'package:fitness_tracker/exports.dart';

import '../models/food_data_list_item.dart';

class FoodListDisplayBox extends StatelessWidget {
  FoodListDisplayBox({Key? key,
    required this.foodObject,
    required this.width,
    this.onTap,
    this.onTapIcon,
    this.onTapIcon2,
    this.icon,
    this.icon2,
    this.iconColour,
    this.icon2Colour,
  }) : super(key: key);

  late ListFoodItem foodObject;
  final IconData? icon, icon2;
  late Color? iconColour, icon2Colour;
  final VoidCallback? onTap, onTapIcon, onTapIcon2;
  late double width;

  @override
  Widget build(BuildContext context) {
    if (iconColour?.value == null) {
      iconColour = Colors.white;
    }
    if (icon2Colour?.value == null) {
      icon2Colour = Colors.white;
    }
    return Container(
      margin: const EdgeInsets.all(4),
      height: 60,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        color: appQuinaryColour,
      ),
      child: ListTile(
        onTap: onTap,
        leading: Padding(
          padding: const EdgeInsets.only(
            bottom: 15,
            top: 5,
          ),
          child: Container(
            width: 55,
            height: 55,
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              border: Border.all(
                  color: appSecondaryColour,
                  width: 2
              ),
              borderRadius: const BorderRadius.all(Radius.circular(45)),
              color: Colors.transparent,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 100,
                  minHeight: 10,
                  maxWidth: 100,
                  minWidth: 100,
                ),
                child: FittedBox(
                  clipBehavior: Clip.antiAlias,
                  child: Text(
                    foodObject.foodCalories + "\n Kcal",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        title: Padding(
          padding: EdgeInsets.only(
              left: width/30,
            bottom: 10,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 100,
              minHeight: 10,
              maxWidth: 100,
              minWidth: 100,
            ),
            child: FittedBox(
              child: Text(
                foodObject.foodName,
                style: const TextStyle(
                    color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(
              left: width/8,
            bottom: 10,
          ),
          child: Text(
            foodObject.foodServings + " Servings, " +
                (double.parse(foodObject.foodServingSize) * double.parse(foodObject.foodServings)).toStringAsFixed(1)
                + "g",
            style: const TextStyle(
                color: Colors.white70,
                fontSize: 14
            ),
          ),
        ),
        trailing: icon != null && icon2 != null ?
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: onTapIcon,
                icon: Icon(
                  icon,
                  color: iconColour,
                ),
              ),
              IconButton(
                onPressed: onTapIcon2,
                icon: Icon(
                  icon2,
                  color: icon2Colour,
                ),
              ),
            ],
          ),
        ) : icon != null ?
        IconButton(
          onPressed: onTapIcon,
          icon: Icon(
            icon,
            color: iconColour,
          ),
        ) :
        null,
      ),
    );
  }
}
