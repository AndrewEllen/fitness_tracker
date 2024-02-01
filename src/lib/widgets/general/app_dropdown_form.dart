import 'package:fitness_tracker/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text_analysis/extensions.dart';

import '../../providers/workout/workoutProvider.dart';

class DropDownForm extends StatefulWidget {
  const DropDownForm({Key? key, required this.formController, required this.formKey}) : super(key: key);

  final TextEditingController formController;
  final GlobalKey<FormState> formKey;


  @override
  State<DropDownForm> createState() => _DropDownFormState();
}

class _DropDownFormState extends State<DropDownForm> {

  bool _displayDropdown = false;

  List<String> searchList = [];

  void searchForExercise(String value) {

    List<String> sortListBySimilarity(List<Map> similarityMap) {

      print(similarityMap);
      // Sorting the list in descending order based on the values of the map items
      similarityMap.sort((a, b) => (b.values.first as num).compareTo(a.values.first as num));

      // Extracting the keys from the sorted list of maps
      List<String> orderedList = similarityMap.map((map) => map.keys.first.toString()).toList();

      return orderedList;
    }

    List<String> checkSimilarity(String searchWord, String searchItem) {
      List<Map> _wordsSimilarity = [];

      for(String searchWord in searchWord.split(" ")) {

        for(String itemWord in searchItem.split(" ")) {
          double _similarity = searchWord.jaccardSimilarity(itemWord);
          if (_similarity > 0.42) {

            _wordsSimilarity.add({
              searchItem: _similarity
            });

            return sortListBySimilarity(_wordsSimilarity);
          }

        }
      }
      return [];
    }

    List<String> internalSearchList = [];

    List<String> listToSearch = context.read<WorkoutProvider>().exerciseNamesList;

    if (value.isNotEmpty) {

      for (var item in listToSearch) {

        if (item.toLowerCase().contains(value.toLowerCase())) {
          internalSearchList.add(item);

        } else {

          internalSearchList.addAll(checkSimilarity(value, item));

        }
      }
    }

    setState(() {
      searchList = internalSearchList;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: widget.formKey,
            controller: widget.formController,
            style: boldTextStyle,
            cursorColor: appSecondaryColour,
            decoration: InputDecoration(
              labelText: "Search Exercises...",
              labelStyle: boldTextStyle.copyWith(
                color: Colors.white,
                fontSize: 14,
              ),
              errorStyle: boldTextStyle.copyWith(
                color: Colors.red,
              ),
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: appSecondaryColour,
                  )
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: appSecondaryColour,
                  )
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: appSecondaryColour,
                  )
              ),
              focusedErrorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.red,
                  )
              ),
              errorBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red,
                ),
              ),
            ),
          onChanged: (value) => searchForExercise(value),
          onTap: () {
              setState(() {
                _displayDropdown = true;
              });
          },
          onTapOutside: (value) {
              setState(() {
                _displayDropdown = false;
              });
          },
          onFieldSubmitted: (value) {

            setState(() {
              _displayDropdown = false;
            });
          },
        ),
        ListView.builder(
          itemCount: _displayDropdown ? searchList.isNotEmpty ? searchList.length : context.read<WorkoutProvider>().exerciseNamesList.length : 0,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            print(searchList);
            return Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: appQuinaryColour,
              ),
              child: searchList.isEmpty ? Text(
                context.read<WorkoutProvider>().exerciseNamesList[index],
                style: boldTextStyle,
              ) : Text(
                searchList[index],
                style: boldTextStyle,
              ),
            );
          },
        ),
      ],
    );
  }
}
