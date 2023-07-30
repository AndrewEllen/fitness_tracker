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

  late final ButtonStyle? changeColor;

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
      onPressed: onTap,
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
