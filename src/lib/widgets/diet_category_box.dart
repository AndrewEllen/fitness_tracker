import 'package:fitness_tracker/exports.dart';
import 'package:fitness_tracker/models/food_item.dart';
import 'package:fitness_tracker/widgets/screen_width_container.dart';
import 'package:fitness_tracker/widgets/screen_width_expanding_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/food_data_list_item.dart';
import '../pages/diet_food_display_page.dart';
import 'app_container_header.dart';
import 'app_default_button.dart';
import 'diet_category_add_bar.dart';
import 'food_list_item_box.dart';

class DietCategoryBox extends StatefulWidget {
  DietCategoryBox({Key? key, required this.bigContainerMin,
    required this.height, required this.margin, required this.width,
    required this.title, required this.foodList,
  }) : super(key: key);
  double bigContainerMin, height, margin, width;
  String title;
  List<ListFoodItem> foodList;

  @override
  State<DietCategoryBox> createState() => _DietCategoryBoxState();
}

class _DietCategoryBoxState extends State<DietCategoryBox> {
  deleteMeasurement(BuildContext context, int index, String value, double width) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: appTertiaryColour,
          title: const Text(
            "Edit Selection",
            style: TextStyle(
              color: appSecondaryColour,
            ),
          ),
          content: RichText(
            text: TextSpan(text: 'Editing: ',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
              children: <TextSpan>[
                TextSpan(text: '$value',
                  style: const TextStyle(
                    color: appSecondaryColour,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Container(
                height: 30,
                child: AppButton(
                  primaryColor: Colors.red,
                  buttonText: "Delete",
                  onTap: () {

                    context.read<UserNutritionData>().deleteFoodFromDiary(index, widget.title);

                    Navigator.pop(context);
                  },
                )
            ),
            Container(
                height: 30,
                child: AppButton(
                  buttonText: "Cancel",
                  onTap: () {
                    Navigator.pop(context);
                  },
                )
            ),
            Container(
                height: 30,
                child: AppButton(
                  primaryColor: appSecondaryColour,
                  buttonText: "Edit",
                  onTap: () {
                    context.read<UserNutritionData>().setCurrentFoodItem(widget.foodList[index].foodItemData);

                    context.read<UserNutritionData>().updateCurrentFoodItemServings(widget.foodList[index].foodServings);
                    context.read<UserNutritionData>().updateCurrentFoodItemServingSize(widget.foodList[index].foodServingSize);
                    context.read<PageChange>().changePageCache(FoodDisplayPage(category: widget.title, editDiary: true, index: index));

                    Navigator.pop(context);
                    },
                )
            ),
          ],
        );
      },
    );
  }






  @override
  Widget build(BuildContext context) {



    return ScreenWidthExpandingContainer(
      minHeight: widget.bigContainerMin/2,
      margin: widget.margin,
      child: Column(
        children: [
          Container(
            height: 40,
            child: AppHeaderBox(
              title: widget.title,
              width: widget.width,
              largeTitle: true,
            ),
          ),
          context.read<UserNutritionData>().isCurrentFoodItemLoaded ? ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.foodList.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {

              return FoodListDisplayBox(
                key: UniqueKey(),
                width: widget.width,
                foodObject: widget.foodList[index],
                icon: MdiIcons.squareEditOutline,
                iconColour: Colors.white,
                onTapIcon: () => deleteMeasurement(
                  this.context,
                  index,
                  widget.foodList[index].foodItemData.foodName,
                  widget.width,
                ),
              );
              },
          ) : const SizedBox.shrink(),
          Stack(
            children: [
              DietCategoryAddBar(
                width: widget.width,
                category: widget.title,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
