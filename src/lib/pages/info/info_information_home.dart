import 'package:flutter/material.dart';
import 'package:fitness_tracker/constants.dart';

class InformationHomePage extends StatelessWidget {
  const InformationHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: appPrimaryColour,
        body: Text("Info", style: TextStyle(color: Colors.white),),
    );
  }
}
