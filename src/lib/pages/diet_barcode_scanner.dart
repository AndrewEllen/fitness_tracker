import 'dart:typed_data';

import 'package:fitness_tracker/constants.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:provider/provider.dart';

import '../helpers/analyse_barcode.dart';
import '../helpers/nutrition_tracker.dart';
import '../models/food_item.dart';
import '../providers/database_get.dart';
import '../providers/page_change_provider.dart';
import '../providers/user_nutrition_data.dart';
import 'diet_food_display_page.dart';

class BarcodeScannerPage extends StatefulWidget {
  BarcodeScannerPage({Key? key, required this.category}) : super(key: key);
  String category;

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {

  bool _isScanned = false;

  MobileScannerController scannerController = MobileScannerController(
    torchEnabled: false,
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
  );

  @override
  void initState() {
    scannerController.stop();
    scannerController.autoStart;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //[LO3.7.3.5]
    return Scaffold(
      backgroundColor: appPrimaryColour,
      floatingActionButton: IconButton(
        color: Colors.white,
        icon: ValueListenableBuilder(
          valueListenable: scannerController.torchState,
          builder: (context, state, child) {
            switch (state as TorchState) {
              case TorchState.off:
                return const Icon(Icons.flash_off, color: Colors.grey);
              case TorchState.on:
                return const Icon(Icons.flash_on, color: appSecondaryColour);
            }
          },
        ),
        iconSize: 32.0,
        onPressed: () => scannerController.toggleTorch(),
      ),
      appBar: AppBar(
        elevation: 2,
        toolbarHeight: 50,
        shadowColor: Colors.black,
        backgroundColor: appTertiaryColour,
        title: const Center(
            child: Text(
              'Barcode Scanner',
              style: TextStyle(
                color: appSecondaryColour,
              ),
            )),
      ),
      body: MobileScanner(
        key: UniqueKey(),
        errorBuilder: (context, error, child) {
          scannerController.stop();
          scannerController.start();
          print("Scanner Error");
          return CircularProgressIndicator();
        },
        controller: scannerController,
        onDetect: (capture) async {
          final List<Barcode> barcodes = capture.barcodes;

            debugPrint('Barcode found! ${barcodes[0].displayValue}');
            try {
              analyseBarcode(capture.image);
            }
            catch (error) {
              print(error);
            }

            String? barcodeDisplayValue = barcodes[0].displayValue;

              //Commented out to avoid spam on the API calls.
            if (barcodeDisplayValue != null && !_isScanned) {

              FoodItem newFoodItem = await CheckFoodBarcode(barcodeDisplayValue);
              context.read<UserNutritionData>().setCurrentFoodItem(newFoodItem);

              _isScanned = true;
              print(context.read<UserNutritionData>().currentFoodItem.foodName);

            }

            scannerController.stop();
            context.read<PageChange>().changePageRemovePreviousCache(FoodDisplayPage(category: widget.category));

          }
      ),
    );
  }
}
