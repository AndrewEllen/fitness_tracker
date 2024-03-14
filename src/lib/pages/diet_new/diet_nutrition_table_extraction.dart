import 'dart:io';
import 'dart:math';
import 'package:fitness_tracker/models/diet/food_item.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

import '../../OCRapiKey.dart';
import '../../constants.dart';
import '../../helpers/diet/tableScanEntryList.dart';

class NutritionTableExtraction extends StatefulWidget {
  const NutritionTableExtraction({Key? key}) : super(key: key);

  @override
  State<NutritionTableExtraction> createState() => _NutritionTableExtractionState();
}

class _NutritionTableExtractionState extends State<NutritionTableExtraction> {

  File? selectedImage;
  var extracted;

  void parseNutritionalInfo(String input) {

    String getLabel(String labelToChange) {

      if (servingSizeList.contains(labelToChange)) {
        return "servingSize";
      } else if (caloriesList.contains(labelToChange)) {
        return "calories";
      } else if (kilojoulesList.contains(labelToChange)) {
        return "kilojoules";
      } else if (proteinsList.contains(labelToChange)) {
        return "proteins";
      } else if (carbsList.contains(labelToChange)) {
        return "carbs";
      } else if (fiberList.contains(labelToChange)) {
        return "fiber";
      } else if (sugarsList.contains(labelToChange)) {
        return "sugars";
      } else if (fatsList.contains(labelToChange)) {
        return "fat";
      } else if (saturatedFatList.contains(labelToChange)) {
        return "saturatedFat";
      } else if (polyUnsaturatedFatList.contains(labelToChange)) {
        return "polyUnsaturatedFat";
      } else if (monoUnsaturatedFatList.contains(labelToChange)) {
        return "monoUnsaturatedFat";
      } else if (transFatList.contains(labelToChange)) {
        return "transFat";
      } else if (cholesterolList.contains(labelToChange)) {
        return "cholesterol";
      } else if (calciumList.contains(labelToChange)) {
        return "calcium";
      } else if (ironList.contains(labelToChange)) {
        return "iron";
      } else if (sodiumList.contains(labelToChange)) {
        return "sodium";
      } else if (zincList.contains(labelToChange)) {
        return "zinc";
      } else if (magnesiumList.contains(labelToChange)) {
        return "magnesium";
      } else if (potassiumList.contains(labelToChange)) {
        return "potassium";
      } else if (vitaminAList.contains(labelToChange)) {
        return "vitaminA";
      } else if (vitaminB1List.contains(labelToChange)) {
        return "vitaminB1";
      } else if (vitaminB2List.contains(labelToChange)) {
        return "vitaminB2";
      } else if (vitaminB3List.contains(labelToChange)) {
        return "vitaminB3";
      } else if (vitaminB6List.contains(labelToChange)) {
        return "vitaminB6";
      } else if (vitaminB9List.contains(labelToChange)) {
        return "vitaminB9";
      } else if (vitaminB12List.contains(labelToChange)) {
        return "vitaminB12";
      } else if (vitaminCList.contains(labelToChange)) {
        return "vitaminC";
      } else if (vitaminDList.contains(labelToChange)) {
        return "vitaminD";
      } else if (vitaminEList.contains(labelToChange)) {
        return "vitaminE";
      } else if (vitaminKList.contains(labelToChange)) {
        return "vitaminK";
      } else if (omega3List.contains(labelToChange)) {
        return "omega3";
      } else if (omega6List.contains(labelToChange)) {
        return "omega6";
      } else if (alcoholList.contains(labelToChange)) {
        return "alcohol";
      } else if (biotinList.contains(labelToChange)) {
        return "biotin";
      } else if (butyricAcidList.contains(labelToChange)) {
        return "butyricAcid";
      } else if (caffeineList.contains(labelToChange)) {
        return "caffeine";
      } else if (capricAcidList.contains(labelToChange)) {
        return "capricAcid";
      } else if (caproicAcidList.contains(labelToChange)) {
        return "caproicAcid";
      } else if (caprylicAcidList.contains(labelToChange)) {
        return "caprylicAcid";
      } else if (chlorideList.contains(labelToChange)) {
        return "chloride";
      } else if (chromiumList.contains(labelToChange)) {
        return "chromium";
      } else if (copperList.contains(labelToChange)) {
        return "copper";
      } else if (docosahexaenoicAcidList.contains(labelToChange)) {
        return "docosahexaenoicAcid";
      } else if (eicosapentaenoicAcidList.contains(labelToChange)) {
        return "eicosapentaenoicAcid";
      } else if (erucicAcidList.contains(labelToChange)) {
        return "erucicAcid";
      } else if (fluorideList.contains(labelToChange)) {
        return "fluoride";
      } else if (iodineList.contains(labelToChange)) {
        return "iodine";
      } else if (manganeseList.contains(labelToChange)) {
        return "manganese";
      } else if (molybdenumList.contains(labelToChange)) {
        return "molybdenum";
      } else if (myristicAcidList.contains(labelToChange)) {
        return "myristicAcid";
      } else if (oleicAcidList.contains(labelToChange)) {
        return "oleicAcid";
      } else if (palmiticAcidList.contains(labelToChange)) {
        return "palmiticAcid";
      } else if (pantothenicAcidList.contains(labelToChange)) {
        return "pantothenicAcid";
      } else if (seleniumList.contains(labelToChange)) {
        return "selenium";
      } else if (stearicAcidList.contains(labelToChange)) {
        return "stearicAcid";
      }

      return "";
    }

    String removeExcessData(String inputString) {

      List<String> splitInputString = inputString
          .toLowerCase()
          .trim()
          .split(" ");
      splitInputString.removeWhere((value) => !masterEntryList.contains(value));

      print("SPLIT LABEL");
      print(inputString);
      print(splitInputString);

      return splitInputString.join(" ").trim();

    }

    FoodItem parseNutritionInfo(String input) {
      List<String> lines = input.split('\t\r\n');
      Map<String, String> nutritionInfo = {};

      for (String line in lines) {
        List<String> parts = line.split('\t');
        if (parts.length >= 3) {
          String label = removeExcessData(parts[0]);
          String value = "0";

          for (String part in parts) {
            if (double.tryParse(part.toLowerCase().replaceAll(RegExp(r'[^0-9.,]'), '').trim()) != null) {
              value = part.toLowerCase().replaceAll(RegExp(r'[^0-9.,]'), '').trim();
              break;
            }
          }

          nutritionInfo[label] = value;
        }
      }

      print(input);
      print(nutritionInfo);

      FoodItem scannedItem = FoodItem(
        barcode: "",
        foodName: "",
        quantity: "1",
        servingSize: nutritionInfo[getLabel("servingSize")] ?? "",
        servings: "1",
        calories: nutritionInfo[getLabel("calories")] ?? "",
        kiloJoules: nutritionInfo[getLabel("kilojoules")] ?? "",
        proteins: nutritionInfo[getLabel("proteins")] ?? "",
        carbs: nutritionInfo[getLabel("carbs")] ?? "",
        fiber: nutritionInfo[getLabel("fiber")] ?? "",
        sugars: nutritionInfo[getLabel("sugars")] ?? "",
        fat: nutritionInfo[getLabel("fat")] ?? "",
        saturatedFat: nutritionInfo[getLabel("saturatedFat")] ?? "",
        polyUnsaturatedFat: nutritionInfo[getLabel("polyUnsaturatedFat")] ?? "",
        monoUnsaturatedFat: nutritionInfo[getLabel("monoUnsaturatedFat")] ?? "",
        transFat: nutritionInfo[getLabel("transFat")] ?? "",
        cholesterol: nutritionInfo[getLabel("cholesterol")] ?? "",
        calcium: nutritionInfo[getLabel("calcium")] ?? "",
        iron: nutritionInfo[getLabel("iron")] ?? "",
        sodium: nutritionInfo[getLabel("sodium")] ?? "",
        zinc: nutritionInfo[getLabel("zinc")] ?? "",
        magnesium: nutritionInfo[getLabel("magnesium")] ?? "",
        potassium: nutritionInfo[getLabel("potassium")] ?? "",
        vitaminA: nutritionInfo[getLabel("vitaminA")] ?? "",
        vitaminB1: nutritionInfo[getLabel("vitaminB1")] ?? "",
        vitaminB2: nutritionInfo[getLabel("vitaminB2")] ?? "",
        vitaminB3: nutritionInfo[getLabel("vitaminB3")] ?? "",
        vitaminB6: nutritionInfo[getLabel("vitaminB6")] ?? "",
        vitaminB9: nutritionInfo[getLabel("vitaminB9")] ?? "",
        vitaminB12: nutritionInfo[getLabel("vitaminB12")] ?? "",
        vitaminC: nutritionInfo[getLabel("vitaminC")] ?? "",
        vitaminD: nutritionInfo[getLabel("vitaminD")] ?? "",
        vitaminE: nutritionInfo[getLabel("vitaminE")] ?? "",
        vitaminK: nutritionInfo[getLabel("vitaminK")] ?? "",
        omega3: nutritionInfo[getLabel("omega3")] ?? "",
        omega6: nutritionInfo[getLabel("omega6")] ?? "",
        alcohol: nutritionInfo[getLabel("alcohol")] ?? "",
        biotin: nutritionInfo[getLabel("biotin")] ?? "",
        butyricAcid: nutritionInfo[getLabel("butyricAcid")] ?? "",
        caffeine: nutritionInfo[getLabel("caffeine")] ?? "",
        capricAcid: nutritionInfo[getLabel("capricAcid")] ?? "",
        caproicAcid: nutritionInfo[getLabel("caproicAcid")] ?? "",
        caprylicAcid: nutritionInfo[getLabel("caprylicAcid")] ?? "",
        chloride: nutritionInfo[getLabel("chloride")] ?? "",
        chromium: nutritionInfo[getLabel("chromium")] ?? "",
        copper: nutritionInfo[getLabel("copper")] ?? "",
        docosahexaenoicAcid: nutritionInfo[getLabel("docosahexaenoicAcid")] ?? "",
        eicosapentaenoicAcid: nutritionInfo[getLabel("eicosapentaenoicAcid")] ?? "",
        erucicAcid: nutritionInfo[getLabel("erucicAcid")] ?? "",
        fluoride: nutritionInfo[getLabel("fluoride")] ?? "",
        iodine: nutritionInfo[getLabel("iodine")] ?? "",
        manganese: nutritionInfo[getLabel("manganese")] ?? "",
        molybdenum: nutritionInfo[getLabel("molybdenum")] ?? "",
        myristicAcid: nutritionInfo[getLabel("myristicAcid")] ?? "",
        oleicAcid: nutritionInfo[getLabel("oleicAcid")] ?? "",
        palmiticAcid: nutritionInfo[getLabel("palmiticAcid")] ?? "",
        pantothenicAcid: nutritionInfo[getLabel("pantothenicAcid")] ?? "",
        selenium: nutritionInfo[getLabel("selenium")] ?? "",
        stearicAcid: nutritionInfo[getLabel("stearicAcid")] ?? "",
      );

      return scannedItem;

    }

    FoodItem scannedItem = parseNutritionInfo(input);

    print(scannedItem.calories);
    print(scannedItem.proteins);
    print(scannedItem.carbs);
    print(scannedItem.fat);
    print(scannedItem.sugars);
    print(scannedItem.saturatedFat);
    print(scannedItem.fiber);
    print(scannedItem.sodium);

  }


