import 'dart:io';
import 'dart:math';
import 'package:fitness_tracker/exports.dart';
import 'package:fitness_tracker/models/diet/food_item.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
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

    String getCorrectLabelName(String inputLabel) {

      String labelToChange = inputLabel.toLowerCase();

      print("labelToChange");
      print(labelToChange);

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


      print("SPLIT LABEL");
      print(inputString);
      print(splitInputString);

      splitInputString.removeWhere((value) => !masterEntryList.contains(value));

      print(splitInputString);

      return splitInputString.join(" ").trim();

    }

    FoodItem parseNutritionInfo(String input) {
      List<String> lines = input.split('\t\r\n');
      Map<String, String> nutritionInfo = {};

      for (String line in lines) {
        List<String> parts = line.split('\t');
        if (parts.length >= 1) {
          String label = getCorrectLabelName(removeExcessData(parts[0]));
          String value = "0";

          for (String part in parts) {
            print(part);
            if (double.tryParse(part.toLowerCase().replaceAll(RegExp(r'[^0-9.,]'), '').trim()) != null) {
              value = part.toLowerCase().replaceAll(RegExp(r'[^0-9.,]'), '').trim();
              break;
            }
          }

          if (label.toLowerCase() == "sodium") {
            value = "${(double.parse(value)*2.5)/1000}";
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
        servingSize: nutritionInfo["servingSize"] ?? "",
        servings: "1",
        calories: nutritionInfo["calories"] ?? "",
        kiloJoules: nutritionInfo["kilojoules"] ?? "",
        proteins: nutritionInfo["proteins"] ?? "",
        carbs: nutritionInfo["carbs"] ?? "",
        fiber: nutritionInfo["fiber"] ?? "",
        sugars: nutritionInfo["sugars"] ?? "",
        fat: nutritionInfo["fat"] ?? "",
        saturatedFat: nutritionInfo["saturatedFat"] ?? "",
        polyUnsaturatedFat: nutritionInfo["polyUnsaturatedFat"] ?? "",
        monoUnsaturatedFat: nutritionInfo["monoUnsaturatedFat"] ?? "",
        transFat: nutritionInfo["transFat"] ?? "",
        cholesterol: nutritionInfo["cholesterol"] ?? "",
        calcium: nutritionInfo["calcium"] ?? "",
        iron: nutritionInfo["iron"] ?? "",
        sodium: nutritionInfo["sodium"] ?? "",
        zinc: nutritionInfo["zinc"] ?? "",
        magnesium: nutritionInfo["magnesium"] ?? "",
        potassium: nutritionInfo["potassium"] ?? "",
        vitaminA: nutritionInfo["vitaminA"] ?? "",
        vitaminB1: nutritionInfo["vitaminB1"] ?? "",
        vitaminB2: nutritionInfo["vitaminB2"] ?? "",
        vitaminB3: nutritionInfo["vitaminB3"] ?? "",
        vitaminB6: nutritionInfo["vitaminB6"] ?? "",
        vitaminB9: nutritionInfo["vitaminB9"] ?? "",
        vitaminB12: nutritionInfo["vitaminB12"] ?? "",
        vitaminC: nutritionInfo["vitaminC"] ?? "",
        vitaminD: nutritionInfo["vitaminD"] ?? "",
        vitaminE: nutritionInfo["vitaminE"] ?? "",
        vitaminK: nutritionInfo["vitaminK"] ?? "",
        omega3: nutritionInfo["omega3"] ?? "",
        omega6: nutritionInfo["omega6"] ?? "",
        alcohol: nutritionInfo["alcohol"] ?? "",
        biotin: nutritionInfo["biotin"] ?? "",
        butyricAcid: nutritionInfo["butyricAcid"] ?? "",
        caffeine: nutritionInfo["caffeine"] ?? "",
        capricAcid: nutritionInfo["capricAcid"] ?? "",
        caproicAcid: nutritionInfo["caproicAcid"] ?? "",
        caprylicAcid: nutritionInfo["caprylicAcid"] ?? "",
        chloride: nutritionInfo["chloride"] ?? "",
        chromium: nutritionInfo["chromium"] ?? "",
        copper: nutritionInfo["copper"] ?? "",
        docosahexaenoicAcid: nutritionInfo["docosahexaenoicAcid"] ?? "",
        eicosapentaenoicAcid: nutritionInfo["eicosapentaenoicAcid"] ?? "",
        erucicAcid: nutritionInfo["erucicAcid"] ?? "",
        fluoride: nutritionInfo["fluoride"] ?? "",
        iodine: nutritionInfo["iodine"] ?? "",
        manganese: nutritionInfo["manganese"] ?? "",
        molybdenum: nutritionInfo["molybdenum"] ?? "",
        myristicAcid: nutritionInfo["myristicAcid"] ?? "",
        oleicAcid: nutritionInfo["oleicAcid"] ?? "",
        palmiticAcid: nutritionInfo["palmiticAcid"] ?? "",
        pantothenicAcid: nutritionInfo["pantothenicAcid"] ?? "",
        selenium: nutritionInfo["selenium"] ?? "",
        stearicAcid: nutritionInfo["stearicAcid"] ?? "",
      );

      return scannedItem;

    }

    FoodItem scannedItem = parseNutritionInfo(input);

    context.read<UserNutritionData>().updateScannedFoodItem(scannedItem);
    context.read<PageChange>().backPage();

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


  void takePicture() async {
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
      context.read<PageChange>().backPage();
    }
  }

  @override
  void initState() {
    takePicture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            selectedImage == null ? "Scan Nutrition Table" : "Processing Table Data",
            style: boldTextStyle,
          ),
          const SizedBox(height: 20,),
          const CircularProgressIndicator(
            color: appSecondaryColour,
          ),
        ],
      )
    );
  }
}
