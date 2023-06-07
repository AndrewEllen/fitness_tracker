import 'package:fitness_tracker/providers/user_nutrition_data.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import '../models/food_item.dart';

//[LO3.7.3.5]
//Checks public food database

checkFoodBarcodeOpenFF(barcodeDisplayValue) async {

  ProductQueryConfiguration foodQueryConfiguration = ProductQueryConfiguration(
      barcodeDisplayValue,
      version: ProductQueryVersion.v3
  );

  ProductResultV3 product = await OpenFoodAPIClient.getProductV3(foodQueryConfiguration);

  return product;

}