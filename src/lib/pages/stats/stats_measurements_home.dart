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
  bool _displayDropDown = false;
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
        child: Stack(
          children: [
            ListView(
              shrinkWrap: true,
              children: [
                SizedBox(height: 12.h),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: _height/1.25,
                    maxWidth: _width,
                  ),
                  child: ListView.separated(
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(
                        height: 5,
                      );
                    },
                    shrinkWrap: false,
                    itemCount: context.watch<UserStatsMeasurements>().statsMeasurement.length,
                    itemBuilder: (BuildContext context, int index) {
                        return StatsWidget(
                          minHeight: _bigContainerMin,
                          maxHeight: _bigContainerMin,
                          height: _bigContainerMin,
                          width: _width,
                          margin: _margin,
                          index: index,
                        );
                    },
                  ),
                ),
              ],
            ),
            _displayDropDown
                ? Container(
              height: _height,
              width: _width,
              color: appPrimaryColour.withOpacity(0.5),
              child: GestureDetector(
                onTap: (() {
                  setState(() {
                    _displayDropDown = false;
                  });
                }),
              ),
            )
                : const SizedBox.shrink(),
            _displayDropDown ? Positioned(
              top: _height/4,
              left: _width/10,
              right: _width/10,
              child: Container(
                height: _height/5,
                width: _width/1.5,
                margin: EdgeInsets.all(_margin),
                decoration: const BoxDecoration(
                  color: appTertiaryColour,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                child: Stack(
                  children: [
                    Container(
                      height: 32,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 2, color: appQuinaryColour),
                        ),
                      ),
                      child: const Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: 24,
                          child: Text(
                            "New Measurement",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: _width/5.5,
                      left: _width/30,
                      child: Container(
                        decoration: BoxDecoration(
                          color: appTertiaryColour,
                          borderRadius: const BorderRadius.all(Radius.circular(4)),
                          border: Border.all(
                            color: appQuarternaryColour,
                          ),
                        ),
                        width: _width/1.5,
                        height: _width/12,
                        child: Form(
                          key: newMeasurementNameKey,
                          child: TextFormField(
                            controller: newMeasurementNameController,
                            cursorColor: Colors.white,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: (20),
                            ),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(bottom: (_width/12)/2.5, left: 5, right: 5,),
                              hintText: 'Measurement Name...',
                              hintStyle: const TextStyle(
                                color: Colors.white54,
                                fontSize: (18),
                              ),
                              errorStyle: const TextStyle(
                                height: 0,
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: appSecondaryColour,
                                ),
                              ),
                            ),
                            validator: (String? value) {
                              if (value!.isNotEmpty) {
                                return null;
                              }
                              return "";
                            },
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: _width/42,
                      right: _width/4.33,
                      child: SizedBox(
                        height: 30,
                        child: AppButton(
                          buttonText: "Cancel",
                          onTap: () {
                            setState(() {
                              _displayDropDown = false;
                            });
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: _width/42,
                      right: _width/33,
                      child: SizedBox(
                        height: 30,
                        child: AppButton(
                          buttonText: "Save",
                          onTap: () {
                            setState(() {
                              if (newMeasurementNameKey.currentState!.validate()) {
                                context.read<UserStatsMeasurements>().addNewMeasurement(newMeasurementNameController.text, const Uuid().v4());
                                UpdateUserDocumentMeasurements(context.read<UserStatsMeasurements>().statsMeasurement[context.read<UserStatsMeasurements>().statsMeasurement.length-1]);
                                newMeasurementNameController.text = "";
                                _displayDropDown = false;
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ) : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
