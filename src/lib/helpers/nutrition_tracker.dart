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

SearchOFF(String value) async {

  List<FoodItem> foodItems = [];

  String convertToUsableData(dynamic valueToConvert) {
    if (valueToConvert != null) {
      valueToConvert = valueToConvert.toString();
    } else {
      valueToConvert = "";
    }

    return valueToConvert;
  }

  ProductSearchQueryConfiguration configuration =
  ProductSearchQueryConfiguration(
    parametersList: <Parameter>[
      SearchTerms(terms: [value]),
    ], version: ProductQueryVersion.v3,
  );

  SearchResult result = await OpenFoodAPIClient.searchProducts(
    const User(userId: '', password: ''),
    configuration,
  );

  result.products?.forEach((product) {

    if (product.productName?.isNotEmpty ?? false) {

      FoodItem useableResult = FoodItem(
          barcode: convertToUsableData(product.barcode),
          foodName: convertToUsableData(product.productName),
          quantity: convertToUsableData(
              product.quantity?.replaceAll(RegExp("[a-zA-Z:\s]"), "") ??
                  "1"),
          servingSize: convertToUsableData(
              product.servingSize?.replaceAll(
                  RegExp("[a-zA-Z:\s]"), "") ?? "100"),
          servings: "1",
          calories: convertToUsableData(product.nutriments?.getValue(
              Nutrient.energyKCal, PerSize.oneHundredGrams)),
          kiloJoules: convertToUsableData(product.nutriments?.getValue(
              Nutrient.energyKJ, PerSize.oneHundredGrams)),
          proteins: convertToUsableData(product.nutriments?.getValue(
              Nutrient.proteins, PerSize.oneHundredGrams)),
          carbs: convertToUsableData(product.nutriments?.getValue(
              Nutrient.carbohydrates, PerSize.oneHundredGrams)),
          fiber: convertToUsableData(product.nutriments?.getValue(
              Nutrient.fiber, PerSize.oneHundredGrams)),
          sugars: convertToUsableData(product.nutriments?.getValue(
              Nutrient.sugars, PerSize.oneHundredGrams)),
          fat: convertToUsableData(product.nutriments?.getValue(
              Nutrient.fat, PerSize.oneHundredGrams)),
          saturatedFat: convertToUsableData(product.nutriments?.getValue(
              Nutrient.saturatedFat, PerSize.oneHundredGrams)),
          polyUnsaturatedFat: convertToUsableData(
              product.nutriments?.getValue(
                  Nutrient.polyunsaturatedFat, PerSize.oneHundredGrams)),
          monoUnsaturatedFat: convertToUsableData(
              product.nutriments?.getValue(
                  Nutrient.monounsaturatedFat, PerSize.oneHundredGrams)),
          transFat: convertToUsableData(product.nutriments?.getValue(
              Nutrient.transFat, PerSize.oneHundredGrams)),
          cholesterol: convertToUsableData(product.nutriments?.getValue(
              Nutrient.cholesterol, PerSize.oneHundredGrams)),
          calcium: convertToUsableData(product.nutriments?.getValue(
              Nutrient.calcium, PerSize.oneHundredGrams)),
          iron: convertToUsableData(product.nutriments?.getValue(
              Nutrient.iron, PerSize.oneHundredGrams)),
          sodium: convertToUsableData(product.nutriments?.getValue(
              Nutrient.sodium, PerSize.oneHundredGrams)),
          zinc: convertToUsableData(product.nutriments?.getValue(
              Nutrient.zinc, PerSize.oneHundredGrams)),
          magnesium: convertToUsableData(product.nutriments?.getValue(
              Nutrient.magnesium, PerSize.oneHundredGrams)),
          potassium: convertToUsableData(product.nutriments?.getValue(
              Nutrient.potassium, PerSize.oneHundredGrams)),
          vitaminA: convertToUsableData(product.nutriments?.getValue(
              Nutrient.vitaminA, PerSize.oneHundredGrams)),
          vitaminB1: convertToUsableData(product.nutriments?.getValue(
              Nutrient.vitaminB1, PerSize.oneHundredGrams)),
          vitaminB2: convertToUsableData(product.nutriments?.getValue(
              Nutrient.vitaminB2, PerSize.oneHundredGrams)),
          vitaminB3: convertToUsableData(product.nutriments?.getValue(
              Nutrient.vitaminPP, PerSize.oneHundredGrams)),
          vitaminB6: convertToUsableData(product.nutriments?.getValue(
              Nutrient.vitaminB6, PerSize.oneHundredGrams)),
          vitaminB9: convertToUsableData(product.nutriments?.getValue(
              Nutrient.vitaminB9, PerSize.oneHundredGrams)),
          vitaminB12: convertToUsableData(product.nutriments?.getValue(
              Nutrient.vitaminB12, PerSize.oneHundredGrams)),
          vitaminC: convertToUsableData(product.nutriments?.getValue(
              Nutrient.vitaminC, PerSize.oneHundredGrams)),
          vitaminD: convertToUsableData(product.nutriments?.getValue(
              Nutrient.vitaminD, PerSize.oneHundredGrams)),
          vitaminE: convertToUsableData(product.nutriments?.getValue(
              Nutrient.vitaminE, PerSize.oneHundredGrams)),
          vitaminK: convertToUsableData(product.nutriments?.getValue(
              Nutrient.vitaminK, PerSize.oneHundredGrams)),
          omega3: convertToUsableData(product.nutriments?.getValue(
              Nutrient.omega3, PerSize.oneHundredGrams)),
          omega6: convertToUsableData(product.nutriments?.getValue(
              Nutrient.omega6, PerSize.oneHundredGrams)),
          alcohol: convertToUsableData(product.nutriments?.getValue(
              Nutrient.alcohol, PerSize.oneHundredGrams)),
          biotin: convertToUsableData(product.nutriments?.getValue(
              Nutrient.biotin, PerSize.oneHundredGrams)),
          butyricAcid: convertToUsableData(product.nutriments?.getValue(
              Nutrient.butyricAcid, PerSize.oneHundredGrams)),
          caffeine: convertToUsableData(product.nutriments?.getValue(
              Nutrient.caffeine, PerSize.oneHundredGrams)),
          capricAcid: convertToUsableData(product.nutriments?.getValue(
              Nutrient.capricAcid, PerSize.oneHundredGrams)),
          caproicAcid: convertToUsableData(product.nutriments?.getValue(
              Nutrient.caproicAcid, PerSize.oneHundredGrams)),
          caprylicAcid: convertToUsableData(product.nutriments?.getValue(
              Nutrient.caprylicAcid, PerSize.oneHundredGrams)),
          chloride: convertToUsableData(product.nutriments?.getValue(
              Nutrient.chloride, PerSize.oneHundredGrams)),
          chromium: convertToUsableData(product.nutriments?.getValue(
              Nutrient.chromium, PerSize.oneHundredGrams)),
          copper: convertToUsableData(product.nutriments?.getValue(
              Nutrient.copper, PerSize.oneHundredGrams)),
          docosahexaenoicAcid: convertToUsableData(
              product.nutriments?.getValue(
                  Nutrient.docosahexaenoicAcid, PerSize.oneHundredGrams)),
          eicosapentaenoicAcid: convertToUsableData(
              product.nutriments?.getValue(
                  Nutrient.eicosapentaenoicAcid, PerSize.oneHundredGrams)),
          erucicAcid: convertToUsableData(product.nutriments?.getValue(
              Nutrient.erucicAcid, PerSize.oneHundredGrams)),
          fluoride: convertToUsableData(product.nutriments?.getValue(
              Nutrient.fluoride, PerSize.oneHundredGrams)),
          iodine: convertToUsableData(product.nutriments?.getValue(
              Nutrient.iodine, PerSize.oneHundredGrams)),
          manganese: convertToUsableData(product.nutriments?.getValue(
              Nutrient.manganese, PerSize.oneHundredGrams)),
          molybdenum: convertToUsableData(product.nutriments?.getValue(
              Nutrient.molybdenum, PerSize.oneHundredGrams)),
          myristicAcid: convertToUsableData(product.nutriments?.getValue(
              Nutrient.myristicAcid, PerSize.oneHundredGrams)),
          oleicAcid: convertToUsableData(product.nutriments?.getValue(
              Nutrient.oleicAcid, PerSize.oneHundredGrams)),
          palmiticAcid: convertToUsableData(product.nutriments?.getValue(
              Nutrient.palmiticAcid, PerSize.oneHundredGrams)),
          pantothenicAcid: convertToUsableData(
              product.nutriments?.getValue(
                  Nutrient.pantothenicAcid, PerSize.oneHundredGrams)),
          selenium: convertToUsableData(product.nutriments?.getValue(
              Nutrient.selenium, PerSize.oneHundredGrams)),
          stearicAcid: convertToUsableData(product.nutriments?.getValue(
              Nutrient.stearicAcid, PerSize.oneHundredGrams))
      );

      foodItems.add(useableResult);

    }

  });

  foodItems.forEach((product) => print(product.foodName));

  return foodItems;

}