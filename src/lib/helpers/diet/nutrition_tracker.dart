import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_tracker/helpers/general/string_extensions.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import '../../models/diet/food_item.dart';
import '../../providers/general/database_get.dart';

//[LO3.7.3.5]
//Checks public food database

FoodItem ConvertToFoodItem(product, {String scannedBarcode = "", bool firebase = false}) {

  if (firebase) {

    FoodItem foodItem = FoodItem(
      barcode: product["barcode"] ?? "",
      foodName: product["foodName"] ?? "",
      quantity: product["quantity"] ?? "",
      servingSize: product["servingSize"] ?? "",
      servings: product["servings"] ?? "",
      calories: product["calories"] ?? "",
      kiloJoules: product["kiloJoules"] ?? "",
      proteins: product["proteins"] ?? "",
      carbs: product["carbs"] ?? "",
      fiber: product["fiber"] ?? "",
      sugars: product["sugars"] ?? "",
      fat: product["fat"] ?? "",
      saturatedFat: product["saturatedFat"] ?? "",
      polyUnsaturatedFat: product["polyUnsaturatedFat"] ?? "",
      monoUnsaturatedFat: product["monoUnsaturatedFat"] ?? "",
      transFat: product["transFat"] ?? "",
      cholesterol: product["cholesterol"] ?? "",
      calcium: product["calcium"] ?? "",
      iron: product["iron"] ?? "",
      sodium: product["sodium"] ?? "",
      zinc: product["zinc"] ?? "",
      magnesium: product["magnesium"] ?? "",
      potassium: product["potassium"] ?? "",
      vitaminA: product["vitaminA"] ?? "",
      vitaminB1: product["vitaminB1"] ?? "",
      vitaminB2: product["vitaminB2"] ?? "",
      vitaminB3: product["vitaminB3"] ?? "",
      vitaminB6: product["vitaminB6"] ?? "",
      vitaminB9: product["vitaminB9"] ?? "",
      vitaminB12: product["vitaminB12"] ?? "",
      vitaminC: product["vitaminC"] ?? "",
      vitaminD: product["vitaminD"] ?? "",
      vitaminE: product["vitaminE"] ?? "",
      vitaminK: product["vitaminK"] ?? "",
      omega3: product["omega3"] ?? "",
      omega6: product["omega6"] ?? "",
      alcohol: product["alcohol"] ?? "",
      biotin: product["biotin"] ?? "",
      butyricAcid: product["butyricAcid"] ?? "",
      caffeine: product["caffeine"] ?? "",
      capricAcid: product["capricAcid"] ?? "",
      caproicAcid: product["caproicAcid"] ?? "",
      caprylicAcid: product["caprylicAcid"] ?? "",
      chloride: product["chloride"] ?? "",
      chromium: product["chromium"] ?? "",
      copper: product["copper"] ?? "",
      docosahexaenoicAcid: product["docosahexaenoicAcid"] ?? "",
      eicosapentaenoicAcid: product["eicosapentaenoicAcid"] ?? "",
      erucicAcid: product["erucicAcid"] ?? "",
      fluoride: product["fluoride"] ?? "",
      iodine: product["iodine"] ?? "",
      manganese: product["manganese"] ?? "",
      molybdenum: product["molybdenum"] ?? "",
      myristicAcid: product["myristicAcid"] ?? "",
      oleicAcid: product["oleicAcid"] ?? "",
      palmiticAcid: product["palmiticAcid"] ?? "",
      pantothenicAcid: product["pantothenicAcid"] ?? "",
      selenium: product["selenium"] ?? "",
      stearicAcid: product["stearicAcid"] ?? "",
    );

    try {
      foodItem.foodName = foodItem.foodName.capitalize();
    } catch (error) {
      print(error);
    }

    return foodItem;
  }

  if (product != null) {
    return FoodItem(
        barcode: ConvertToUsableData(product.barcode),
        foodName: ConvertToUsableData(product.productName).capitalize(),
        quantity: ConvertToUsableData(
            product.quantity?.replaceAll(RegExp("[a-zA-Z:s]"), "") ??
                "1"),
        servingSize: ConvertToUsableData(
            product.servingSize?.replaceAll(
                RegExp("[a-zA-Z:s]"), "") ?? "100"),
        servings: "1",
        calories: ConvertToUsableData(product.nutriments?.getValue(
            Nutrient.energyKCal, PerSize.oneHundredGrams), defaultValue: "0"),
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

  return FoodItem(
      barcode: scannedBarcode,
      foodName: "",
      quantity: "100",
      servingSize: "100",
      servings: "1",
      calories: "",
      kiloJoules: "",
      proteins: "",
      carbs: "",
      fiber: "",
      sugars: "",
      fat: "",
      saturatedFat: "",
      polyUnsaturatedFat: "",
      monoUnsaturatedFat: "",
      transFat: "",
      cholesterol: "",
      calcium: "",
      iron: "",
      sodium: "",
      zinc: "",
      magnesium: "",
      potassium: "",
      vitaminA: "",
      vitaminB1: "",
      vitaminB2: "",
      vitaminB3: "",
      vitaminB6: "",
      vitaminB9: "",
      vitaminB12: "",
      vitaminC: "",
      vitaminD: "",
      vitaminE: "",
      vitaminK: "",
      omega3: "",
      omega6: "",
      alcohol: "",
      biotin: "",
      butyricAcid: "",
      caffeine: "",
      capricAcid: "",
      caproicAcid: "",
      caprylicAcid: "",
      chloride: "",
      chromium: "",
      copper: "",
      docosahexaenoicAcid: "",
      eicosapentaenoicAcid: "",
      erucicAcid: "",
      fluoride: "",
      iodine: "",
      manganese: "",
      molybdenum: "",
      myristicAcid: "",
      oleicAcid: "",
      palmiticAcid: "",
      pantothenicAcid: "",
      selenium: "",
      stearicAcid: "",
      newItem: true,
  );


}

String ConvertToUsableData(dynamic valueToConvert, {String defaultValue = ""}) {
  if (valueToConvert != null) {
    valueToConvert = valueToConvert.toString();
  } else {
    valueToConvert = defaultValue;
  }

  return valueToConvert;
}

CheckFoodBarcode(String barcodeDisplayValue, {bool recipe = false}) async {

  if (recipe) {

    FoodItem newFoodItem = await GetFoodDataFromFirebaseRecipe(barcodeDisplayValue);

    print("un Capitalised Name");
    print(newFoodItem.foodName);

    try {
      print("Capitalised Name");
      print(newFoodItem.foodName);
      newFoodItem.foodName = newFoodItem.foodName.capitalize();
      print(newFoodItem.foodName);
    } catch (error) {
      print(error);
    }

    return newFoodItem;

  } else {

    try {

      print("firebase");

      FoodItem newFoodItem = await GetFoodDataFromFirebase(barcodeDisplayValue);

      print("un Capitalised Name");
      print(newFoodItem.foodName);

      try {
        print("Capitalised Name");
        print(newFoodItem.foodName);
        newFoodItem.foodName = newFoodItem.foodName.capitalize();
        print(newFoodItem.foodName);
      } catch (error) {
        print(error);
      }

      return newFoodItem;

    } catch (error){

      print("openFF");

      ProductResultV3 product = await CheckFoodBarcodeOpenFF(barcodeDisplayValue);

      FoodItem newFoodItem = ConvertToFoodItem(product.product, scannedBarcode: barcodeDisplayValue);

      newFoodItem.foodName = newFoodItem.foodName.capitalize();

      return newFoodItem;

    }
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

SearchByNameFirebase(String value) async {

  List<FoodItem> foodItems = [];

  try {


    final snapshot = await FirebaseFirestore.instance
        .collection("food-data")
        .where("food-data.foodName", isGreaterThanOrEqualTo: value)
        .where("food-data.foodName", isLessThanOrEqualTo: value + "\uf8ff")
        .limit(20)
        .get();

    foodItems = [
      for (QueryDocumentSnapshot document in snapshot.docs)
        ConvertToFoodItem(document.get("food-data"), firebase: true)
          ..firebaseItem = true,
    ];

  } catch (error) { print(error); }

  return foodItems;

}

SearchByNameTriGramFirebase(String value) async {

  List<FoodItem> foodItems = [];
  List<String> searchValues = value.triGram();

  print(searchValues);

  try {


    final snapshot = await FirebaseFirestore.instance
        .collection("food-data")
        .where("foodNameSearch", arrayContainsAny: searchValues)
        .limit(20)
        .get();

    foodItems = [
      for (QueryDocumentSnapshot document in snapshot.docs)
        ConvertToFoodItem(document.get("food-data"), firebase: true)
          ..firebaseItem = true,
    ];

  } catch (error) { print(error); }

  List<String> splitSearchValues = value.split(" ");

  foodItems.removeWhere((item) => item.foodName.split(" ").highestListSimilarity(splitSearchValues) < 0.5);

  return foodItems;

}

SearchByNameOpenff(String value) async {

  List<FoodItem> foodItems = [];

  try {

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

      print("search");
      if ((product.productName!.isNotEmpty && product.barcode!.isNotEmpty)) {

        FoodItem useableResult = ConvertToFoodItem(product, scannedBarcode: product.barcode!);

        foodItems.add(useableResult);

      }

    });

  } catch (error) { print(error); }

  return foodItems;

}