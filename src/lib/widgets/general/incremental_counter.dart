import 'package:fitness_tracker/constants.dart';
import 'package:fitness_tracker/exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';


class IncrementalCounter extends StatefulWidget {
  const IncrementalCounter({Key? key,
    required this.inputController, required this.suffix, required this.label,
    required this.smallButtons, this.function, this.bigIncrementAmount = 1, this.smallIncrementAmount = 2.5}) : super(key: key);
  final TextEditingController inputController;
  final String suffix;
  final String label;
  final bool smallButtons;
  final VoidCallback? function;
  final double bigIncrementAmount;
  final double smallIncrementAmount;


  @override
  State<IncrementalCounter> createState() => _IncrementalCounterState();
}

class _IncrementalCounterState extends State<IncrementalCounter> {

  final RegExp removeTrailingZeros = RegExp(r'([.]*0)(?!.*\d)');

  final textInputFormatter = <TextInputFormatter>[
    FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
  ];

  void incrementCounter(bool isSmall) {

    if (widget.inputController.text.isEmpty) {
      widget.inputController.text = "0";
    }

    if (isSmall) {

      widget.inputController.text = (double.parse(widget.inputController.text) + widget.smallIncrementAmount).toString().replaceAll(removeTrailingZeros, "");

    } else {

      widget.inputController.text = (double.parse(widget.inputController.text) + widget.bigIncrementAmount).toString().replaceAll(removeTrailingZeros, "");

    }

    if (double.parse(widget.inputController.text) < 0) {
      widget.inputController.text = "0";
    }

    if (widget.function != null) {
      widget.function!();
    }

  }

  void decrementCounter(bool isSmall) {

    if (widget.inputController.text.isEmpty) {
      widget.inputController.text = "0";
    }

    if (isSmall) {

      widget.inputController.text = (double.parse(widget.inputController.text) - widget.smallIncrementAmount).toString().replaceAll(removeTrailingZeros, "");

    } else {

      widget.inputController.text = (double.parse(widget.inputController.text) - widget.bigIncrementAmount).toString().replaceAll(removeTrailingZeros, "");

    }

    if (double.parse(widget.inputController.text) < 0) {
      widget.inputController.text = "0";
    }

    if (widget.function != null) {
      widget.function!();
    }

  }

  @override
  Widget build(BuildContext context) {

    int smallButtonFlex = 2;
    int bigButtonFlex = 7;

    return Container(
      margin: const EdgeInsets.all(8),
      //width: widget.smallButtons ? 300.w : 205.w,
      height: 55.h,
      child: Row(
        children: [
          Spacer(flex: widget.smallButtons ? smallButtonFlex : bigButtonFlex),
          widget.smallButtons ? Material(
            type: MaterialType.transparency,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () => decrementCounter(true),
              icon: const Icon(
                MdiIcons.minus,
                size: 36,
              ),
            ),
          ) : const SizedBox.shrink(),
          Material(
            type: MaterialType.transparency,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () => decrementCounter(false),
              icon: const Icon(
                MdiIcons.minusCircle,
                size: 40,
              ),
            ),
          ),
          const Spacer(),
          Expanded(
            flex: 12,
            child: Form(
              child: TextFormField(
                controller: widget.inputController,
                keyboardType: TextInputType.number,
                inputFormatters: textInputFormatter,
                cursorColor: Colors.white,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: (18),
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  isDense: true,
                  label: Text(
                    widget.label,
                    style: boldTextStyle.copyWith(
                      fontSize: 14
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: appQuarternaryColour,
                      )
                  ),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: appSecondaryColour,
                      )
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: appSecondaryColour,
                    )
                  ),
                  suffix: Text(
                    widget.suffix,
                    style: boldTextStyle.copyWith(
                        fontSize: 16
                    ),
                  ),
                ),
                onTap: () => widget.inputController.selection = TextSelection(baseOffset: 0, extentOffset: widget.inputController.value.text.length),
                onEditingComplete: () {
                  widget.inputController.text = double.tryParse(widget.inputController.text) == null ? "0" : widget.inputController.text;
                },
                onTapOutside: (value) {
                  widget.inputController.text = double.tryParse(widget.inputController.text) == null ? "0" : widget.inputController.text;
                },
              ),
            ),
          ),
          const Spacer(),
          Material(
            type: MaterialType.transparency,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () => incrementCounter(false),
              icon: const Icon(
                Icons.add_circle,
                size: 40,
              ),
            ),
          ),
          widget.smallButtons ? Material(
            type: MaterialType.transparency,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () => incrementCounter(true),
              icon: const Icon(
                Icons.add,
                size: 36,
              ),
            ),
          ) : const SizedBox.shrink(),
          Spacer(flex: widget.smallButtons ? smallButtonFlex : bigButtonFlex),
        ],
      ),
    );
  }
}
