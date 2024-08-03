import 'package:fitness_tracker/models/workout/exercise_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../models/workout/exercise_database_model.dart';
import 'muscle_anatomy_diagram_painter.dart';

class AnatomyDiagram extends StatelessWidget {
  AnatomyDiagram({Key? key, this.exerciseModel, this.exerciseDatabaseModel}) : super(key: key);
  ExerciseModel? exerciseModel;
  ExerciseDatabaseModel? exerciseDatabaseModel;


  Map checkMuscle(List<String> musclesToCheck) {

    if (exerciseModel != null) {
      if (musclesToCheck.contains(exerciseModel!.primaryMuscle?.trim() ?? false)) {
        return {
          "display": true,
          "colour": 0xffff0000
        };
      }
      if (musclesToCheck.contains(exerciseModel!.secondaryMuscle?.trim() ?? false)) {
        return {
          "display": true,
          "colour": 0xff2f00
        };
      }
      if (musclesToCheck.contains(exerciseModel!.tertiaryMuscle?.trim() ?? false)) {
        return {
          "display": true,
          "colour": 0xff5100
        };
      }

      if (musclesToCheck.contains(exerciseModel!.quaternaryMuscle?.trim() ?? false)) {
        return {
          "display": true,
          "colour": 0xff8000
        };
      }

      if (musclesToCheck.contains(exerciseModel!.quinaryMuscle?.trim() ?? false)) {
        return {
          "display": true,
          "colour": 0xffb300
        };
      }

      return {
        "display": false,
        "colour": 0xffff0000
      };

      /// Not really sure why I have an else statement here that then checks the same thing but I don't want to mess with it.
    } else {
      if (musclesToCheck.contains(exerciseDatabaseModel?.primaryMuscle.trim() ?? false)) {
        return {
          "display": true,
          "colour": 0xffff0000
        };
      }
      if (musclesToCheck.contains(exerciseDatabaseModel?.secondaryMuscle.trim() ?? false)) {
        return {
          "display": true,
          "colour": 0xffff5900
        };
      }
      if (musclesToCheck.contains(exerciseDatabaseModel?.tertiaryMuscle.trim() ?? false)) {
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
  }


  @override
  Widget build(BuildContext context) {
    return                         Center(
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
                        size: Size(300, (300*0.7561837477848735).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                        painter: FrontAnatomyCustomPainterColour(
                          chest: checkMuscle(["Pectoralis Major"]),
                          abdominals: checkMuscle(["Rectus Abdominis"]),
                          calves: checkMuscle(["Gastrocnemius", "Soleus", "Tibialis Anterior"]),
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
                        size: Size(300, (300*0.7561837477848735).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
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
                        size: Size(300, (300*0.7561837477848735).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                        painter: BackAnatomyCustomPainter(),
                      ),
                    ),
                  ),

                  Transform.scale(
                    scale: 0.5,
                    child: Transform.translate(
                      offset: const Offset(-240, -148),
                      child: CustomPaint(
                        size: Size(300, (300*0.7561837477848735).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
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
                          glutes: checkMuscle(["Gluteus Maximus", "Gluteus Medius", "Gluteus Minimus"]),
                          latissimusDorsi: checkMuscle(["Latissimus Dorsi"]),
                          infraspinatus: checkMuscle(["Infraspinatus", "Teres Major", "Teres Minor", "Subscapularis", "Rhomboids"]),
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
    );
  }
}
