import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

import '../../OCRapiKey.dart';
import '../../constants.dart';

class NutritionTableExtraction extends StatefulWidget {
  const NutritionTableExtraction({Key? key}) : super(key: key);

  @override
  State<NutritionTableExtraction> createState() => _NutritionTableExtractionState();
}

class _NutritionTableExtractionState extends State<NutritionTableExtraction> {

  File? selectedImage;
  var extracted;


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


    print("OCR CURL REQUEST BELOW");
    print(res.body);

    extracted = jsonDecode(res.body);

    setState(() {});

    print(jsonDecode(res.body));

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
