import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../pages/workout_new/workout_routine_page.dart';
import '../../providers/general/page_change_provider.dart';
import '../../providers/workout/workoutProvider.dart';
import '../general/app_default_button.dart';


class RoutineBox extends StatefulWidget {
  RoutineBox({Key? key, required this.index}) : super(key: key);
  final int index;

  @override
  State<RoutineBox> createState() => _RoutineBoxState();
}

class _RoutineBoxState extends State<RoutineBox> {


  late bool _expandPanel = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: InkWell(
        onTap: () => context.read<PageChange>().changePageCache(WorkoutRoutinePage(
          routine: context.read<WorkoutProvider>().routinesList[widget.index],
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
                    context.read<WorkoutProvider>().routinesList[widget.index].routineName[0],
                    style: boldTextStyle,
                  ),
                ),
              ),
              title: Text(
                context.read<WorkoutProvider>().routinesList[widget.index].routineName,
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
                onPressed: () {
                  setState(() {
                    _expandPanel = !_expandPanel;
                  });
                },
                icon: const Icon(
                  Icons.more_vert, color: Colors.white,
                ),
              ),
            ),
            InkWell(
              onTap: () => context.read<PageChange>().changePageCache(WorkoutRoutinePage(
                routine: context.read<WorkoutProvider>().routinesList[widget.index],
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Open Routine",
                          style: boldTextStyle.copyWith(
                            color: appSecondaryColour,
                          ),
                        ),
                        const Icon(
                            Icons.keyboard_arrow_down_outlined
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0.0, end: _expandPanel ? 40 : 0),
              duration: const Duration(milliseconds: 250),
              builder: (context, value, _) => ClipRRect(
                child: Material(
                  type: MaterialType.transparency,
                  child: Ink(
                    height: value.h,
                    color: Colors.red,
                    child: InkWell(
                      onTap: () async {
                        bool _delete = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: appTertiaryColour,
                              titleTextStyle: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                                fontSize: 22,
                              ),
                              contentTextStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              title: const Text('Do you want to remove this Exercise?'),
                              content: const Text("It can be added again later"),
                              actions: <Widget>[
                                AppButton(
                                  onTap: () => Navigator.of(context).pop(false),
                                  buttonText: "No",
                                ),
                                AppButton(
                                  onTap: () => Navigator.of(context).pop(true),
                                  buttonText: "Yes",
                                ),
                              ],
                            );
                          },
                        );
                        if (_delete) {
                          print("deleting");
                          context.read<WorkoutProvider>().deleteRoutine(widget.index);
                        }
                      },
                      child: const Center(
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
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
  }
}
