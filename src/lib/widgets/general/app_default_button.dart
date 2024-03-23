import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  AppButton({Key? key, required this.onTap, required this.buttonText,
  this.primaryColor,
  this.fontSize = 22,
  }) : super(key: key);
  final String buttonText;
  final VoidCallback onTap;
  final Color? primaryColor;
  final double fontSize;

  late ButtonStyle? changeColor;

  @override
  Widget build(BuildContext context) {
    if (primaryColor != null) {
      changeColor = ElevatedButton.styleFrom(
        backgroundColor: primaryColor!,
      );
    } else {
      changeColor = ElevatedButton.styleFrom(
      );
    }
    return ElevatedButton(
      style: changeColor,
      onPressed: () {
        FirebaseAnalytics.instance.logEvent(name: 'button_press_'+buttonText.replaceAll(" ", "_"));
        onTap();
        },
      child: FittedBox(
        fit: BoxFit.fitHeight,
        child: Text(
          buttonText,
          style: TextStyle(
            color: Colors.white,
            shadows: const <Shadow>[
              Shadow(
                offset: Offset(1,1),
                blurRadius: 1,
                color: Color.fromRGBO(0, 0, 0, 0.1),
              ),
            ],
            fontSize: fontSize,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
