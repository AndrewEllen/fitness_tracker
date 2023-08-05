import 'exercise_calories_list_item.dart';
import 'food_data_list_item.dart';

class UserNutritionModel {

  Map<String, dynamic> toMap() {

    List<Map> ConvertToMapListFood({required List<ListFoodItem> foodList}) {
      List<Map> foodListMap = [];
      for (var foodListItem in foodList) {
        Map food = foodListItem.toMap();
        foodListMap.add(food);
      }
      return foodListMap;
    }

    List<Map> ConvertToMapListExercise({required List<ListExerciseItem> exerciseList}) {
      List<Map> exerciseListMap = [];
      for (var exerciseListItem in exerciseList) {
        Map exercise = exerciseListItem.toMap();
        exerciseListMap.add(exercise);
      }
      return exerciseListMap;
    }

    return {
      'date': date,
      'foodListItemsBreakfast': ConvertToMapListFood(foodList: foodListItemsBreakfast),
      'foodListItemsLunch': ConvertToMapListFood(foodList: foodListItemsLunch),
      'foodListItemsDinner': ConvertToMapListFood(foodList: foodListItemsDinner),
      'foodListItemsSnacks': ConvertToMapListFood(foodList: foodListItemsSnacks),
      'foodListItemsExercise': ConvertToMapListExercise(exerciseList: foodListItemsExercise),
    };
  }

  UserNutritionModel({
    required this.date,
    required this.foodListItemsBreakfast,
    required this.foodListItemsLunch,
    required this.foodListItemsDinner,
    required this.foodListItemsSnacks,
    required this.foodListItemsExercise,
  });

  String date;
  List<ListFoodItem> foodListItemsBreakfast;
  List<ListFoodItem> foodListItemsLunch;
  List<ListFoodItem> foodListItemsDinner;
  List<ListFoodItem> foodListItemsSnacks;
  List<ListExerciseItem> foodListItemsExercise;
}