  Future<File?> cropImage(XFile image) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: "Crop Image",
          toolbarColor: appPrimaryColour,
          toolbarWidgetColor: Colors.black,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false,
          dimmedLayerColor: appPrimaryColour,
        ),
      ],
    );
    return File(croppedFile!.path);
  }


  Future<void> OCRTabularRecognition() async {

    final url = Uri.parse('https://api.ocr.space/parse/image');

    final req = http.MultipartRequest('POST', url)
      ..fields['language'] = 'eng'
      ..fields['isOverlayRequired'] = 'false'
      ..fields['isTable'] = 'true'
      ..fields['OCREngine'] = '2'
      ..fields['scale'] = 'true'
      ..fields['detectOrientation'] = 'true';

    req.files.add(
      await http.MultipartFile.fromPath(
        File(selectedImage!.path).uri.pathSegments.last,
        selectedImage!.path,
      )
    );
    req.headers['apikey'] = OCRAPIKEY;

    final stream = await req.send();
    final res = await http.Response.fromStream(stream);
    final status = res.statusCode;
    if (status != 200) throw Exception('http.send error: statusCode= $status');

    extracted = jsonDecode(res.body)["ParsedResults"][0]["ParsedText"];

    setState(() {});

    parseNutritionalInfo(extracted);

  }


  @override
  Widget build(BuildContext context) {
    return Container(

      child: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          
              selectedImage != null ? Image.file(selectedImage!) : const SizedBox.shrink(),
          
              ElevatedButton(
                onPressed: () async {
                  try {
                    final XFile? image = await ImagePicker().pickImage(
                      source: ImageSource.camera,
                      imageQuality: 40,
                    );

                    File? croppedFile = await cropImage(image!);
          
                    setState(() {
                      selectedImage = File(croppedFile!.path);
                    });

                    await OCRTabularRecognition();

                  } catch (error) {
                    debugPrint("Error Detected");
                    debugPrint(error.toString());
                  }
                },
                child: const Text("Pick From Camera"),
              ),

              ElevatedButton(
                onPressed: () {
                  parseNutritionalInfo("Nutrition\t\r\nTypical values\tper 100g\tper 1/2 pot (300g)\t%RI|\tyour RI*\t\r\n(as consumed)\t167kJ\t501kJ\t8400kJ\t\r\nEnergy\t40kcal\t119kcal\t6%\t2000kcal\t\r\nFat\t1.2g\t3.6g\t5%\t70g\t\r\nof which saturates\t0.2 g\t0.6g\t3%\t20g\t\r\nCarbohydrate\t4.2g\t12.6g\t\r\nof which sugars\t1.2g\t3,6g\t4%\t90g\t\r\nFibre\t1.1g\t3.3g\t\r\nProtein\t2.5g|\t7.5g\t\r\nSalt\t0.5g\t1.5g\t25%\t6g\t\r\n*Reference intake of an average adult (8400kJ/2000kcal) (RI). Contains 2 portions");
                },
                child: const Text("Test"),
              ),

              extracted != null ? Padding(
                padding: const EdgeInsets.all(14.0),
                child: Text(
                  extracted.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ) : const SizedBox.shrink(),

            ],
          ),
        ),
      ),

    );
  }
}
