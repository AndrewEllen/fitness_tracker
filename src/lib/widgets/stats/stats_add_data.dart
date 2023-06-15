import 'package:fitness_tracker/constants.dart';
import 'package:fitness_tracker/models/stats/stats_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/general/database_write.dart';
import '../../providers/stats/user_measurements.dart';

class StatsAddMeasurement extends StatefulWidget {
  StatsAddMeasurement({Key? key, required this.index}) : super(key: key);
  late int index;

  @override
  State<StatsAddMeasurement> createState() => _StatsAddMeasurementState();
}

class _StatsAddMeasurementState extends State<StatsAddMeasurement> {
  late TextEditingController measurementValueController = TextEditingController();
  late final measurementValueKey = GlobalKey<FormState>();
  late DateTime dateUnformatted = DateTime.now();

  @override
  void initState() {
    measurementValueController.text = "0.0";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return Container(
      width: _width,
      height: _height/14,
      margin: const EdgeInsets.only(
        left: 8,
        right: 8,
        top: 8,
      ),
      decoration: const BoxDecoration(
        color: appQuinaryColour,
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Row(
        children: [
          const Spacer(flex: 1),
          Container(
            decoration: BoxDecoration(
              color: appTertiaryColour,
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              border: Border.all(
                color: appQuarternaryColour,
              ),
            ),
            width: _width/3,
            height: _width/12,
            child: Center(
              child: GestureDetector(
                onTap: () async {
                  DateTime? newDateUnformatted = await showDatePicker(
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          dialogBackgroundColor: appTertiaryColour,
                          colorScheme: const ColorScheme.light(
                            primary: appSecondaryColour,
                            onPrimary: Colors.white,
                            onSurface: appSecondaryColour,
                          ),
                          textTheme: const TextTheme(
                            bodyLarge: TextStyle(
                             color: Colors.white,
                            ),
                            headlineMedium: TextStyle(
                              fontSize: 26,
                            ),
                            headlineSmall: TextStyle(
                              fontSize: 26,
                            ),
                            titleSmall: TextStyle(
                              fontSize: 20,
                            ),
                            bodyMedium: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              foregroundColor: Colors.white,
                              backgroundColor: appSecondaryColour,
                            ),
                          ),
                        ),
                        child: child!,
                      );
                    },
                      context: context,
                      initialDate: dateUnformatted,
                      firstDate: DateTime(1991),
                      lastDate: DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day),
                  );
                  if (newDateUnformatted != null) {
                    setState(() {
                      dateUnformatted = newDateUnformatted;
                    });
                  }
                },
                child: Text(
                  DateFormat('dd/MM/yyyy').format(dateUnformatted),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: (20),
                  ),
                ),
              ),
            ),
          ),
          const Spacer(flex: 1),
          Container(
            decoration: BoxDecoration(
              color: appTertiaryColour,
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              border: Border.all(
                color: appQuarternaryColour,
              ),
            ),
            width: _width/3,
            height: _width/12,
            child: Form(
              key: measurementValueKey,
              child: TextFormField(
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                ],
                keyboardType: TextInputType.number,
                controller: measurementValueController,
                cursorColor: Colors.white,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: (20),
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: (_width/12)/2.5, left: 5, right: 5,),
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
              ),
            ),
          ),
          const Spacer(flex: 1),
          Container(
            decoration: BoxDecoration(
              color: appSecondaryColour,
              borderRadius: const BorderRadius.all(Radius.circular(45)),
              border: Border.all(
                color: appQuarternaryColour,
              ),
            ),
            width: _width/10,
            height: _width/10,
            child: IconButton(
              icon: const Icon(
                Icons.save,
                color: Colors.white,
              ),
              onPressed: () {
                if (measurementValueKey.currentState!.validate()) {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  context.read<UserStatsMeasurements>().addStatsMeasurement(
                    double.parse(measurementValueController.text),
                    dateUnformatted.add(
                        Duration(
                          hours: DateTime.now().hour,
                          minutes: DateTime.now().minute,
                          seconds: DateTime.now().second,
                        )).toString(),
                    widget.index,
                  );
                  UpdateUserDocumentMeasurements(context.read<UserStatsMeasurements>().statsMeasurement[widget.index]);
                }
              },
            ),
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
