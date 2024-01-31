import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants.dart';


class WorkoutDropdownBox extends StatefulWidget {
  WorkoutDropdownBox({Key? key, required this.items, required this.textEditingController, required this.value}) : super(key: key);
  final List<String> items;
  late TextEditingController textEditingController;
  late String value;

  @override
  State<WorkoutDropdownBox> createState() => _WorkoutDropdownBoxState();
}

class _WorkoutDropdownBoxState extends State<WorkoutDropdownBox> {

  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: const Text(
          'Select Item',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
        items: widget.items
            .map((item) => DropdownMenuItem(
          value: item,
          child: Text(
            item,
            style: const TextStyle(
                fontSize: 14,
                color: Colors.white
            ),
          ),
        ))
            .toList(),
        value: selectedValue,
        onChanged: (value) {
          setState(() {
            widget.value = value!;
            selectedValue = value;
          });
        },
        buttonStyleData: const ButtonStyleData(
          decoration: BoxDecoration(
              color: appTertiaryColour
          ),
          padding: EdgeInsets.symmetric(horizontal: 16),
          height: 40,
          width: 200,
        ),
        dropdownStyleData: const DropdownStyleData(
          maxHeight: 200,
          decoration: BoxDecoration(
              color: appQuinaryColour
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          overlayColor: MaterialStatePropertyAll(appQuarternaryColour),
        ),
        dropdownSearchData: DropdownSearchData(
          searchController: widget.textEditingController,
          searchInnerWidgetHeight: 50,
          searchInnerWidget: Container(
            color: appQuinaryColour,
            height: 50,
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 4,
              right: 8,
              left: 8,
            ),
            child: TextFormField(
              expands: true,
              maxLines: null,
              controller: widget.textEditingController,
              decoration: InputDecoration(
                filled: true,
                fillColor: appQuarternaryColour,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                hintText: 'Search for an item...',
                hintStyle: const TextStyle(fontSize: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),

              ),
            ),
          ),
          searchMatchFn: (item, searchValue) {
            return item.value.toString().toLowerCase().contains(searchValue.toLowerCase());
          },
        ),
        //This to clear the search value when you close the menu
        onMenuStateChange: (isOpen) {
          if (!isOpen) {
            widget.textEditingController.clear();
          }
        },
      ),
    );
  }
}
