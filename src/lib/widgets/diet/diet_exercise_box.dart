import 'package:fitness_tracker/exports.dart';
import 'package:fitness_tracker/widgets/general/screen_width_expanding_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/diet/exercise_calories_list_item.dart';
import '../../pages/diet/diet_food_display_page.dart';
import '../general/app_container_header.dart';
import '../general/app_default_button.dart';
import 'diet_category_add_bar.dart';
import 'diet_category_add_bar_exercise.dart';
import 'exercise_list_item_box.dart';
import 'food_list_item_box.dart';

class DietExerciseBox extends StatefulWidget {
  const DietExerciseBox({Key? key, required this.bigContainerMin,
    required this.height, required this.margin, required this.width,
    required this.title, required this.exerciseList,
  }) : super(key: key);
  final double bigContainerMin, height, margin, width;
  final String title;
  final List<ListExerciseItem> exerciseList;

  @override
  State<DietExerciseBox> createState() => _DietExerciseBoxState();
}

class _DietExerciseBoxState extends State<DietExerciseBox> {

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
            itemCount: widget.exerciseList.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {

              return ExerciseListDisplayBox(
                key: UniqueKey(),
                width: widget.width,
                exerciseList: widget.exerciseList[index],
                icon: MdiIcons.trashCan,
                iconColour: Colors.red,
                onTapIcon: () {
                  context.read<UserNutritionData>().deleteExerciseItemFromDiary(index, widget.title);
                },
              );
              },
          ) : const SizedBox.shrink(),
          Stack(
            children: [
              DietCategoryAddBarExercise(
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
