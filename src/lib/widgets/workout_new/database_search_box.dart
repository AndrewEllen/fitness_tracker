import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:fitness_tracker/constants.dart';
import 'package:flutter/material.dart';
import 'package:fitness_tracker/models/workout/exercise_database_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'anatomy_diagram.dart';
import 'muscle_anatomy_diagram_painter.dart';

class DatabaseSearchBox extends StatefulWidget {
  DatabaseSearchBox({Key? key, required this.exerciseModel}) : super(key: key);
  ExerciseDatabaseModel exerciseModel;

  @override
  State<DatabaseSearchBox> createState() => _DatabaseSearchBoxState();
}

class _DatabaseSearchBoxState extends State<DatabaseSearchBox> {


  Map checkMuscle(List<String> musclesToCheck) {

    if (musclesToCheck.contains(widget.exerciseModel.primaryMuscle.trim())) {
      return {
        "display": true,
        "colour": 0xffff0000
      };
    }
    if (musclesToCheck.contains(widget.exerciseModel.secondaryMuscle.trim())) {
      return {
        "display": true,
        "colour": 0xffff5900
      };
    }
    if (musclesToCheck.contains(widget.exerciseModel.tertiaryMuscle.trim())) {
      return {
        "display": true,
        "colour": 0xffffca5e
      };
    }
    return {
      "display": false,
      "colour": 0xffff0000
    };
  }






  bool _expandPanel = false;
  YoutubePlayerController? shortVideoController;
  bool displayShortYoutubeVideo = false;
  YoutubePlayerController? longVideoController;
  bool displayLongYoutubeVideo = false;


  double dropDownSize() {

    if (displayShortYoutubeVideo && displayLongYoutubeVideo) {
      return 440.0.h;
    }
    if (displayShortYoutubeVideo) {
      return 340.0.h;
    }
    if (displayLongYoutubeVideo) {
      return 340.0.h;
    }
    return 260.0.h;

  }


  @override
  void initState() {

    if (widget.exerciseModel.shortVideo.isNotEmpty) {

      try {

        shortVideoController = YoutubePlayerController(
          initialVideoId: YoutubePlayer.convertUrlToId(widget.exerciseModel.shortVideo)!,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
          ),
        );

        setState(() {
          displayShortYoutubeVideo = true;
        });

      } catch (e)
      {
        setState(() {
          displayShortYoutubeVideo = false;
        });
        debugPrint(e.toString());
      }

    }

