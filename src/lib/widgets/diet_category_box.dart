import 'package:fitness_tracker/exports.dart';
import 'package:fitness_tracker/widgets/screen_width_container.dart';
import 'package:fitness_tracker/widgets/screen_width_expanding_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/food_data_list_item.dart';
import 'app_container_header.dart';
import 'diet_category_add_bar.dart';
import 'food_list_item_box.dart';

class DietCategoryBox extends StatelessWidget {
  DietCategoryBox({Key? key, required this.bigContainerMin,
    required this.height, required this.margin, required this.width,
    required this.title, required this.foodList,
  }) : super(key: key);
  double bigContainerMin, height, margin, width;
  String title;
  List<ListFoodItem> foodList;


  @override
  Widget build(BuildContext context) {
    return ScreenWidthExpandingContainer(
      minHeight: bigContainerMin/2,
      margin: margin,
      child: Column(
        children: [
          Container(
            height: 40,
            child: AppHeaderBox(
              title: title,
              width: width,
              largeTitle: true,
            ),
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: foodList.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return FoodListDisplayBox(
                width: width,
                foodObject: foodList[index],
                icon: Icons.delete,
                iconColour: Colors.red,
                onTapIcon: () => context.read<UserNutritionData>().deleteFoodFromDiary(index, title),
              );
              },
          ),
          Stack(
            children: [
              DietCategoryAddBar(
                width: width,
                category: title,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
