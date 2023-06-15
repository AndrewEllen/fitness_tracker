import 'food_data_list_item.dart';

class UserNutritionModel {

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
      'date': date,
      'foodListItemsBreakfast': ConvertToMapList(foodList: foodListItemsBreakfast),
      'foodListItemsLunch': ConvertToMapList(foodList: foodListItemsLunch),
      'foodListItemsDinner': ConvertToMapList(foodList: foodListItemsDinner),
      'foodListItemsSnacks': ConvertToMapList(foodList: foodListItemsSnacks),
    };
  }
  UserNutritionModel({
    required this.date,
    required this.foodListItemsBreakfast,
    required this.foodListItemsLunch,
    required this.foodListItemsDinner,
    required this.foodListItemsSnacks,
  });

  String date;
  List<ListFoodItem> foodListItemsBreakfast;
  List<ListFoodItem> foodListItemsLunch;
  List<ListFoodItem> foodListItemsDinner;
  List<ListFoodItem> foodListItemsSnacks;
}