    if (widget.exerciseModel.longVideo.isNotEmpty) {

      try {

        longVideoController = YoutubePlayerController(
          initialVideoId: YoutubePlayer.convertUrlToId(widget.exerciseModel.longVideo)!,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
          ),
        );

        setState(() {
          displayLongYoutubeVideo = true;
        });

      } catch (e)
      {
        setState(() {
          displayLongYoutubeVideo = false;
        });
        debugPrint(e.toString());
      }

    }
    super.initState();
  }

  @override
  void dispose() {
    shortVideoController?.dispose();
    longVideoController?.dispose();
    super.dispose();
  }

  void _launchUrl(Uri _url) {
    launchUrl(_url);
  }



  @override
  Widget build(BuildContext context) {

    double diagramWidth = 300;

    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: appTertiaryColour,
              boxShadow: [
                BoxShadow(offset: Offset(0, 4), blurRadius: 2, color: Colors.black12)
              ]
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.exerciseModel.exercise,
                        style: boldTextStyle,
                      ),

                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Text(
                        widget.exerciseModel.difficulty,
                        style: boldTextStyle.copyWith(color: Colors.white70),
                      ),

                      Spacer(),

                      IconButton(
                          onPressed: () {
                            if (_expandPanel) {
                              FirebaseAnalytics.instance.logEvent(name: 'expanded_exercise_search');
                            } else {
                              FirebaseAnalytics.instance.logEvent(name: 'retracted_exercise_search');
                            }

                            setState(() {
                              _expandPanel = !_expandPanel;
                            });
                          },
                          icon: Icon(_expandPanel ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.white,
                          )
                      ),

                    ],
                  ),
                ],
              ),
            )
          ),
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0.0, end: _expandPanel ? dropDownSize() : 0.0),
            duration: const Duration(milliseconds: 250),
            builder: (context, value, _) => ClipRRect(
              child: Container(
                width: double.maxFinite,
                decoration: const BoxDecoration(
                    color: appTertiaryColour,
                    boxShadow: [
                      BoxShadow(offset: Offset(0, 4), blurRadius: 2, color: Colors.black12)
                    ]
                ),
                height: value * 3,
                child: _expandPanel ? ClipRRect(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                  
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: widget.exerciseModel.exercise));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text("Copied Exercise Name To Clipboard!"),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                margin: EdgeInsets.only(
                                  bottom: MediaQuery.of(context).size.height * 0.6695,
                                  right: 20,
                                  left: 20,
                                ),
                                dismissDirection: DismissDirection.none,
                                duration: const Duration(milliseconds: 700),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: widget.exerciseModel.mechanics.isNotEmpty ? Text(
                                  widget.exerciseModel.mechanics + " Exercise",
                                  style: boldTextStyle.copyWith(fontSize: 22),
                                ) : const SizedBox.shrink(),
                              ),
                              IconButton(
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(text: widget.exerciseModel.exercise));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text("Copied Exercise Name To Clipboard!"),
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        margin: EdgeInsets.only(
                                          bottom: MediaQuery.of(context).size.height * 0.6695,
                                          right: 20,
                                          left: 20,
                                        ),
                                        dismissDirection: DismissDirection.none,
                                        duration: const Duration(milliseconds: 700),
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.copy, color: Colors.white,
                                  )
                              ),
                            ],
                          ),
                        ),

                        AnatomyDiagram(
                          exerciseDatabaseModel: widget.exerciseModel,
                        ),
                  
                        const SizedBox(height: 225,),
                  
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.exerciseModel.secondaryMuscle.isEmpty ?
                              "Working Muscle: " :
                              "Working Muscles: ",
                              style: boldTextStyle.copyWith(fontSize: 18),
                              textAlign: TextAlign.left,
                            ),
                            widget.exerciseModel.primaryMuscle.isNotEmpty ? Text(
                              "- " + widget.exerciseModel.primaryMuscle,
                              style: boldTextStyle,
                              textAlign: TextAlign.left,
                            ) : const SizedBox.shrink(),
                  
                            widget.exerciseModel.secondaryMuscle.isNotEmpty ? Text(
                              "- " + widget.exerciseModel.secondaryMuscle,
                              style: boldTextStyle,
                              textAlign: TextAlign.left,
                            ) : const SizedBox.shrink(),
                  
                            widget.exerciseModel.tertiaryMuscle.isNotEmpty ? Text(
                              "- " + widget.exerciseModel.tertiaryMuscle,
                              style: boldTextStyle,
                              textAlign: TextAlign.left,
                            ) : const SizedBox.shrink(),
                          ],
                        ),
                  
                        const SizedBox(height: 25,),
                  
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Equipment Needed:",
                              style: boldTextStyle.copyWith(fontSize: 18),
                              textAlign: TextAlign.left,
                            ),
                            widget.exerciseModel.primaryEquipment.isNotEmpty ? Text(
                              "- " + widget.exerciseModel.primaryEquipment + " x " + widget.exerciseModel.numPrimaryItems,
                              style: boldTextStyle,
                              textAlign: TextAlign.left,
                            ) : const SizedBox.shrink(),
                  
                            widget.exerciseModel.secondaryEquipment.isNotEmpty ? Text(
                              "- " + widget.exerciseModel.secondaryEquipment + " x " + widget.exerciseModel.numSecondaryItems,
                              style: boldTextStyle,
                              textAlign: TextAlign.left,
                            ) : const SizedBox.shrink(),
                  
                          ],
                        ),
                  
                        const SizedBox(height: 25,),
                  
                        widget.exerciseModel.shortVideo.isNotEmpty && displayShortYoutubeVideo ? Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Short video explanation of the exercise",
                                  style: boldTextStyle.copyWith(fontSize: 18),
                                ),
                                IconButton(
                                  onPressed: () => _launchUrl(Uri.parse(widget.exerciseModel.shortVideo)),
                                  icon: const Icon(
                                    Icons.open_in_new,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                            YoutubePlayer(
                              controller: shortVideoController!,
                              showVideoProgressIndicator: true,
                              progressIndicatorColor: Colors.red,
                              progressColors: const ProgressBarColors(
                                playedColor: Colors.red,
                                handleColor: Colors.red,
                              ),
                              bottomActions: [
                                CurrentPosition(),
                                ProgressBar(
                                  isExpanded: true,
                                  colors: const ProgressBarColors(
                                    playedColor: Colors.red,
                                    handleColor: Colors.red,
                                    bufferedColor: Colors.white38,
                                    backgroundColor: Colors.white24,
                                  ),
                                ),
                                RemainingDuration(),
                              ],
                            ),
                          ],
                        ) : const SizedBox.shrink(),
                  
                        const SizedBox(height: 25,),
                  
                        widget.exerciseModel.longVideo.isNotEmpty && displayLongYoutubeVideo ? Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Long video explanation of the exercise",
                                  style: boldTextStyle.copyWith(fontSize: 18),
                                ),
                                IconButton(
                                  onPressed: () => _launchUrl(Uri.parse(widget.exerciseModel.longVideo)),
                                  icon: const Icon(
                                    Icons.open_in_new,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                            YoutubePlayer(
                              controller: longVideoController!,
                              showVideoProgressIndicator: true,
                              progressIndicatorColor: Colors.red,
                              progressColors: const ProgressBarColors(
                                playedColor: Colors.red,
                                handleColor: Colors.red,
                              ),
                              bottomActions: [
                                CurrentPosition(),
                                ProgressBar(
                                  isExpanded: true,
                                  colors: const ProgressBarColors(
                                    playedColor: Colors.red,
                                    handleColor: Colors.red,
                                    bufferedColor: Colors.white38,
                                    backgroundColor: Colors.white24,
                                  ),
                                ),
                                RemainingDuration(),
                              ],
                            ),
                          ],
                        ) : const SizedBox.shrink(),
                  
                      ],
                    ),
                  ),
                ) : const SizedBox.shrink(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
