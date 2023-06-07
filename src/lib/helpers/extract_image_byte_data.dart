import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

Future<File> getImageFileFromAssets(String path) async {
  //[LO3.7.3.5]
  //Code used from help forum
  //Turns the image asset into byte data
  
  final byteData = await rootBundle.load(path);

  final file = File("${(await getTemporaryDirectory()).path}/$path");
  await file.create(recursive: true);
  await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

  return file;
}