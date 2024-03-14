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

    String extractUsefulDataUsingReferenceList(String labelToChange) {

      if (servingSizeList.contains(labelToChange)) {
        return "servingSize";
      } else if (caloriesList.contains(labelToChange)) {
        return "calories";
      } else if (kilojoulesList.contains(labelToChange)) {
        return "kilojoules";
      } else if (proteinsList.contains(labelToChange)) {
        return "proteins";
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
          servingSize: nutritionInfo["Serving Size"] ?? "",
          servings: "1",
          calories: nutritionInfo["Energy"] ?? "",
          kiloJoules: nutritionInfo["kJ"] ?? "",
          proteins: nutritionInfo["Protein"] ?? "",
          carbs: nutritionInfo["Carbohydrate"] ?? "",
          fiber: nutritionInfo["Fibre"] ?? "",
          sugars: nutritionInfo["of which sugars"] ?? "",
          fat: nutritionInfo["Fat"] ?? "",
          saturatedFat: nutritionInfo["of which saturates"] ?? "",
          polyUnsaturatedFat: nutritionInfo["Polyunsaturated Fat"] ?? "",
          monoUnsaturatedFat: nutritionInfo["Monounsaturated Fat"] ?? "",
          transFat: nutritionInfo["Trans Fat"] ?? "",
          cholesterol: nutritionInfo["Cholesterol"] ?? "",
          calcium: nutritionInfo["Calcium"] ?? "",
          iron: nutritionInfo["Iron"] ?? "",
          sodium: nutritionInfo["Salt"] ?? "",
          zinc: nutritionInfo["Zinc"] ?? "",
          magnesium: nutritionInfo["Magnesium"] ?? "",
          potassium: nutritionInfo["Potassium"] ?? "",
          vitaminA: nutritionInfo["Vitamin A"] ?? "",
          vitaminB1: nutritionInfo["Vitamin B1"] ?? "",
          vitaminB2: nutritionInfo["Vitamin B2"] ?? "",
          vitaminB3: nutritionInfo["Vitamin B3"] ?? "",
          vitaminB6: nutritionInfo["Vitamin B6"] ?? "",
          vitaminB9: nutritionInfo["Vitamin B9"] ?? "",
          vitaminB12: nutritionInfo["Vitamin B12"] ?? "",
          vitaminC: nutritionInfo["Vitamin C"] ?? "",
          vitaminD: nutritionInfo["Vitamin D"] ?? "",
          vitaminE: nutritionInfo["Vitamin E"] ?? "",
          vitaminK: nutritionInfo["Vitamin K"] ?? "",
          omega3: nutritionInfo["Omega-3"] ?? "",
          omega6: nutritionInfo["Omega-6"] ?? "",
          alcohol: nutritionInfo["Alcohol"] ?? "",
          biotin: nutritionInfo["Biotin"] ?? "",
          butyricAcid: nutritionInfo["Butyric Acid"] ?? "",
          caffeine: nutritionInfo["Caffeine"] ?? "",
          capricAcid: nutritionInfo["Capric Acid"] ?? "",
          caproicAcid: nutritionInfo["Caproic Acid"] ?? "",
          caprylicAcid: nutritionInfo["Caprylic Acid"] ?? "",
          chloride: nutritionInfo["Chloride"] ?? "",
          chromium: nutritionInfo["Chromium"] ?? "",
          copper: nutritionInfo["Copper"] ?? "",
          docosahexaenoicAcid: nutritionInfo["Docosahexaenoic Acid"] ?? "",
          eicosapentaenoicAcid: nutritionInfo["Eicosapentaenoic Acid"] ?? "",
          erucicAcid: nutritionInfo["Erucic Acid"] ?? "",
          fluoride: nutritionInfo["Fluoride"] ?? "",
          iodine: nutritionInfo["Iodine"] ?? "",
          manganese: nutritionInfo["Manganese"] ?? "",
          molybdenum: nutritionInfo["Molybdenum"] ?? "",
          myristicAcid: nutritionInfo["Myristic Acid"] ?? "",
          oleicAcid: nutritionInfo["Oleic Acid"] ?? "",
          palmiticAcid: nutritionInfo["Palmitic Acid"] ?? "",
          pantothenicAcid: nutritionInfo["Pantothenic Acid"] ?? "",
          selenium: nutritionInfo["Selenium"] ?? "",
          stearicAcid: nutritionInfo["Stearic Acid"] ?? "",
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
