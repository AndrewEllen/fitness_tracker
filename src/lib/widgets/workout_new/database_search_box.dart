import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:fitness_tracker/constants.dart';
import 'package:flutter/material.dart';
import 'package:fitness_tracker/models/workout/exercise_database_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
            tween: Tween<double>(begin: 0.0, end: _expandPanel ? 420.0.h : 0.0),
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
                child: _expandPanel ? Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Center(
                        child: widget.exerciseModel.mechanics.isNotEmpty ? Text(
                          widget.exerciseModel.mechanics + " Exercise",
                          style: boldTextStyle.copyWith(fontSize: 22),
                        ) : const SizedBox.shrink(),
                      ),

                      const SizedBox(height: 25,),

                      Center(
                        child: Transform.scale(
                          scale: 0.72.w,
                          child: Stack(
                            children: [
                              Transform.translate(
                                offset: const Offset(-130,0),
                                child: Stack(
                                  children: [


                                    Transform.scale(
                                      scale: 0.5,
                                      child: Transform.translate(
                                        offset: const Offset(-240, -149),
                                        child: CustomPaint(
                                          size: Size(diagramWidth, (diagramWidth*0.7561837477848735).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                                          painter: FrontAnatomyCustomPainterColour(
                                            chest: checkMuscle(["Pectoralis Major"]),
                                            abdominals: checkMuscle(["Rectus Abdominis"]),
                                            calves: checkMuscle(["Gastrocnemius", "Soleus"]),
                                            quadriceps: checkMuscle(["Quadriceps Femoris"]),
                                            anteriorDelts: checkMuscle(["Anterior Deltoids"]),
                                            midDelts: checkMuscle(["Medial Deltoids"]),
                                            obliques: checkMuscle(["Obliques"]),
                                            forearms: checkMuscle(["Brachioradialis"]),
                                            biceps: checkMuscle(["Biceps Brachii"]),
                                            serratusAnterior: checkMuscle(["Serratus Anterior"]),
                                            trapezius: checkMuscle(["Upper Trapezius"]),
                                          ),
                                        ),
                                      ),
                                    ),

                                    Transform.scale(
                                      scale: 1.88,
                                      child: Transform.translate(
                                        offset: const Offset(47, 45),
                                        child: CustomPaint(
                                          size: Size(diagramWidth, (diagramWidth*0.7561837477848735).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                                          painter: FrontAnatomyCustomPainter(),
                                        ),
                                      ),
                                    ),


                                  ],
                                ),
                              ),


                              Transform.translate(
                                offset: const Offset(130,0),
                                child: Stack(
                                  children: [

                                    Transform.scale(
                                      scale: 1.88,
                                      child: Transform.translate(
                                        offset: const Offset(47, 45),
                                        child: CustomPaint(
                                          size: Size(diagramWidth, (diagramWidth*0.7561837477848735).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                                          painter: BackAnatomyCustomPainter(),
                                        ),
                                      ),
                                    ),

                                    Transform.scale(
                                      scale: 0.5,
                                      child: Transform.translate(
                                        offset: const Offset(-240, -148),
                                        child: CustomPaint(
                                          size: Size(diagramWidth, (diagramWidth*0.7561837477848735).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                                          painter: BackAnatomyCustomPainterColour(
                                            upperTrapezius: checkMuscle(["Upper Trapezius"]),
                                            lowerTrapezius: checkMuscle(["Lower Trapezius"]),
                                            calves: checkMuscle(["Gastrocnemius", "Soleus"]),
                                            posteriorDeltoid: checkMuscle(["Posterior Deltoids"]),
                                            medialDeltoid: checkMuscle(["Medial Deltoids"]),
                                            hamstrings: checkMuscle(["Biceps Femoris"]),
                                            forearms: checkMuscle(["Brachioradialis"]),
                                            triceps: checkMuscle(["Triceps Brachii"]),
                                            erectorSpinea: checkMuscle(["Erector Spinae"]),
                                            glutes: checkMuscle(["Gluteus Maximus"]),
                                            latissimusDorsi: checkMuscle(["Latissimus Dorsi"]),
                                            infraspinatus: checkMuscle(["Infraspinatus", "Teres Major", "Teres Minor", "Subscapularis"]),
                                          ),
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ),


                            ],
                          ),
                        ),
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
                          widget.exerciseModel.primaryMuscle.isNotEmpty ? Text(
                            "- " + widget.exerciseModel.primaryEquipment + " x " + widget.exerciseModel.numPrimaryItems,
                            style: boldTextStyle,
                            textAlign: TextAlign.left,
                          ) : const SizedBox.shrink(),

                          widget.exerciseModel.secondaryMuscle.isNotEmpty ? Text(
                            "- " + widget.exerciseModel.secondaryEquipment + " x " + widget.exerciseModel.numSecondaryItems,
                            style: boldTextStyle,
                            textAlign: TextAlign.left,
                          ) : const SizedBox.shrink(),

                        ],
                      ),

                      const SizedBox(height: 25,),

                      widget.exerciseModel.shortVideo.isNotEmpty && displayShortYoutubeVideo ? YoutubePlayerBuilder(
                        player: YoutubePlayer(
                          controller: shortVideoController!,
                          showVideoProgressIndicator: true,
                          progressIndicatorColor: Colors.amber,
                          progressColors: const ProgressBarColors(
                            playedColor: Colors.amber,
                            handleColor: Colors.amberAccent,
                          ),
                        ),
                        builder: (context, player) {
                          return Column(
                            children: [
                              Text(
                                "Short video explanation of the exercise",
                                style: boldTextStyle.copyWith(fontSize: 18),
                              ),
                              player,
                            ],
                          );
                        },
                      ) : const SizedBox.shrink(),

                      const SizedBox(height: 25,),

                      widget.exerciseModel.longVideo.isNotEmpty && displayLongYoutubeVideo ? YoutubePlayerBuilder(
                        player: YoutubePlayer(
                          controller: longVideoController!,
                          showVideoProgressIndicator: true,
                          progressIndicatorColor: Colors.amber,
                          progressColors: const ProgressBarColors(
                            playedColor: Colors.amber,
                            handleColor: Colors.amberAccent,
                          ),
                        ),
                        builder: (context, player) {
                          return Column(
                            children: [
                              Text(
                                "Long video explanation of the exercise",
                                style: boldTextStyle.copyWith(fontSize: 18),
                              ),
                              player,
                            ],
                          );
                        },
                      ) : const SizedBox.shrink(),

                    ],
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
