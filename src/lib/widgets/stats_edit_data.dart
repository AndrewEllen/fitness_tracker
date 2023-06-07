import 'package:fitness_tracker/constants.dart';
import 'package:fitness_tracker/models/stats_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/database_write.dart';
import '../providers/page_change_provider.dart';
import '../providers/user_measurements.dart';
import 'app_default_button.dart';

class StatsEditMeasurement extends StatefulWidget {
  StatsEditMeasurement({Key? key, required this.listIndex, required this.index, required this.date, required this.value}) : super(key: key);
  late int index, listIndex;
  late String date, value;

  @override
  State<StatsEditMeasurement> createState() => _StatsEditMeasurementState();
}

class _StatsEditMeasurementState extends State<StatsEditMeasurement> {
  late TextEditingController measurementValueController = TextEditingController();
  late final measurementValueKey = GlobalKey<FormState>();
  bool _editData = false;

  @override
  void initState() {
    measurementValueController.text = widget.value;
    super.initState();
  }

  deleteStat(BuildContext context, int index, int listIndex, String value, double width) {
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
            text: TextSpan(text: 'Are you sure you would like to delete the stat from: ',
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
                    context.read<UserStatsMeasurements>().deleteStat(
                      widget.listIndex,
                      widget.index,
                    );
                    UpdateUserDocumentMeasurements(context.read<UserStatsMeasurements>().statsMeasurement[widget.index]);
                    Navigator.pop(context);
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

    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return Container(
      width: _width,
      height: _editData ? _height/14 : _height/20,
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
            decoration: _editData ? BoxDecoration(
              color: appTertiaryColour,
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              border: Border.all(
                color: appQuarternaryColour,
              ),
            ) : null,
            width: _width/3,
            height: _width/12,
            child: Center(
              child: Text(
                DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.date)),
                style: TextStyle(
                  color: _editData ? appQuarternaryColour : Colors.white,
                  fontSize: (20),
                ),
              ),
            ),
          ),
          const Spacer(flex: 1),
          Container(
            decoration: _editData ? BoxDecoration(
              color: appTertiaryColour,
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              border: Border.all(
                color: appQuarternaryColour,
              ),
            ) : null,
            width: _width/3,
            height: _width/12,
            child: Form(
              key: measurementValueKey,
              child: TextFormField(
                enabled: _editData,
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
          _editData ? Container(
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
                    setState(() {
                      context.read<UserStatsMeasurements>().updateStatsMeasurement(
                        measurementValueController.text,
                        widget.listIndex,
                        widget.index,
                      );
                      UpdateUserDocumentMeasurements(context.read<UserStatsMeasurements>().statsMeasurement[widget.index]);
                      _editData = false;
                    });
                }
              },
            ),
          ) : Row(
            children: [
              SizedBox(
                width: _width/10,
                height: _width/10,
                child: IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    deleteStat(
                      this.context,
                      widget.index,
                      widget.listIndex,
                      widget.date,
                      _width,
                    );
                  },
                ),
              ),
              SizedBox(
                width: _width/10,
                height: _width/10,
                child: IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _editData = true;
                    });
                  },
                ),
              ),
            ],
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
