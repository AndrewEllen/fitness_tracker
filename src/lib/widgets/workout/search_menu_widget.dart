import 'package:fitness_tracker/exports.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:provider/provider.dart';


class SearchMenu extends StatefulWidget {
  const SearchMenu({Key? key}) : super(key: key);

  @override
  State<SearchMenu> createState() => _SearchMenuState();
}

class _SearchMenuState extends State<SearchMenu> {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white38,
      child: DropdownSearch(
        items: context.read<ExerciseList>().panelTitles,
        dropdownSearchDecoration: const InputDecoration(labelText: "Exercise Name"),
        onChanged: print,
        /*validator: (String? item) {
          if (item == null) {
            return "Required field";
          } else if (item == "Brazil") {
            return "Invalid item";
          } else {
            return null;
          }
        },*/
      ),
    );
  }
}
