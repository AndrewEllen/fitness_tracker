import 'package:fitness_tracker/exports.dart';
import 'package:fitness_tracker/widgets/general/screen_width_expanding_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/diet/food_data_list_item.dart';
import '../../pages/diet/diet_food_display_page.dart';
import '../general/app_container_header.dart';
import '../general/app_default_button.dart';
import 'diet_category_add_bar.dart';
import 'food_list_item_box.dart';

class DietCategoryBox extends StatefulWidget {
  const DietCategoryBox({Key? key, required this.bigContainerMin,
    required this.height, required this.margin, required this.width,
    required this.title, required this.foodList,
  }) : super(key: key);
  final double bigContainerMin, height, margin, width;
  final String title;
  final List<ListFoodItem> foodList;

  @override
  State<DietCategoryBox> createState() => _DietCategoryBoxState();
}

class _DietCategoryBoxState extends State<DietCategoryBox> {
  editEntry(BuildContext context, int index, String value, double width) {

    double buttonSize = width/17;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(0),
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
                TextSpan(text: value,
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                const Spacer(),
                SizedBox(
                    height: buttonSize,
                    child: AppButton(
                      primaryColor: Colors.red,
                      buttonText: "Delete",
                      onTap: () {

                        context.read<UserNutritionData>().deleteFoodFromDiary(index, widget.title);

                        Navigator.pop(context);
                      },
                    )
                ),
                const Spacer(),
                SizedBox(
                    height: buttonSize,
                    child: AppButton(
                      buttonText: "Cancel",
                      onTap: () {
                        Navigator.pop(context);
                      },
                    )
                ),
                const Spacer(),
                SizedBox(
                    height: buttonSize,
                    child: AppButton(
                      primaryColor: appSecondaryColour,
                      buttonText: "Edit",
                      onTap: () {
                        context.read<UserNutritionData>().setCurrentFoodItem(widget.foodList[index].foodItemData);

                        context.read<UserNutritionData>().updateCurrentFoodItemServings(widget.foodList[index].foodServings);
                        context.read<UserNutritionData>().updateCurrentFoodItemServingSize(widget.foodList[index].foodServingSize);
                        print(widget.foodList[index].foodItemData.recipe);
                        context.read<PageChange>().changePageCache(FoodDisplayPage(category: widget.title, editDiary: true, index: index, recipeEdit: widget.foodList[index].foodItemData.recipe ?? false,));

                        Navigator.pop(context);
                      },
                    )
                ),
                const Spacer(),
              ],
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
          SizedBox(
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
                onTapIcon: () => editEntry(
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
