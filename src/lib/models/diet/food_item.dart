//[LO3.7.3.5]
//Food item model/construct

class FoodItem {

  Map<String, dynamic> toMap() {
    return {
      'barcode': barcode,
      'foodName': foodName.toLowerCase(),
      'quantity': quantity,
      'servingSize': servingSize,
      'servings': servings,
      'calories': calories,
      'kiloJoules': kiloJoules,
      'proteins': proteins,
      'carbs': carbs,
      'fiber': fiber,
      'sugars': sugars,
      'fat': fat,
      'saturatedFat': saturatedFat,
      'polyunsaturatedFat': polyUnsaturatedFat,
      'monounsaturatedFat': monoUnsaturatedFat,
      'transFat': transFat,
      'cholesterol': cholesterol,
      'calcium': calcium,
      'iron': iron,
      'sodium': sodium,
      'zinc': zinc,
      'magnesium': magnesium,
      'potassium': potassium,
      'vitaminA': vitaminA,
      'vitaminB1': vitaminB1,
      'vitaminB2': vitaminB2,
      'vitaminB3': vitaminB3,
      'vitaminB6': vitaminB6,
      'vitaminB9': vitaminB9,
      'vitaminB12': vitaminB12,
      'vitaminC': vitaminC,
      'vitaminD': vitaminD,
      'vitaminE': vitaminE,
      'vitaminK': vitaminK,
      'omega3': omega3,
      'omega6': omega6,
      'alcohol': alcohol,
      'biotin': biotin,
      'butyricAcid': butyricAcid,
      'caffeine': caffeine,
      'capricAcid': capricAcid,
      'caproicAcid': caproicAcid,
      'caprylicAcid': caprylicAcid,
      'chloride': chloride,
      'chromium': chromium,
      'copper': copper,
      'docosahexaenoicAcid': docosahexaenoicAcid,
      'eicosapentaenoicAcid': eicosapentaenoicAcid,
      'erucicAcid': erucicAcid,
      'fluoride': fluoride,
      'iodine': iodine,
      'manganese': manganese,
      'molybdenum': molybdenum,
      'myristicAcid': myristicAcid,
      'oleicAcid': oleicAcid,
      'palmiticAcid': palmiticAcid,
      'pantothenicAcid': pantothenicAcid,
      'selenium': selenium,
      'stearicAcid': stearicAcid,
      'recipe': recipe
    };
  }

  FoodItem({
    required this.barcode,
    required this.foodName,
    required this.quantity,
    required this.servingSize,
    required this.servings,
    required this.calories,
    required this.kiloJoules,
    required this.proteins,
    required this.carbs,
    required this.fiber,
    required this.sugars,
    required this.fat,
    required this.saturatedFat,
    required this.polyUnsaturatedFat,
    required this.monoUnsaturatedFat,
    required this.transFat,
    required this.cholesterol,
    required this.calcium,
    required this.iron,
    required this.sodium,
    required this.zinc,
    required this.magnesium,
    required this.potassium,
    required this.vitaminA,
    required this.vitaminB1,
    required this.vitaminB2,
    required this.vitaminB3,
    required this.vitaminB6,
    required this.vitaminB9,
    required this.vitaminB12,
    required this.vitaminC,
    required this.vitaminD,
    required this.vitaminE,
    required this.vitaminK,
    required this.omega3,
    required this.omega6,
    required this.alcohol,
    required this.biotin,
    required this.butyricAcid,
    required this.caffeine,
    required this.capricAcid,
    required this.caproicAcid,
    required this.caprylicAcid,
    required this.chloride,
    required this.chromium,
    required this.copper,
    required this.docosahexaenoicAcid,
    required this.eicosapentaenoicAcid,
    required this.erucicAcid,
    required this.fluoride,
    required this.iodine,
    required this.manganese,
    required this.molybdenum,
    required this.myristicAcid,
    required this.oleicAcid,
    required this.palmiticAcid,
    required this.pantothenicAcid,
    required this.selenium,
    required this.stearicAcid,
    this.firebaseItem = false,
    this.recipe = false,
    this.newItem = false,
  });

  String barcode;
  String foodName;
  String quantity;
  String servingSize;
  String servings;
  String calories;
  String kiloJoules;
  String proteins;
  String carbs;
  String fiber;
  String sugars;
  String fat;
  String saturatedFat;
  String polyUnsaturatedFat;
  String monoUnsaturatedFat;
  String transFat;
  String cholesterol;
  String calcium;
  String iron;
  String sodium;
  String zinc;
  String magnesium;
  String potassium;
  String vitaminA;
  String vitaminB1;
  String vitaminB2;
  String vitaminB3;
  String vitaminB6;
  String vitaminB9;
  String vitaminB12;
  String vitaminC;
  String vitaminD;
  String vitaminE;
  String vitaminK;
  String omega3;
  String omega6;
  String alcohol;
  String biotin;
  String butyricAcid;
  String caffeine;
  String capricAcid;
  String caproicAcid;
  String caprylicAcid;
  String chloride;
  String chromium;
  String copper;
  String docosahexaenoicAcid;
  String eicosapentaenoicAcid;
  String erucicAcid;
  String fluoride;
  String iodine;
  String manganese;
  String molybdenum;
  String myristicAcid;
  String oleicAcid;
  String palmiticAcid;
  String pantothenicAcid;
  String selenium;
  String stearicAcid;
  bool firebaseItem;
  bool recipe;
  bool newItem;
}
