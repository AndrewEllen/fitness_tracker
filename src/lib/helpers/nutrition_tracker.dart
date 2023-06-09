import 'package:fitness_tracker/providers/user_nutrition_data.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import '../models/food_item.dart';
import '../providers/database_get.dart';

//[LO3.7.3.5]
//Checks public food database

FoodItem ConvertToFoodItem(product) {
  return FoodItem(
      barcode: ConvertToUsableData(product.barcode),
      foodName: ConvertToUsableData(product.productName),
      quantity: ConvertToUsableData(
          product.quantity?.replaceAll(RegExp("[a-zA-Z:\s]"), "") ??
              "1"),
      servingSize: ConvertToUsableData(
          product.servingSize?.replaceAll(
              RegExp("[a-zA-Z:\s]"), "") ?? "100"),
      servings: "1",
      calories: ConvertToUsableData(product.nutriments?.getValue(
          Nutrient.energyKCal, PerSize.oneHundredGrams)),
      kiloJoules: ConvertToUsableData(product.nutriments?.getValue(
          Nutrient.energyKJ, PerSize.oneHundredGrams)),
      proteins: ConvertToUsableData(product.nutriments?.getValue(
          Nutrient.proteins, PerSize.oneHundredGrams)),
      carbs: ConvertToUsableData(product.nutriments?.getValue(
          Nutrient.carbohydrates, PerSize.oneHundredGrams)),
      fiber: ConvertToUsableData(product.nutriments?.getValue(
          Nutrient.fiber, PerSize.oneHundredGrams)),
      sugars: ConvertToUsableData(product.nutriments?.getValue(
          Nutrient.sugars, PerSize.oneHundredGrams)),
      fat: ConvertToUsableData(product.nutriments?.getValue(
          Nutrient.fat, PerSize.oneHundredGrams)),
      saturatedFat: ConvertToUsableData(product.nutriments?.getValue(
          Nutrient.saturatedFat, PerSize.oneHundredGrams)),
      polyUnsaturatedFat: ConvertToUsableData(
          product.nutriments?.getValue(
              Nutrient.polyunsaturatedFat, PerSize.oneHundredGrams)),
      monoUnsaturatedFat: ConvertToUsableData(
          product.nutriments?.getValue(
              Nutrient.monounsaturatedFat, PerSize.oneHundredGrams)),
      transFat: ConvertToUsableData(product.nutriments?.getValue(
          Nutrient.transFat, PerSize.oneHundredGrams)),
      cholesterol: ConvertToUsableData(product.nutriments?.getValue(
          Nutrient.cholesterol, PerSize.oneHundredGrams)),
      calcium: ConvertToUsableData(product.nutriments?.getValue(
          Nutrient.calcium, PerSize.oneHundredGrams)),
      iron: ConvertToUsableData(product.nutriments?.getValue(
          Nutrient.iron, PerSize.oneHundredGrams)),
      sodium: ConvertToUsableData(product.nutriments?.getValue(
          Nutrient.sodium, PerSize.oneHundredGrams)),
      zinc: ConvertToUsableData(product.nutriments?.getValue(
          Nutrient.zinc, PerSize.oneHundredGrams)),
      magnesium: ConvertToUsableData(product.nutriments?.getValue(
          Nutrient.magnesium, PerSize.oneHundredGrams)),
      potassium: ConvertToUsableData(product.nutriments?.getValue(
          Nutrient.potassium, PerSize.oneHundredGrams)),
      vitaminA: ConvertToUsableData(product.nutriments?.getValue(
          Nutrient.vitaminA, PerSize.oneHundredGrams)),
      vitaminB1: ConvertToUsableData(product.nutriments?.getValue(
          Nutrient.vitaminB1, PerSize.oneHundredGrams)),
      vitaminB2: ConvertToUsableData(product.nutriments?.getValue(
          Nutrient.vitaminB2, PerSize.oneHundredGrams)),
      vitaminB3: ConvertToUsableData(product.nutriments?.getValue(
          Nutrient.vitaminPP, PerSize.oneHundredGrams)),
      vitaminB6: ConvertToUsableData(product.nutriments?.getValue(
          Nutrient.vitaminB6, PerSize.oneHundredGrams)),
      vitaminB9: ConvertToUsableData(product.nutriments?.getValue(
          Nutrient.vitaminB9, PerSize.oneHundredGrams)),
      vitaminB12: ConvertToUsableData(product.nutriments?.getValue(
          Nutrient.vitaminB12, PerSize.oneHundredGrams)),
      vitaminC: ConvertToUsableData(product.nutriments?.getValue(
          Nutrient.vitaminC, PerSize.oneHundredGrams)),
      vitaminD: ConvertToUsableData(product.nutriments?.getValue(
          Nutrient.vitaminD, PerSize.oneHundredGrams)),
      vitaminE: ConvertToUsableData(product.nutriments?.getValue(
          Nutrient.vitaminE, PerSize.oneHundredGrams)),
      vitaminK: ConvertToUsableData(product.nutriments?.getValue(
          Nutrient.vitaminK, PerSize.oneHundredGrams)),
      omega3: ConvertToUsableData(product.nutriments?.getValue(
          Nutrient.omega3, PerSize.oneHundredGrams)),
      omega6: ConvertToUsableData(product.nutriments?.getValue(
          Nutrient.omega6, PerSize.oneHundredGrams)),
      alcohol: ConvertToUsableData(product.nutriments?.getValue(
          Nutrient.alcohol, PerSize.oneHundredGrams)),
      biotin: ConvertToUsableData(product.nutriments?.getValue(
          Nutrient.biotin, PerSize.oneHundredGrams)),
      butyricAcid: ConvertToUsableData(product.nutriments?.getValue(
          Nutrient.butyricAcid, PerSize.oneHundredGrams)),
      caffeine: ConvertToUsableData(product.nutriments?.getValue(
          Nutrient.caffeine, PerSize.oneHundredGrams)),
      capricAcid: ConvertToUsableData(product.nutriments?.getValue(
          Nutrient.capricAcid, PerSize.oneHundredGrams)),
      caproicAcid: ConvertToUsableData(product.nutriments?.getValue(
          Nutrient.caproicAcid, PerSize.oneHundredGrams)),
      caprylicAcid: ConvertToUsableData(product.nutriments?.getValue(
          Nutrient.caprylicAcid, PerSize.oneHundredGrams)),
      chloride: ConvertToUsableData(product.nutriments?.getValue(
          Nutrient.chloride, PerSize.oneHundredGrams)),
      chromium: ConvertToUsableData(product.nutriments?.getValue(
          Nutrient.chromium, PerSize.oneHundredGrams)),
      copper: ConvertToUsableData(product.nutriments?.getValue(
          Nutrient.copper, PerSize.oneHundredGrams)),
      docosahexaenoicAcid: ConvertToUsableData(
          product.nutriments?.getValue(
              Nutrient.docosahexaenoicAcid, PerSize.oneHundredGrams)),
      eicosapentaenoicAcid: ConvertToUsableData(
          product.nutriments?.getValue(
              Nutrient.eicosapentaenoicAcid, PerSize.oneHundredGrams)),
      erucicAcid: ConvertToUsableData(product.nutriments?.getValue(
          Nutrient.erucicAcid, PerSize.oneHundredGrams)),
      fluoride: ConvertToUsableData(product.nutriments?.getValue(
          Nutrient.fluoride, PerSize.oneHundredGrams)),
      iodine: ConvertToUsableData(product.nutriments?.getValue(
          Nutrient.iodine, PerSize.oneHundredGrams)),
      manganese: ConvertToUsableData(product.nutriments?.getValue(
          Nutrient.manganese, PerSize.oneHundredGrams)),
      molybdenum: ConvertToUsableData(product.nutriments?.getValue(
          Nutrient.molybdenum, PerSize.oneHundredGrams)),
      myristicAcid: ConvertToUsableData(product.nutriments?.getValue(
          Nutrient.myristicAcid, PerSize.oneHundredGrams)),
      oleicAcid: ConvertToUsableData(product.nutriments?.getValue(
          Nutrient.oleicAcid, PerSize.oneHundredGrams)),
      palmiticAcid: ConvertToUsableData(product.nutriments?.getValue(
          Nutrient.palmiticAcid, PerSize.oneHundredGrams)),
      pantothenicAcid: ConvertToUsableData(
          product.nutriments?.getValue(
              Nutrient.pantothenicAcid, PerSize.oneHundredGrams)),
      selenium: ConvertToUsableData(product.nutriments?.getValue(
          Nutrient.selenium, PerSize.oneHundredGrams)),
      stearicAcid: ConvertToUsableData(product.nutriments?.getValue(
          Nutrient.stearicAcid, PerSize.oneHundredGrams))
  );
}

