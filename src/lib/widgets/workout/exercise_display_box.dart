import 'package:flutter/material.dart';
import 'package:fitness_tracker/constants.dart';

class ExerciseDisplayBox extends StatelessWidget {
  const ExerciseDisplayBox({Key? key,
    required this.title,
    this.onTap,
    this.onTapIcon,
    this.onTapIcon2,
    this.subtitle,
    this.icon,
    this.icon2,
    this.iconColour = Colors.white,
    this.icon2Colour = Colors.white,
  }) : super(key: key);

  final String title;
  final String? subtitle;
  final IconData? icon, icon2;
  final Color? iconColour, icon2Colour;
  final VoidCallback? onTap, onTapIcon, onTapIcon2;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top:8,bottom:8),
      margin: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        color: appQuinaryColour,
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(
              color: appSecondaryColour,
              width: 3
            ),
            borderRadius: const BorderRadius.all(Radius.circular(45)),
            color: Colors.transparent,
          ),
          child: Center(
            child: Text(
              title[0].toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
            ),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22
          ),
        ),
        subtitle: subtitle != null ? Text(
          subtitle!.toString(),
          style: const TextStyle(
              color: Colors.white70,
              fontSize: 15
          ),
        ) : null,
        trailing: icon != null && icon2 != null ?
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onTapIcon,
              icon: Icon(
                icon,
                color: iconColour,
              ),
            ),
            IconButton(
              onPressed: onTapIcon2,
              icon: Icon(
                icon2,
                color: icon2Colour,
              ),
            ),
          ],
        ) : icon != null ?
        IconButton(
          onPressed: onTapIcon,
          icon: Icon(
            icon,
            color: iconColour,
          ),
        ) :
        null,
      ),
    );
  }
}
