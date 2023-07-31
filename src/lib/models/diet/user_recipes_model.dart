import 'package:fitness_tracker/models/diet/food_item.dart';

import 'food_data_list_item.dart';

class UserRecipesModel {

  Map<String, dynamic> toMap() {

    List<String> ConvertToList({required List<ListFoodItem> foodList}) {
      List<String> barcodeList = [];
      for (var foodListItem in foodList) {
        barcodeList.add(foodListItem.barcode);
      }
      return barcodeList;
    }

    return {
      'barcode': barcode,
      'recipeBarcodeList': ConvertToList(foodList: recipeFoodList),
      'foodData': foodData.toMap(),
    };
  }
  UserRecipesModel({
    required this.barcode,
    required this.recipeFoodList,
    required this.barcodeList,
    required this.foodData,
  });

  String barcode;
  List<ListFoodItem> recipeFoodList;
  List<String> barcodeList;
  FoodItem foodData;
}
