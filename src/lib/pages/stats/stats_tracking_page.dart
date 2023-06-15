import 'package:fitness_tracker/exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import '../../constants.dart';
import '../../models/stats/stats_model.dart';
import '../../providers/general/database_write.dart';
import '../../providers/stats/user_measurements.dart';
import '../../widgets/general/app_default_button.dart';
import '../../widgets/general/screen_width_container.dart';
import '../../widgets/stats/stats_add_data.dart';
import '../../widgets/stats/stats_edit_data.dart';
import '../../widgets/stats/stats_line_chart.dart';

class MeasurementTrackingPage extends StatefulWidget {
  MeasurementTrackingPage({Key? key, required this.index}) : super(key: key);
  late int index;
  @override
  State<MeasurementTrackingPage> createState() => _MeasurementTrackingPageState();
}

class _MeasurementTrackingPageState extends State<MeasurementTrackingPage> {
  late TextEditingController measurementNameController = TextEditingController();
  late final measurementNameKey = GlobalKey<FormState>();
  late List<StatsMeasurement> data;

  void initState() {
    data = context.read<UserStatsMeasurements>().statsMeasurement;
    measurementNameController.text = data[widget.index].measurementName;
    super.initState();
  }

  deleteMeasurement(BuildContext context, int index, String value, double width) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: appTertiaryColour,
          title: const Text(
            "Deletion Confirmation",
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          content: RichText(
            text: TextSpan(text: 'Are you sure you would like to delete the measurement: ',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
              children: <TextSpan>[
                TextSpan(text: '$value',
                  style: const TextStyle(
                    color: Colors.red,
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
                  buttonText: "Cancel",
                  onTap: () {
                    Navigator.pop(context);
                  },
                )
            ),
            Container(
              height: 30,
              child: AppButton(
                primaryColor: Colors.red,
                buttonText: "Delete",
                onTap: () {
                  DeleteUserDocumentMeasurements(context.read<UserStatsMeasurements>().statsMeasurement[widget.index].measurementID);
                  context.read<UserStatsMeasurements>().deleteMeasurement(
                    widget.index,
                  );

                  Navigator.pop(context);
                  context.read<PageChange>().changePageClearCache(
                    MeasurementsHomePage(),
                  );
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

    double _height = MediaQuery.of(context).size.height/1.03;
    double _width = MediaQuery.of(context).size.width;
    double _margin = 15;
    double fontSize = 21;

    context.watch<UserStatsMeasurements>().statsMeasurement;
    if (data[widget.index].measurementName.length > 15) {
      fontSize -= data[widget.index].measurementName.length.toDouble()/15;
      if (fontSize < 18) {
        fontSize = 18;
      }
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appPrimaryColour,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: _height/1.118,
            maxWidth: _width,
          ),
          child: ScreenWidthContainer(
            minHeight: _height,
            maxHeight: _height,
            height: _height,
            margin: 0,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 32,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 2, color: appQuinaryColour),
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            height: 24,
                            child: Form(
                              key: measurementNameKey,
                              child: TextFormField(
                                controller: measurementNameController,
                                cursorColor: Colors.white,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: (21),
                                ),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(bottom: (_width/12)/3.2, left: 7, right: 4,),
                                  hintText: 'Enter Value...',
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
                                onFieldSubmitted: (value) {
                                  if (measurementNameKey.currentState!.validate()) {
                                    context.read<UserStatsMeasurements>().updateStatsMeasurementName(value, widget.index);
                                    UpdateUserDocumentMeasurements(context.read<UserStatsMeasurements>().statsMeasurement[widget.index]);
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: -(_width/12)/12,
                        child: Container(
                          width: _width/10,
                          height: _width/10,
                          child: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 23,
                            ),
                            onPressed: () {
                              deleteMeasurement(
                                this.context,
                                widget.index,
                                measurementNameController.text,
                                _width,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: EdgeInsets.only(
                        left: _margin/2,
                        right: _margin/2,
                      ),
                      height: 337/1.34,
                      width: MediaQuery.of(context).size.width/1.15,
                      child: data[widget.index].measurementValues.isEmpty || data[widget.index].measurementValues.length < 2 ? const Center(
                          child: Text(
                            "Not Enough Data to Display",
                            style: TextStyle(
                              color: appQuarternaryColour,
                              fontSize: 22,
                            ),
                          )
                      ) : StatsLineChart(index: widget.index),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 3, color: appPrimaryColour),
                      ),
                    ),
                    height: _height/2,
                    width: double.infinity,
                    margin: EdgeInsets.only(top:6 + _margin/2),
                    child: Column(
                      children: [
                        StatsAddMeasurement(
                          index: widget.index,
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: data[widget.index].measurementValues.length,
                            itemBuilder: (BuildContext context, int index) {
                              context.watch<UserStatsMeasurements>().statsMeasurement;
                              return StatsEditMeasurement(
                                key: UniqueKey(),
                                index: widget.index,
                                listIndex: (data[widget.index].measurementValues.length - 1) - index,
                                date: data[widget.index].measurementDates[(data[widget.index].measurementValues.length - 1) - index].toString(),
                                value: data[widget.index].measurementValues[(data[widget.index].measurementValues.length - 1) - index].toString(),
                              );
                              },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

