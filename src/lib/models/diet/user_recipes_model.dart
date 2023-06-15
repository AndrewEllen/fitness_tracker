import 'package:fitness_tracker/models/diet/food_item.dart';

import 'food_data_list_item.dart';

class UserRecipesModel {

  Map<String, dynamic> toMap() {

    List<Map> ConvertToMapList({required List<ListFoodItem> foodList}) {
      List<Map> foodListMap = [];
      foodList.forEach((ListFoodItem foodListItem) {
        Map food = foodListItem.toMap();
        foodListMap.add(food);
      });
      return foodListMap;
    }

    return {
      'barcode': barcode,
      'recipeFoodList': ConvertToMapList(foodList: recipeFoodList),
      'foodData': foodData,
    };
  }
  UserRecipesModel({
    required this.barcode,
    required this.recipeFoodList,
    required this.foodData,
  });

  String barcode;
  List<ListFoodItem> recipeFoodList;
  FoodItem foodData;
}
