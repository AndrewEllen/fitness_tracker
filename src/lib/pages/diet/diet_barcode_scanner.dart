
import 'package:fitness_tracker/constants.dart';
import 'package:fitness_tracker/pages/groceries/groceries_home.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../../helpers/diet/nutrition_tracker.dart';
import '../../models/diet/food_item.dart';
import '../../providers/general/page_change_provider.dart';
import '../../providers/diet/user_nutrition_data.dart';
import 'diet_food_display_page.dart';
import 'diet_new_food_page.dart';

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({Key? key, required this.category, this.recipe = false}) : super(key: key);
  final String category;
  final bool recipe;

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

  Widget _buildBarcodeOverlay() {
    return ValueListenableBuilder(
      valueListenable: scannerController,
      builder: (context, value, child) {
        // Not ready.
        if (!value.isInitialized || !value.isRunning || value.error != null) {
          return const SizedBox();
        }

        return StreamBuilder<BarcodeCapture>(
          stream: scannerController.barcodes,
          builder: (context, snapshot) {
            final BarcodeCapture? barcodeCapture = snapshot.data;

            // No barcode.
            if (barcodeCapture == null || barcodeCapture.barcodes.isEmpty) {
              return const SizedBox();
            }

            final scannedBarcode = barcodeCapture.barcodes.first;

            // No barcode corners, or size, or no camera preview size.
            if (scannedBarcode.corners.isEmpty ||
                value.size.isEmpty ||
                barcodeCapture.size.isEmpty) {
              return const SizedBox();
            }

            return CustomPaint(
              painter: BarcodeOverlay(
                barcodeCorners: scannedBarcode.corners,
                barcodeSize: barcodeCapture.size,
                boxFit: BoxFit.contain,
                cameraPreviewSize: value.size,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildScanWindow(Rect scanWindowRect) {
    return ValueListenableBuilder(
      valueListenable: scannerController,
      builder: (context, value, child) {
        // Not ready.
        if (!value.isInitialized ||
            !value.isRunning ||
            value.error != null ||
            value.size.isEmpty) {
          return const SizedBox();
        }

        return CustomPaint(
          painter: ScannerOverlay(scanWindowRect),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final scanWindow = Rect.fromCenter(
      center: MediaQuery.sizeOf(context).center(Offset(0, -100.h)),
      width: 300.w,
      height: 300.h,
    );

    //[LO3.7.3.5]
    return Scaffold(
      backgroundColor: appPrimaryColour,
      floatingActionButton: Row(
        children: [
          const Spacer(flex: 4),
          Padding(
            padding: EdgeInsets.only(bottom: 16.h, right: 22.0.w),
            child: IconButton(
              color: Colors.white,
              icon: const Icon(
                MdiIcons.scanHelper,
                size: 48,
              ),
                onPressed: () async {

                  BarcodeCapture barcodes = await scannerController.barcodes.first;
                  String? barcodeValue = barcodes.barcodes.first.displayValue;

                  debugPrint(barcodeValue);

                  if (barcodeValue != null && !_isScanned) {

                    FoodItem newFoodItem = await CheckFoodBarcode(barcodeValue!);

                    debugPrint(newFoodItem.barcode);
                    debugPrint(newFoodItem.foodName);

                    if (widget.category == "groceries") {
                      context.read<PageChange>().changePageRemovePreviousCache(GroceriesHome(
                        foodName: newFoodItem.foodName,
                        foodBarcode: newFoodItem.barcode,
                        dropdown: true,
                      ));
                    } else {

                      context.read<UserNutritionData>().setCurrentFoodItem(newFoodItem);

                      _isScanned = true;

                      if (newFoodItem.newItem) {
                        scannerController.stop();

                        context.read<PageChange>().changePageRemovePreviousCache(FoodNewNutritionEdit(category: widget.category, fromBarcode: true, recipe: widget.recipe, saveAsCustom: false,));
                      } else {
                        scannerController.stop();

                        context.read<PageChange>().changePageRemovePreviousCache(FoodDisplayPage(category: widget.category, recipe: widget.recipe,));
                      }

                    }
                  }
                }
            ),
          ),
          const Spacer(flex: 2),
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: scannerController,
              builder: (context, state, child) {
                switch (state.torchState) {
                  case TorchState.auto:
                    return IconButton(
                      color: Colors.white,
                      iconSize: 32.0,
                      icon: const Icon(Icons.flash_auto),
                      onPressed: () async {
                        await scannerController.toggleTorch();
                      },
                    );
                  case TorchState.off:
                    return IconButton(
                      color: Colors.white,
                      iconSize: 32.0,
                      icon: const Icon(Icons.flash_off),
                      onPressed: () async {
                        await scannerController.toggleTorch();
                      },
                    );
                  case TorchState.on:
                    return IconButton(
                      color: Colors.white,
                      iconSize: 32.0,
                      icon: const Icon(Icons.flash_on),
                      onPressed: () async {
                        await scannerController.toggleTorch();
                      },
                    );
                  case TorchState.unavailable:
                    return const Icon(
                      Icons.no_flash,
                      color: Colors.grey,
                    );
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => scannerController.toggleTorch(),
          ),
        ],
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
              scanWindow: scanWindow,
            key: UniqueKey(),
            errorBuilder: (context, error, child) {
              scannerController.stop();
              scannerController.start();
              debugPrint("Scanner Error");
              return const CircularProgressIndicator();
            },
            controller: scannerController,

          ),
          _buildBarcodeOverlay(),
          _buildScanWindow(scanWindow),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              height: 200,
              //color: Colors.black.withOpacity(0.4),
              child: ScannedBarcodeLabel(barcodes: scannerController.barcodes),
            ),
          ),
        ],
      ),
    );
  }
}

class ScannerOverlay extends CustomPainter {
  ScannerOverlay(this.scanWindow);

  final Rect scanWindow;

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: use `Offset.zero & size` instead of Rect.largest
    // we need to pass the size to the custom paint widget
    final backgroundPath = Path()..addRect(Rect.largest);
    final cutoutPath = Path()..addRect(scanWindow);

    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );
    canvas.drawPath(backgroundWithCutout, backgroundPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class BarcodeOverlay extends CustomPainter {
  BarcodeOverlay({
    required this.barcodeCorners,
    required this.barcodeSize,
    required this.boxFit,
    required this.cameraPreviewSize,
  });

  final List<Offset> barcodeCorners;
  final Size barcodeSize;
  final BoxFit boxFit;
  final Size cameraPreviewSize;

  @override
  void paint(Canvas canvas, Size size) {
    if (barcodeCorners.isEmpty ||
        barcodeSize.isEmpty ||
        cameraPreviewSize.isEmpty) {
      return;
    }

    final adjustedSize = applyBoxFit(boxFit, cameraPreviewSize, size);

    double verticalPadding = size.height - adjustedSize.destination.height;
    double horizontalPadding = size.width - adjustedSize.destination.width;
    if (verticalPadding > 0) {
      verticalPadding = verticalPadding / 2;
    } else {
      verticalPadding = 0;
    }

    if (horizontalPadding > 0) {
      horizontalPadding = horizontalPadding / 2;
    } else {
      horizontalPadding = 0;
    }

    final double ratioWidth;
    final double ratioHeight;

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
      ratioWidth = barcodeSize.width / adjustedSize.destination.width  / 2;
      ratioHeight = barcodeSize.height / adjustedSize.destination.height  / 2;
    } else {
      ratioWidth = cameraPreviewSize.width / adjustedSize.destination.width / 2;
      ratioHeight = cameraPreviewSize.height / adjustedSize.destination.height / 2;
    }

    final List<Offset> adjustedOffset = [
      for (final offset in barcodeCorners)
        Offset(
          offset.dx / ratioWidth + horizontalPadding,
          offset.dy / ratioHeight + verticalPadding,
        ),
    ];

    final cutoutPath = Path()..addPolygon(adjustedOffset, true);

    final backgroundPaint = Paint()
      ..color = Colors.red.withOpacity(0.3)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    canvas.drawPath(cutoutPath, backgroundPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class ScannedBarcodeLabel extends StatelessWidget {
  const ScannedBarcodeLabel({
    super.key,
    required this.barcodes,
  });

  final Stream<BarcodeCapture> barcodes;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: barcodes,
      builder: (context, snapshot) {
        final scannedBarcodes = snapshot.data?.barcodes ?? [];

        if (scannedBarcodes.isEmpty) {
          return const Text(
            'Scan A Barcode',
            overflow: TextOverflow.fade,
            style: TextStyle(color: Colors.white),
          );
        }

        return Text(
          scannedBarcodes.first.displayValue ?? 'No display value.',
          overflow: TextOverflow.fade,
          style: const TextStyle(color: Colors.white),
        );
      },
    );
  }
}