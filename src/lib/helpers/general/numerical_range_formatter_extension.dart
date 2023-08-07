import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

///Code from https://stackoverflow.com/questions/58836681/how-to-make-range-number-value-on-textfield-flutter

class NumericalRangeFormatter extends TextInputFormatter {
  final double min;
  final double max;

  NumericalRangeFormatter({required this.min, required this.max});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {

    if (newValue.text == '') {
      return newValue;
    } else if (int.parse(newValue.text) < min) {
      return newValue.copyWith(text: min.toStringAsFixed(0));
    } else {
      return int.parse(newValue.text) > max ? oldValue : newValue;
    }
  }
}