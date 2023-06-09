
class UserNutritionHistoryModel {

  Map<String, dynamic> toMap() {
    return {
      'barcodes' : barcodes,
      'foodListItemNames': foodListItemNames,
      'foodServings': foodServings,
      'foodServingSize': foodServingSize,
    };
  }
  UserNutritionHistoryModel({
    required this.barcodes,
    required this.foodListItemNames,
    required this.foodServings,
    required this.foodServingSize,
  });

  List<String> barcodes;
  List<String> foodListItemNames;
  List<String> foodServings;
  List<String> foodServingSize;
}
