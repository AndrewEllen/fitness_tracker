import 'package:fitness_tracker/constants.dart';
import 'package:flutter/material.dart';

class ModalBottomSheet {
  static void showModal(BuildContext context, Widget child, {double heightFactor = 0.9}) {
    showModalBottomSheet(
      backgroundColor: appTertiaryColour,
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return DefaultModal(
          child: child,
        );
      },
    );
  }
}

class DefaultModal extends StatelessWidget {
  const DefaultModal({Key? key, required this.child, this.heightFactor = 0.9}) : super(key: key);

  final double heightFactor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: heightFactor,
      widthFactor: 1,
      child: child,
    );
  }
}