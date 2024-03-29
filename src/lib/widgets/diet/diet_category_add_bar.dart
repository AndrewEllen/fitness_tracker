import 'package:fitness_tracker/widgets/general/app_default_button.dart';
import 'package:flutter/material.dart';
import 'package:fitness_tracker/constants.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../pages/diet/diet_barcode_scanner.dart';
import '../../pages/diet/diet_food_search_page.dart';
import '../../providers/general/page_change_provider.dart';

class DietCategoryAddBar extends StatelessWidget {
  const DietCategoryAddBar({Key? key, required this.width, required this.category
  }) : super(key: key);
  final double width;
  final String category;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(width: 0, color: appPrimaryColour),
        ),
      ),
      width: width,
      height: 40,
      child: Stack(
        children: [
          Center(
            child: SizedBox(
              width: width/3.5,
              height: 20,
              child: AppButton(
                buttonText: "Add Food",
                fontSize: 18,
                onTap: () => context.read<PageChange>().changePageCache(FoodSearchPage(category: category)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(),
            child: Align(
              alignment: Alignment.centerRight,
              child: Material(
                type: MaterialType.transparency,
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: IconButton(
                  icon: const Icon(
                      MdiIcons.barcodeScan,
                  ),
                  onPressed: () => context.read<PageChange>().changePageCache(BarcodeScannerPage(category: category)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
