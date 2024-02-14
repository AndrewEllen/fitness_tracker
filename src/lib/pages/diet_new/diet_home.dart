import 'package:fitness_tracker/pages/groceries/groceries_home.dart';
import 'package:fitness_tracker/widgets/general/screen_width_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../models/diet/user_nutrition_model.dart';
import '../../providers/diet/user_nutrition_data.dart';
import '../../providers/general/database_get.dart';
import '../../providers/general/page_change_provider.dart';
import '../../widgets/diet_new/diet_home_daily_nutrition_display.dart';
import '../../widgets/diet_new/diet_home_exercise_display.dart';
import '../../widgets/diet_new/diet_home_food_display.dart';
import '../../widgets/diet_new/diet_water_box.dart';

class DietHomePage extends StatefulWidget {
  DietHomePage({Key? key}) : super(key: key);

  @override
  State<DietHomePage> createState() => _DietHomePageState();
}

class _DietHomePageState extends State<DietHomePage> {

  void loadNewData() async {

    UserNutritionModel userNutritionData;
    String date = context.read<UserNutritionData>().nutritionDate.toString();

    if (
    context.read<UserNutritionData>().userDailyNutritionCache.any((element) => element.date.toString() == date)
    ) {

      print("Found");

      print(date);
      print(context.read<UserNutritionData>()
          .userDailyNutritionCache[
      context.read<UserNutritionData>().userDailyNutritionCache
          .indexWhere((element) => element.date == date)].date);

      userNutritionData = context.read<UserNutritionData>()
          .userDailyNutritionCache[
      context.read<UserNutritionData>().userDailyNutritionCache
          .indexWhere((element) => element.date == date)
      ];

    } else {

      print("Not Found");

      userNutritionData = await GetUserNutritionData(
          date
      );

      context.read<UserNutritionData>()
          .addToNutritionDataCache(userNutritionData);

    }

    context.read<UserNutritionData>().setCurrentFoodDiary(
        userNutritionData
    );
  }

  Widget child = DietPageWidget();

  DismissDirection defaultDirection = DismissDirection.startToEnd;

  void _onHorizontalSwipe(DismissDirection direction) {
    defaultDirection = direction;
    if (direction == DismissDirection.startToEnd) {
      context
          .read<UserNutritionData>()
          .updateNutritionDateArrows(true);
      loadNewData();
      setState(() {
        child = DietPageWidget();
      });
    } else {
      context
          .read<UserNutritionData>()
          .updateNutritionDateArrows(false);
      loadNewData();
      setState(() {
        child = DietPageWidget();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails direction) {
        if (direction.primaryVelocity! > 0) {
          context
              .read<UserNutritionData>()
              .updateNutritionDateArrows(true);
          loadNewData();
        } else {
          context
              .read<UserNutritionData>()
              .updateNutritionDateArrows(false);
          loadNewData();
        }
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        transitionBuilder: (child, animation) {
          if (defaultDirection == DismissDirection.startToEnd) {

            return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(
                      -0.8, 0.0), // adjust the position as you need
                  end: const Offset(0.0, 0.0),
                ).animate(animation),
                child: child);
          } else {
            return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(
                      0.8, 0.0), // adjust the position as you need
                  end: const Offset(0.0, 0.0),
                ).animate(animation),
                child: child);
          }
        },
        layoutBuilder: (currentChild, _) => currentChild ?? DietPageWidget(),
        child: Dismissible(
          key: UniqueKey(),
          resizeDuration: null,
          onDismissed: _onHorizontalSwipe,
          direction: DismissDirection.horizontal,
          child: child,
        ),
      ),


    );
  }
}

class DietPageWidget extends StatelessWidget {
  const DietPageWidget({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    double _margin = 15;
    double _smallContainerMin = 95;
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appPrimaryColour,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
        child: SingleChildScrollView(
          //physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(0.0),
                child: Center(
                  child: DailyNutritionDisplay(),
                ),
              ),

              DietHomeFoodDisplay(
                bigContainerMin: _smallContainerMin,
                height: _height,
                margin: _margin,
                width: _width,
                title: "Breakfast",
                foodList: context.watch<UserNutritionData>().foodListItemsBreakfast,
                caloriesTotal: context.read<UserNutritionData>().breakfastCalories,
              ),

              DietHomeFoodDisplay(
                bigContainerMin: _smallContainerMin,
                height: _height,
                margin: _margin,
                width: _width,
                title: "Lunch",
                foodList: context.watch<UserNutritionData>().foodListItemsLunch,
                caloriesTotal: context.read<UserNutritionData>().lunchCalories,
              ),

              DietHomeFoodDisplay(
                bigContainerMin: _smallContainerMin,
                height: _height,
                margin: _margin,
                width: _width,
                title: "Dinner",
                foodList: context.watch<UserNutritionData>().foodListItemsDinner,
                caloriesTotal: context.read<UserNutritionData>().dinnerCalories,
              ),

              DietHomeFoodDisplay(
                bigContainerMin: _smallContainerMin,
                height: _height,
                margin: _margin,
                width: _width,
                title: "Snacks",
                foodList: context.watch<UserNutritionData>().foodListItemsSnacks,
                caloriesTotal: context.read<UserNutritionData>().snacksCalories,
              ),

              DietHomeExerciseDisplay(
                bigContainerMin: _smallContainerMin,
                height: _height,
                margin: _margin,
                width: _width,
                title: "Exercise",
                exerciseList: context.watch<UserNutritionData>().foodListItemsExercise,
                caloriesTotal: context.read<UserNutritionData>().exerciseCalories,
              ),

              DietWaterDisplay(
                bigContainerMin: _smallContainerMin,
                height: _height,
                margin: _margin,
                width: _width,
                title: "Water",

              ),

              ScreenWidthButton(
                label: "Groceries List",
                onTap: () => context.read<PageChange>().changePageCache(GroceriesHome()),
              ),

              SizedBox(
                height: 40.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