String ConvertToUsableData(dynamic valueToConvert) {
  if (valueToConvert != null) {
    valueToConvert = valueToConvert.toString();
  } else {
    valueToConvert = "";
  }

  return valueToConvert;
}

CheckFoodBarcode(String barcodeDisplayValue) async {
  try {

    print("Firebase");
    FoodItem newFoodItem = await GetFoodDataFromFirebase(barcodeDisplayValue);

    return newFoodItem;

  } catch (error){

    print("OpenFF");
    ProductResultV3 product = await CheckFoodBarcodeOpenFF(barcodeDisplayValue);

    return ConvertToFoodItem(product.product);

  }
}

CheckFoodBarcodeOpenFF(barcodeDisplayValue) async {

  ProductQueryConfiguration foodQueryConfiguration = ProductQueryConfiguration(
      barcodeDisplayValue,
      version: ProductQueryVersion.v3
  );

  ProductResultV3 product = await OpenFoodAPIClient.getProductV3(foodQueryConfiguration);

  return product;

}

SearchOFF(String value) async {

  List<FoodItem> foodItems = [];

  ProductSearchQueryConfiguration configuration =
  ProductSearchQueryConfiguration(
    parametersList: <Parameter>[
      SearchTerms(terms: [value]),
    ], version: ProductQueryVersion.v3, language: OpenFoodFactsLanguage.ENGLISH, country: OpenFoodFactsCountry.UNITED_KINGDOM
  );

  SearchResult result = await OpenFoodAPIClient.searchProducts(
    const User(userId: '', password: ''),
    configuration,
  );

  result.products?.forEach((product) {

    if (product.productName?.isNotEmpty ?? false) {

      FoodItem useableResult = ConvertToFoodItem(product);

      foodItems.add(useableResult);

    }

  });

  foodItems.forEach((product) => print(product.foodName));

  return foodItems;

}