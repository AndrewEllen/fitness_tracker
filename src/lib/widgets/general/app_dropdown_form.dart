import 'package:fitness_tracker/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:text_analysis/extensions.dart';

import '../../providers/workout/workoutProvider.dart';

class DropDownForm extends StatefulWidget {
  const DropDownForm({Key? key, required this.formController,
    required this.formKey,
    required this.listOfItems,
    required this.label,
    this.validate = true,
  }) : super(key: key);

  final TextEditingController formController;
  final GlobalKey<FormState> formKey;
  final List<String> listOfItems;
  final String label;
  final bool validate;

  @override
  State<DropDownForm> createState() => _DropDownFormState();
}

class _DropDownFormState extends State<DropDownForm> {

  final ScrollController scrollController = ScrollController();

  bool _displayDropdown = false;

  List<String> searchList = [];

  final formFocusNode = FocusNode();

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

    List<String> listToSearch = widget.listOfItems;

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
    return TapRegion(
      onTapOutside: (value) {
        setState(() {
          _displayDropdown = false;
        });
        if (formFocusNode.hasFocus) {
          formFocusNode.unfocus();
        }
      },
      child: Column(
        children: [
          TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: widget.formKey,
              controller: widget.formController,
              style: boldTextStyle,
              cursorColor: appSecondaryColour,
              focusNode: formFocusNode,
              decoration: InputDecoration(
                errorStyle: TextStyle(height: 0),
                labelText: widget.label,
                labelStyle: boldTextStyle.copyWith(
                  color: Colors.white,
                  fontSize: 14,
                ),
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: appQuarternaryColour,
                    )
                ),
                border: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: appSecondaryColour,
                    )
                ),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: appSecondaryColour,
                    )
                ),
                focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                    )
                ),
                errorBorder: const OutlineInputBorder(
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
            onFieldSubmitted: (value) {
              setState(() {
                _displayDropdown = false;
              });
            },
            validator: (value) {
                if (!widget.validate) {
                  return null;
                }
                if (value!.isEmpty) {
                  return "";
                }
                return null;
            },
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 200.h,
            ),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: appQuinaryColour
              ),
              child: _displayDropdown ? Scrollbar(
                controller: scrollController,
                thumbVisibility: true,
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: _displayDropdown ? searchList.isNotEmpty ? searchList.length : widget.listOfItems.length : 0,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: const EdgeInsets.all(8),
                      child: Material(
                        type: MaterialType.transparency,
                        child: searchList.isEmpty ? Ink(
                          child: InkWell(
                            onTap: () {
                
                              widget.formController.text = widget.listOfItems[index];
                              print(widget.listOfItems[index]);
                
                              setState(() {
                                _displayDropdown = false;
                              });
                
                              if (formFocusNode.hasFocus) {
                                formFocusNode.unfocus();
                              }
                
                            },
                            child: Text(
                              widget.listOfItems[index],
                              style: boldTextStyle,
                            ),
                          ),
                        ) : Ink(
                          child: InkWell(
                          onTap: () {
                
                            widget.formController.text = searchList[index];
                            print(searchList[index]);
                
                            setState(() {
                              _displayDropdown = false;
                            });
                
                            if (formFocusNode.hasFocus) {
                              formFocusNode.unfocus();
                            }
                
                            },
                            child: Text(
                              searchList[index],
                              style: boldTextStyle,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ) : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}
