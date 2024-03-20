/*import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';


///TODO Remove this later

Future<String?> analyseBarcode(imageFile) async {
  //[LO3.7.3.5]
  //Code used from pub.dev package page
  //Reads the barcode value using googleMLKit

  final inputImage = InputImage.fromFile(imageFile);

  final List<BarcodeFormat> barcodeFormats = [BarcodeFormat.all];
  final barcodeScanner = BarcodeScanner(formats: barcodeFormats);

  final List<Barcode> barcodeList = await barcodeScanner.processImage(inputImage);

  final String? barcodeDisplayValue = barcodeList[0].displayValue;
  print(barcodeDisplayValue);

  return barcodeDisplayValue;
}*/