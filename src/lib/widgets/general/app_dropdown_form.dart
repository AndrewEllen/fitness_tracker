import 'package:easy_debounce/easy_debounce.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
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
    this.callback,
  }) : super(key: key);

  final TextEditingController formController;
  final GlobalKey<FormState> formKey;
  final List<String> listOfItems;
  final String label;
  final bool validate;
  final VoidCallback? callback;

  @override
  State<DropDownForm> createState() => _DropDownFormState();
}

class _DropDownFormState extends State<DropDownForm> {

  final ScrollController scrollController = ScrollController();

  bool _displayDropdown = false;

  List<String> searchList = [];

  final formFocusNode = FocusNode();

  void searchForExercise(String value) {


    List<Map> sortBySimilarity(List<Map> similarityMap) {

      List<Map> sortedList = [];

      for (int index = 0; index < similarityMap.length; index++) {
        if (sortedList.isNotEmpty) {
          int insertIndex = 0;
          for (int sortingIndex = 0; sortingIndex < sortedList.length; sortingIndex++) {
            if (similarityMap[index]["similarity"] >= similarityMap[insertIndex]["similarity"] ) {
              insertIndex = sortingIndex;
            }
          }
          sortedList.insert(insertIndex, similarityMap[index]);

        } else {
          sortedList.add(similarityMap[index]);
        }

      }
      return sortedList;
    }


    List<Map> sortListBySimilarity(List<Map> similarityMap) {

      // Create a new list with the same elements and then sort it
      List<Map<dynamic, dynamic>> sortedList = List<Map<dynamic, dynamic>>.from(similarityMap);
      sortedList.sort((a, b) => (b["similarity"] as num).compareTo(a["similarity"] as num));

      return sortedList;
    }

    Map checkSimilarity(String searchWord, String searchItem,) {

      if (searchWord.toLowerCase().trim() == searchItem.toLowerCase().trim()) {
        return {
          "similarity": 1.1,
          "listItem": searchItem,
        };
      }

      List similarityList = [];
      for(String searchWord in searchWord.split(" ")) {

        for(String itemWord in searchItem.split(" ")) {
          double _similarity = searchWord.jaccardSimilarity(itemWord);
          if (_similarity > 0.42) {
            similarityList.add(_similarity);
          }
        }
      }

      double average = 0;

      for (double value in similarityList) {
        average += value;
      }
      average = average/similarityList.length;

      if (average.isNaN) {
        average = 0;
      }

      return {
        "similarity": average,
        "listItem": searchItem,
      };
    }




    searchList = widget.listOfItems;

    List<String> listSearchItems = [];

    if (value.isNotEmpty) {

      List<Map> internalSearchList = [];

      searchList.asMap().forEach((index, item) {

        Map similarityMap = checkSimilarity(
          value,
          item,
        );
        internalSearchList.add(similarityMap);
      });

      internalSearchList = sortListBySimilarity(internalSearchList);
      print(internalSearchList);

      internalSearchList.asMap().forEach((index, item) {
        listSearchItems.add(item["listItem"]);
      });



      setState(() {
        searchList = listSearchItems;
      });

    } else {
      setState(() {
        searchList;
      });
    }

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
            onChanged: (value) => EasyDebounce.debounce(
              "levenshteinDistanceDebouncerExercise",
              const Duration(milliseconds: 200),
                  () => searchForExercise(value)),
            onTap: () {
              FirebaseAnalytics.instance.logEvent(name: widget.label.replaceAll(" ", "_")+'_dropdown_selected');
                setState(() {
                  _displayDropdown = true;
                });
            },
            onFieldSubmitted: (value) {
              FirebaseAnalytics.instance.logEvent(name: widget.label.replaceAll(" ", "_")+'_dropdown_selected');
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
              maxHeight: 240.h,
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
                              FirebaseAnalytics.instance.logEvent(name: widget.label.replaceAll(" ", "_")+'_dropdown_selected');
                              widget.formController.text = widget.listOfItems[index];

                              if (widget.callback != null) {
                                widget.callback!();
                              }
                
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
                            FirebaseAnalytics.instance.logEvent(name: widget.label.replaceAll(" ", "_")+'_dropdown_selected');
                            widget.formController.text = searchList[index];

                            if (widget.callback != null) {
                              widget.callback!();
                            }

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
