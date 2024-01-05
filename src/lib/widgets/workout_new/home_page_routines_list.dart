import 'package:fitness_tracker/constants.dart';
import 'package:fitness_tracker/exports.dart';
import 'package:fitness_tracker/widgets/workout_new/workout_bottom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../pages/workout_new/workout_routine_page.dart';
import '../../providers/workout/workoutProvider.dart';

class HomePageRoutinesList extends StatefulWidget {
  const HomePageRoutinesList({Key? key}) : super(key: key);

  @override
  State<HomePageRoutinesList> createState() => _HomePageRoutinesListState();
}

class _HomePageRoutinesListState extends State<HomePageRoutinesList> {

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: context.read<WorkoutProvider>().routinesList.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: InkWell(
            onTap: () => context.read<PageChange>().changePageCache(WorkoutRoutinePage(
              routine: context.read<WorkoutProvider>().routinesList[index],
            )),
            child: Column(
              children: [
                ListTile(
                  tileColor: appTertiaryColour,
                  leading: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: appSecondaryColour,
                    ),
                    width: 40.h,
                    height: 40.h,
                    child: Center(
                      child: Text(
                        context.read<WorkoutProvider>().routinesList[index].routineName[0],
                        style: boldTextStyle,
                      ),
                    ),
                  ),
                  title: Text(
                    context.read<WorkoutProvider>().routinesList[index].routineName,
                    style: boldTextStyle,
                  ),
                  subtitle: const Text(
                    "-5 days ago",
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                    ),
                  ),
                  trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.more_vert, color: Colors.white,
                      ),
                  ),
                ),
                InkWell(
                  onTap: () => context.read<PageChange>().changePageCache(WorkoutRoutinePage(
                    routine: context.read<WorkoutProvider>().routinesList[index],
                  )),
                  child: Ink(
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.white30,
                        )
                      ),
                      boxShadow: [
                        basicAppShadow
                      ],
                      color: appTertiaryColour,
                    ),
                    child: SizedBox(
                      width: double.maxFinite,
                      height: 24.h,
                      child: Center(
                        child: Text(
                          "Open Routine",
                          style: boldTextStyle.copyWith(
                            color: appSecondaryColour,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );

        },
    );
  }
}
