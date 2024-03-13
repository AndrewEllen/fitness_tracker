import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import '../../OCRapiKey.dart';


class NutritionTableExtraction extends StatefulWidget {
  const NutritionTableExtraction({Key? key}) : super(key: key);

  @override
  State<NutritionTableExtraction> createState() => _NutritionTableExtractionState();
}

class _NutritionTableExtractionState extends State<NutritionTableExtraction> {

  File? selectedImage;
  RecognizedText? recognizedText;

  var extracted;

  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  Future<void> recogniseText() async {

    recognizedText = await textRecognizer.processImage(
        InputImage.fromFile(
          selectedImage!,
        )
    );

    for (TextBlock block in recognizedText!.blocks) {
      final Rect rect = block.boundingBox;
      final List<Point<int>> cornerPoints = block.cornerPoints;
      final String text = block.text;
      final List<String> languages = block.recognizedLanguages;

      print("Printing Block Text");
      print(text);

      for (TextLine line in block.lines) {
        print("Printing Text Line");
        print(line.text);
        for (TextElement element in line.elements) {
          print("Printing Text Element");
          print(element.text);
        }
      }

    }
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
                      imageQuality: 100,
                    );

                    //CroppedFile? croppedFile = await cropImage(image!);
          
                    setState(() {
                      selectedImage = File(image!.path);
                    });

                    await recogniseText();
                    await OCRTabularRecognition();

                  } catch (error) {
                    debugPrint("Error Detected");
                    debugPrint(error.toString());
                  }
                },
                child: const Text("Pick From Camera"),
              ),

              recognizedText != null ? ListView.builder(
                shrinkWrap: true,
                itemCount: recognizedText!.blocks.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text(
                      recognizedText!.blocks[index].text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  );

                },
              ) : const SizedBox.shrink(),

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
