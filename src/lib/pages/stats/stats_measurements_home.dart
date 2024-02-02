import 'package:flutter/material.dart';
import 'package:fitness_tracker/exports.dart';
import 'package:fitness_tracker/constants.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../providers/general/database_write.dart';
import '../../widgets/general/app_default_button.dart';
import '../../widgets/general/screen_width_container.dart';
import '../../widgets/stats/stats_container_widget.dart';

class MeasurementsHomePage extends StatefulWidget {
  const MeasurementsHomePage({Key? key}) : super(key: key);

  @override
  State<MeasurementsHomePage> createState() => _MeasurementsHomePageState();
}

class _MeasurementsHomePageState extends State<MeasurementsHomePage> {
  late TextEditingController newMeasurementNameController = TextEditingController();
  late final newMeasurementNameKey = GlobalKey<FormState>();


  newMeasurement(BuildContext context) async {
    double buttonSize = 22.h;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(0),
          backgroundColor: appTertiaryColour,
          title: const Text(
            "Track New Body Measurement",
            style: TextStyle(
              color: appSecondaryColour,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Form(
                  key: newMeasurementNameKey,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Name Required";
                      }
                      return null;
                    },
                    controller: newMeasurementNameController,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: (18),
                    ),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      isDense: true,
                      label: Text(
                        "Measurement Name *",
                        style: boldTextStyle.copyWith(fontSize: 14),
                      ),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: appQuarternaryColour,
                          )),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: appSecondaryColour,
                          )),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: appSecondaryColour,
                          )),
                    ),
                  ),
                ),
              ),
            ],
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
                      buttonText: "Cancel",
                      onTap: () {
                        Navigator.pop(context);
                      },
                    )),
                const Spacer(),
                SizedBox(
                    height: buttonSize,
                    child: AppButton(
                      primaryColor: appSecondaryColour,
                      buttonText: "Create",
                      onTap: () {
                        if (newMeasurementNameKey.currentState!.validate()) {
                          context.read<UserStatsMeasurements>().addNewMeasurement(newMeasurementNameController.text, const Uuid().v4());
                          UpdateUserDocumentMeasurements(context.read<UserStatsMeasurements>().statsMeasurement[context.read<UserStatsMeasurements>().statsMeasurement.length-1]);
                          newMeasurementNameController.text = "";
                          Navigator.pop(context);
                        }
                      },
                    )),
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

    double _width = 393.w;
    double _height = 851.h;
    double _margin = 15.w;
    double _bigContainerMin = 500.h;
    double _smallContainerMin = 95.h;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appTertiaryColour,
        title: const Text(
          "Measurements",
          style: boldTextStyle,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: FloatingActionButton(
          onPressed: () => newMeasurement(context),
          backgroundColor: appSenaryColour,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: appPrimaryColour,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
        child: ListView.builder(
          itemCount: context.watch<UserStatsMeasurements>().statsMeasurement.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return StatsWidget(
              index: index,
            );
          },
        ),
      ),
    );
  }
}
