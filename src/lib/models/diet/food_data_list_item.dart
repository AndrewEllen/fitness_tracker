//[LO3.7.3.5]
//Food list item construct/model
//Incomplete and unused currently. Will probably need changes made when actually being used
//Intended use is to store just the data of the specific food that is required for the user. All the macros can be taken from the database if required.
//This just stores how much the user had in the day and when looking back

import 'food_item.dart';

class ListFoodItem {
  Map<String, dynamic> toMap() {
    return {
      'barcode': barcode,
      'category': category,
      'foodServings': foodServings,
      'foodServingSize': foodServingSize,
      'recipe': recipe,
    };
  }
  ListFoodItem({
    required this.barcode,
    required this.category,
    required this.foodServings,
    required this.foodServingSize,
    required this.foodItemData,
    required this.recipe,
  });

  String barcode;
  String category;
  String foodServings;
  String foodServingSize;
  FoodItem foodItemData;
  bool recipe;

}
