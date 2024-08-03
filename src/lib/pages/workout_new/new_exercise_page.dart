import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fitness_tracker/models/workout/exercise_model.dart';
import 'package:fitness_tracker/pages/workout_new/exercise_database_search.dart';
import 'package:fitness_tracker/providers/workout/workoutProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/workout/reps_weight_stats_model.dart';
import '../../providers/general/database_write.dart';
import '../../providers/general/page_change_provider.dart';
import '../../widgets/general/app_default_button.dart';
import '../../widgets/general/app_dropdown_form.dart';
import '../../widgets/workout_new/anatomy_diagram.dart';

class NewExercisePage extends StatefulWidget {
  const NewExercisePage({Key? key}) : super(key: key);

  @override
  State<NewExercisePage> createState() => _NewExercisePageState();
}

class _NewExercisePageState extends State<NewExercisePage> {

  String? selectedValue;
  bool _newAdded = false;

  final GlobalKey<FormState> exerciseKey = GlobalKey<FormState>();
  final TextEditingController exerciseController = TextEditingController();

  final GlobalKey<FormState> categoriesKey = GlobalKey<FormState>();
  final TextEditingController categoriesController = TextEditingController();

  final GlobalKey<FormState> primaryMuscleKey = GlobalKey<FormState>();
  final TextEditingController primaryMuscleController = TextEditingController();

  final GlobalKey<FormState> secondaryMuscleKey = GlobalKey<FormState>();
  final TextEditingController secondaryMuscleController = TextEditingController();

  final GlobalKey<FormState> tertiaryMuscleKey = GlobalKey<FormState>();
  final TextEditingController tertiaryMuscleController = TextEditingController();

  final GlobalKey<FormState> quaternaryMuscleKey = GlobalKey<FormState>();
  final TextEditingController quaternaryMuscleController = TextEditingController();

  final GlobalKey<FormState> quinaryMuscleKey = GlobalKey<FormState>();
  final TextEditingController quinaryMuscleController = TextEditingController();

  final TextEditingController exerciseType = TextEditingController();

  late int typeDropDownMenuValue = 0;
  late int weightTypeDropDownMenuValue = 0;

  void changeCategoryIfExists() {
    if (exerciseMap[exerciseController.text] != null) {
      if (exerciseMap[exerciseController.text]!["target-muscle"]! == "") {
        categoriesController.text = "Other";
      } else {
        categoriesController.text =
        exerciseMap[exerciseController.text]!["target-muscle"]!;

        if (exerciseMap[exerciseController.text]!["target-muscle"]! ==
            "Cardio") {
          setState(() {
            typeDropDownMenuValue = 1;
            exerciseType.text = "Distance and Time";
          });
        } else {
          setState(() {
            typeDropDownMenuValue = 0;
            exerciseType.text = "Weight and Reps";
          });
        }
      }

      if (exerciseMap[exerciseController.text]!["primary-muscle"]!.isNotEmpty) {
        primaryMuscleController.text =
        exerciseMap[exerciseController.text]!["primary-muscle"]!;
      } else {
        primaryMuscleController.text = "";
      }

      if (exerciseMap[exerciseController.text]!["secondary-muscle"]!
          .isNotEmpty) {
        secondaryMuscleController.text =
        exerciseMap[exerciseController.text]!["secondary-muscle"]!;
      } else {
        secondaryMuscleController.text = "";
      }

      if (exerciseMap[exerciseController.text]!["tertiary-muscle"]!
          .isNotEmpty) {
        tertiaryMuscleController.text =
        exerciseMap[exerciseController.text]!["tertiary-muscle"]!;
      } else {
        tertiaryMuscleController.text = "";
      }

      if (exerciseMap[exerciseController.text]!["quaternary-muscle"]!
          .isNotEmpty) {
        quaternaryMuscleController.text =
        exerciseMap[exerciseController.text]!["quaternary-muscle"]!;
      } else {
        quaternaryMuscleController.text = "";
      }

      if (exerciseMap[exerciseController.text]!["quinary-muscle"]!.isNotEmpty) {
        quinaryMuscleController.text =
        exerciseMap[exerciseController.text]!["quinary-muscle"]!;
      } else {
        quinaryMuscleController.text = "";
      }
    }
  }


  List<String> exerciseList = <String>[
    "Stability Ball Dead Bug",
    "Glute Bridge",
    "Bird Dog",
    "Stability Ball Seated Russian Twist ",
    "Stability Ball Feet Elevated Crunch ",
    "Ring Hanging Knee Raise ",
    "Parallette Mountain Climber",
    "Parallette Push Up",
    "Knee Hover Bird Dog",
    "Stability Ball Pass",
    "Dead Bug",
    "Alternating Heel Taps",
    "Flutter Kicks",
    "Kneeling Plank",
    "Seated Ab Circles",
    "Ring Hanging Oblique Knee Raise",
    "Stability Ball Stir The Pot",
    "Alternating Side Kick Through",
    "Ring L Hang Flutter Kicks ",
    "Slam Ball Russian Twist",
    "Dumbbell Otis Up",
    "Single Arm Dumbbell Side Plank Reach Through ",
    "Ab Wheel Kneeling Rollout",
    "Cable Seated Crunch",
    "Cable Kneeling Crunch",
    "Medicine Ball V-Up",
    "Suspension Knee Tuck",
    "Suspension Lateral Knee Tuck",
    "Push Up Alternating Kick Through",
    "Single Arm Dumbbell Turkish Get Up",
    "Bear Crawl",
    "Stability Ball Knee Tuck",
    "Ring Hanging Leg Raise ",
    "Parallette L Sit",
    "Standing Walkout Plank",
    "Standing Walkout Push-Up ",
    "Barbell Climb",
    "Ipsilateral Bird Dog",
    "Copenhagen Plank Knee to Elbow",
    "Ring Dead Hang",
    "Suspension Archer Row ",
    "Suspension Alternating Archer Row Hold ",
    "Ring Pull Up Eccentrics ",
    "Ring Pull Up",
    "Ring Chin Up Eccentrics ",
    "Miniband Fire Hydrant",
    "Medicine Ball Russian Twist",
    "Side Plank",
    "Cable Reverse Ankle Strap Crunch",
    "Cable Half Kneeling High to Low Chop",
    "Cable Half Kneeling Low to High Chop",
    "Kettlebell Half Kneeling Low to High Chop",
    "Cable Half Kneeling Pallof Press",
    "Cable Standing High to Low Chop ",
    "Cable Standing Low to High Chop",
    "Single Arm Dumbbell Windmill",
    "Single Arm Kettlebell Windmill",
    "Kettlebell Russian Twist",
    "Feet On Wall Mountain Climber ",
    "Alternating Single Arm Kettlebell Plank Pull Through",
    "Hollow Body Hold",
    "Dumbbell Crush Grip Hollow Body Hold",
    "Inverted Hanging Crunch",
    "Inverted Hanging Oblique Crunch",
    "Single Arm Kettlebell Single Leg Standing Bent Knee Around The World ",
    "Supine Alternating Single Leg Raise",
    "Supine Leg Raise",
    "Miniband Bicycle Crunch",
    "Side Plank Reach Through",
    "Sit Up",
    "Butterfly Sit Up",
    "Slider Mountain Climber",
    "Slider Pike ",
    "Stability Ball Pike",
    "Slider Wide Mountain Climber",
    "Stability Ball Crunch",
    "Stability Ball Feet Elevated Oblique Crunch",
    "Stability Ball Kneeling Rollout",
    "Stability Ball Single Leg Knee Tuck",
    "Stability Ball Single Leg Pike",
    "Parallette Kneeling Push Up",
    "Single Arm Kettlebell Swing",
    "Dumbbell Romanian Deadlift",
    "Single Arm Dumbbell Side Plank",
    "Single Leg Glute Bridge",
    "Dumbbell Glute Bridge",
    "Glute Bridge Alternating Single Leg Extension",
    "Miniband Side Lying Clamshell",
    "Miniband Side Lying Hip Abduction",
    "Miniband Bench Seated Hip Abduction",
    "Miniband Glute Bridge With Hip Abduction",
    "Stability Ball Hip Thrust",
    "Stability Ball Dumbbell Hip Thrust",
    "Bodyweight Frog Pump",
    "Dumbbell Frog Pump",
    "Cable Glute Kickback",
    "Foot Elevated Single Leg Glute Bridge",
    "Suspension Glute Bridge",
    "Miniband Thigh Lateral Walk",
    "Miniband Shin Lateral Walk",
    "Miniband Feet Lateral Walk",
    "Miniband Standing Glute Kickback",
    "Barbell Hip Thrust",
    "Barbell Single Leg Hip Thrust",
    "Stability Ball Single Leg Glute Bridge",
    "Miniband Standing Hip Abduction",
    "Miniband 3-Way Cha Cha",
    "Barbell Standing Calf Raise",
    "Cable Hip Abduction",
    "Miniband Wall Sit Hip Abduction",
    "Barbell Overhead Adductor Slide",
    "Stability Ball T's Y's I's ",
    "Resistance Band Standing Reverse Fly",
    "Resistance Band Lateral Raise",
    "Dumbbell Lateral Raise",
    "Single Arm Resistance Band Standing Shoulder External Rotation",
    "Dumbbell Seated Lateral Raise",
    "Pike Push Up",
    "Single Arm Dumbbell Side Lying Shoulder External Rotation",
    "Single Arm Dumbbell Seated Shoulder External Rotation",
    "Miniband Standing Shoulder External Rotation",
    "Dumbbell Seated Cuban Rotation",
    "Dumbbell Standing Cuban Rotation",
    "Single Arm Cable Half Kneeling Shoulder External Rotation 90 Degrees",
    "Single Arm Dumbbell Side Lying Shoulder Internal Rotation",
    "Parallette Feet Elevated Pike Push Up ",
    "Barbell Thruster",
    "Parallette Wall Supported Handstand Push Up",
    "Barbell Sots Press",
    "Single Arm Dumbbell V Sit Shoulder Press ",
    "Dumbbell Z Press",
    "Single Arm Dumbbell Z Press",
    "Stability Ball Dumbbell Arnold Press",
    "Single Arm Dumbbell Half Kneeling Overhead Press",
    "Single Arm Cable Lateral Raise",
    "Dumbbell Thruster",
    "Single Arm Dumbbell Thruster",
    "Parallette Handstand Push Up",
    "Dumbbell Seated Overhead Press",
    "Dumbbell Overhead Press",
    "Single Arm Dumbbell Overhead Carry",
    "Freestanding Handstand Push Up",
    "Barbell Shrug",
    "Dumbbell Shrug",
    "Cable Standing Face Pull",
    "Cable Seated Face Pull",
    "Dumbbell Standing Scaption",
    "Dumbbell Seated Scaption",
    "Stability Ball Dumbbell Seated Scaption",
    "Cable Standing Knee Strap Hip External Rotation (90 Degrees)",
    "Cable Hip External Rotation",
    "Dumbbell Bicep Curl",
    "Dumbbell Alternating Bicep Curl",
    "Dumbbell Alternating Hammer Curl",
    "Dumbbell Alternating Cross Body Hammer Curl",
    "Cable Guillotine Curl",
    "Cable Supine Bicep Curl",
    "Single Arm Dumbbell Incline Bench Preacher Curl",
    "Dumbbell Crush Grip Bicep Curl",
    "Dumbbell Zottman Curl",
    "Dumbbell Waiter Curl",
    "High Cable Straight Bar Bicep Curl",
    "Cable Straight Bar Drag Curl",
    "Dumbbell Spider Curl",
    "EZ Bar Spider Curl",
    "Parallette Side Plank",
    "Parallette Feet Elevated Push Up",
    "Parallette Side Plank Reach Through",
    "Parallette Plank Single Arm Dumbbell Row",
    "Stability Ball Cable Preacher Curl",
    "Single Arm Dumbbell Standing Concentration Curl",
    "Reverse Barbell Curl",
    "EZ Bar Standing Bicep Curl",
    "Cable Rope Hammer Curl",
    "Single Arm Cable Standing High Bicep Curl",
    "Suspension Bicep Curl",
    "Dumbbell Standing Tricep Kickback",
    "EZ Bar Seated Overhead Tricep Extension",
    "EZ Bar Standing Overhead Tricep Extension",
    "Dumbbell Seated Overhead Tricep Extension",
    "Dumbbell Standing Overhead Tricep Extension",
    "Diamond Push Up",
    "Dumbbell Close Grip Floor Chest Press",
    "Dumbbell Close Grip Bench Press",
    "Dumbbell Close Grip Incline Bench Press",
    "EZ Bar Lying Tricep Extension ",
    "Stability Ball Feet Elevated Diamond Push Up",
    "Bodyweight Tricep Extension",
    "Cable Rope Standing Overhead Tricep Extension",
    "Cable Rope Standing Tricep Pushdown ",
    "Ring Dips",
    "Single Arm Cable Reverse Tricep Pulldown",
    "Dumbbell Suitcase Carry",
    "Barbell Seated Wrist Curl",
    "EZ Bar Reverse Curl",
    "Incline Push Up",
    "Kneeling Push Up",
    "Suspension Chest Press",
    "Suspension Chest Fly",
    "Dumbbell Glute Bridge Chest Press",
    "Stability Ball Single Arm Dumbbell Chest Press",
    "Stability Ball Dumbbell Chest Fly",
    "Burpee",
    "Dumbbell Devil Press",
    "Alternating Single Arm Dumbbell Devil Press",
    "Single Arm Dumbbell Hollow Body Chest Press",
    "Plyometric Push Up On Weight Plates",
    "Stability Ball Dumbbell Pullover ",
    "Dumbbell Incline Bench Chest Fly",
    "Single Arm Push Up",
    "Aztec Push Up",
    "Single Arm Ring Grip Push Up",
    "Rolling Squat Burpee",
    "Ring Grip Push Up",
    "Suspension Low Row",
    "Suspension Mid Row",
    "Suspension Face Pull",
    "Cable Seated V Grip Low Row",
    "Landmine V Grip Row",
    "Single Arm Landmine Row",
    "Single Arm Kettlebell Bent Over Row",
    "Double Kettlebell Gorilla Row",
    "Superband Assisted Wide Grip Pull Up",
    "Resistance Band Half Kneeling Face Pull",
    "Single Arm Dumbbell Single Leg Contralateral Bent Over Row",
    "Stability Ball Prone Cobra",
    "Prone Cobra",
    "Dumbbell Pendlay Row",
    "Dumbbell Single Leg Row",
    "Cable Straight Bar Pullover",
    "Single Arm Dumbbell Bird Dog Row",
    "Single Arm Cable Half Kneeling Lat Pulldown",
    "Single Arm Cable Half Kneeling Low Row",
    "Single Arm Suspension Row",
    "Single Arm Dumbbell Suitcase Deadlift",
    "Single Arm Kettlebell Suitcase Deadlift",
    "Dumbbell Incline Bench Prone Row",
    "Ring Archer Pull Up",
    "Dumbbell Renegade Row ",
    "Barbell Conventional Deadlift",
    "Barbell Sumo Deadlift",
    "Barbell Rack Pull",
    "Barbell Snatch Grip Deadlift",
    "Barbell Pendlay Row",
    "Stability Ball Hyperextension",
    "Barbell Seated Good Morning ",
    "Barbell Good Morning",
    "Wall Sit ",
    "Wall Slide Squat",
    "Stability Ball Wall Slide Squat",
    "Suspension Squat",
    "Suspension Alternating Reverse Lunge",
    "Bodyweight Squat to Bench",
    "Bodyweight Squat",
    "Assisted Bodyweight Split Squat",
    "Bodyweight Walking Lunge",
    "Dumbbell Goblet Squat ",
    "Miniband Romanian Deadlift",
    "Superband Resisted Skater Jump",
    "Cable Prone Single Leg Hamstring Curl",
    "Candlestick Roll Up Tuck Jump",
    "Barbell Bench Press",
    "Barbell Bicep Curl",
    "Barbell Block Pull Deadlift",
    "Barbell Box Pause Back Squat",
    "Barbell Deficit Deadlift",
    "Barbell Front Squat",
    "Barbell Glute Bridge",
    "Barbell Halting Deadlift",
    "Barbell High Bar Back Squat",
    "Barbell Low Bar Back Squat",
    "Barbell Overhead Press",
    "Barbell Power Clean",
    "Barbell Power Snatch",
    "Barbell Push Press",
    "Barbell Romanian Deadlift",
    "Barbell Row",
    "Barbell Back Rack Split Squat",
    "Barbell Stiff Legged Deadlift",
    "Barbell Sumo Squat",
    "Bodyweight Pistol Squat",
    "Bodyweight Skater Squat",
    "Cable Pull Through",
    "Dumbbell Suitcase Bulgarian Split Squat",
    "Single Arm Dumbbell Contralateral Overhead Step Up",
    "Dumbbell Suitcase Deficit Split Squat",
    "Dumbbell Suitcase Alternating Forward Lunge",
    "Dumbbell Suitcase Alternating Reverse Lunge",
    "Dumbbell Seated Reverse Fly",
    "Dumbbell Suitcase Split Squat",
    "Dumbbell Suitcase Box Step Up",
    "Face the Wall Squat",
    "Feet Elevated Glute Bridge",
    "Single Arm Kettlebell Clean",
    "Single Arm Kettlebell Clean to Overhead Press",
    "Kettlebell Alternating Halo",
    "Single Arm Kettlebell Overhead Press",
    "Single Arm Kettlebell Snatch",
    "Kettlebell Sumo Deadlift",
    "Single Arm Kettlebell Turkish Get Up",
    "Miniband Monster Walk",
    "Quadruped Hip Extension",
    "Suspension Pistol Squat",
    "Suspension Skater Squat",
    "Tuck Jump",
    "Alternating Single Leg Wall Sit",
    "Single Leg Romanian Deadlift Jump",
    "Double Dumbbell Overhead Walking Lunge",
    "Stability Ball Overhead Walking Lunge",
    "Stability Ball Dumbbell Suitcase Bulgarian Split Squat",
    "Bodyweight Leg Extension",
    "Lateral Bench Jump",
    "Single Arm Dumbbell Front Rack Squat",
    "Skater Jump",
    "Slider Single Arm Dumbbell Front Rack Reverse Lunge",
    "Cable Prone Hamstring Curl",
    "Bulgarian Split Squat Jumps",
    "Cable Standing Single Leg Hamstring Curl",
    "Nordic Hamstring Curl",
    "Superband Assisted Pistol Squat",
    "Kettlebell Goblet Squat",
    "Dumbbell Front Squat",
    "Dumbbell Suitcase Walking Lunge",
    "Barbell Back Rack Walking Lunge",
    "Box Pistol Squat",
    "Barbell Overhead Squat",
    "Single Arm Kettlebell Overhead Squat",
    "Dumbbell Suitcase Split Squat",
    "Landmine Goblet Squat",
    "Stability Ball Hamstring Curl",
    "Slider Hamstring Curl",
    "Hamstring Walkout ",
    "Slider Dumbbell Goblet Reverse Lunge",
    "Dragon Pistol Squat",
    "Single Arm Dumbbell Front Rack Cossack Squat to Overhead Press",
    "Stability Ball Single Leg Hamstring Curl",
    "Barbell Single Leg Romanian Deadlift",
    "Dumbbell Suitcase Lateral Lunge",
    "Barbell Frankenstein Walking Lunge",
    "Barbell Overhead Walking Lunge",
    "Barbell Overhead Lateral Lunge",
    "Barbell Squat Clean",
    "Landmine Clean and Jerk",
    "Landmine Hack Squat",
    "Single Arm Landmine Shoulder Press",
    "Alternating Single Arm Landmine Shoulder Press",
    "Single Arm Landmine Half Kneeling Shoulder Press",
    "Single Arm Landmine Tall Kneeling Shoulder Press",
    "Single Arm Landmine Meadows Row",
    "Single Arm Landmine Z Press",
    "Barbell Z Press",
    "Landmine Half Kneeling Oblique Twist ",
    "Cable Seated Bicep Curl",
    "Single Arm Dumbbell Seated Concentration Curl",
    "Dumbbell Incline Bench Alternating Bicep Curl",
    "Single Arm Suspension Bicep Curl",
    "Stability Ball Single Arm Plank",
    "Stability Ball Feet Elevated Single Arm Plank",
    "Landmine Zercher Skater Squat",
    "Landmine Reverse Lunge to Single Arm Shoulder Press",
    "Landmine Thruster",
    "Landmine Romanian Deadlift",
    "Landmine Single Leg Romanian Deadlift",
    "Landmine Tall Kneeling Oblique Twist",
    "Landmine Russian Twist",
    "Single Arm Landmine Thruster",
    "Landmine Calf Raise",
    "Cable Tall Kneeling Overhead Tricep Extension ",
    "Cable Rope Skullcrusher",
    "Barbell Clean to Overhead Press",
    "Single Arm Dumbbell Seated Cuban Press",
    "Landmine Zercher Curtsy Lunge",
    "Barbell Back Rack Cossack Squat",
    "Barbell Overhead Cossack Squat",
    "Barbell Front Rack Alternating Cossack Squat",
    "Kettlebell Goblet Cossack Squat",
    "Dumbbell Goblet Cossack Squat",
    "Bodyweight Cossack Squat",
    "Bodyweight Knee Over Toes Split Squat ",
    "Barbell Back Rack Knee Over Toes Split Squat",
    "Barbell Front Rack Knee Over Toes Split Squat",
    "Barbell Overhead Knee Over Toes Split Squat",
    "Single Arm Barbell Overhead Press",
    "Barbell Single Leg Bent Knee Bicep Curl",
    "Slider Knee Tuck",
    "Wall Facing Handstand",
    "Freestanding Handstand ",
    "Suspension Atomic Push Up",
    "Suspension Pike",
    "Suspension Side Plank Reach Through",
    "Cocoon Crunch",
    "Ab Wheel Standing Rollout",
    "Cable Fire Hydrant",
    "Cable Tall Kneeling Pull Through",
    "Stability Ball Bent Knee Reverse Hyperextension",
    "Bent Knee Reverse Hyperextension on Bench",
    "Parallette Tuck L Sit",
    "Parallette Close Grip Push Up",
    "Parallette Feet Elevated Close Grip Tricep Push Up",
    "Parallette Single Leg L Sit",
    "Stability Ball Bottoms Up",
    "Stability Ball Windshield Wiper",
    "Stability Ball Tall Kneeling Balance",
    "Stability Ball Oblique Crunch ",
    "Stability Ball Elbow Plank",
    "Double Kettlebell Feet Elevated Push Up",
    "Single Arm Kettlebell Turkish Sit Up",
    "Single Arm Dumbbell Turkish Sit Up",
    "Single Arm Landmine Turkish Sit Up",
    "Double Kettlebell Turkish Sit Up",
    "Double Dumbbell Turkish Sit Up",
    "Double Kettlebell Turkish Sit Up to Z Press",
    "Double Kettlebell Front Rack Alternating Cossack Squat",
    "Double Dumbbell Front Rack Alternating Cossack Squat",
    "Double Kettlebell Swing",
    "Double Kettlebell Front Rack Squat",
    "Single Arm Kettlebell Front Rack Squat",
    "Single Arm Kettlebell Front Rack Split Squat",
    "Single Arm Kettlebell Front Rack Carry",
    "Single Arm Kettlebell Front Rack Alternating Cossack Squat",
    "Single Arm Kettlebell Squat Clean",
    "Stability Ball Feet Elevated Parallette Push Up",
    "Stability Ball Feet Elevated Parallette Plank",
    "Stability Ball Feet Elevated Single Arm Parallette Plank",
    "Stability Ball Feet Elevated Alternating Single Arm Parallette Plank",
    "Archer Push Up",
    "Parallette Archer Push Up",
    "Parallette Wide Push Up",
    "Dumbbell Suitcase Knee Over Toes Split Squat",
    "Dumbbell Alternating Front Raise",
    "Barbell Front Raise",
    "Single Arm Cable Front Raise",
    "Cable Straight Bar Front Raise",
    "Cable Half Kneeling Pallof Press",
    "Kettlebell Bottoms Up Horn Grip Standing Bicep Curl",
    "Single Arm Kettlebell Bottoms Up Front Rack Carry",
    "Double Kettlebell Bottoms Up Front Rack Carry",
    "Double Kettlebell Bottoms Up Overhead Walking Lunge",
    "Single Arm Kettlebell Bottoms Up Front Rack Walking Lunge",
    "Single Arm Kettlebell Half Kneeling Contralateral Bottoms Up Overhead Press",
    "Barbell Kneeling Rollout",
    "Barbell Close Grip Bench Press",
    "Single Arm Suspension Chest Press",
    "Cable Tall Kneeling Pallof Press",
    "Single Arm Cable Bicep Curl",
    "Cable Reverse Straight Bar Curl",
    "Single Arm Cable Shotgun Row",
    "Barbell Hang Power Clean",
    "Landmine Goblet Cossack Squat",
    "Landmine Low Handle Cossack Squat",
    "Ring Shoulder Stand",
    "Ring Strap Handstand",
    "Ring Handstand",
    "Pike Headstand Push Up",
    "Feet Elevated Pike Headstand Push Up",
    "Wall Headstand Push Up",
    "Freestanding Headstand Push Up",
    "Ring Bulgarian Handstand Push Up",
    "Ring Strap Handstand Push Up",
    "Ring Freestanding Handstand Push Up",
    "Bent Arm Press Handstand",
    "Parallette L Sit to Bent Arm Press Handstand",
    "Chest Roll to Straight Body Press Handstand",
    "Ring Bent Arm Bent Body Press Handstand",
    "Ring Dip to Handstand",
    "Ring Handstand to Elbow Lever to Handstand",
    "Ring Dip Straight Body Press to Handstand",
    "Wall Straddle Press Handstand Eccentrics",
    "Straddle Stand Press Handstand ",
    "Pike Stand Press Handstand",
    "Parallette L Sit Straddle Press Handstand",
    "Parallette L Sit Pike Press Handstand",
    "Ring Straight Arm L Sit Straddle Press Handstand",
    "Ring Straight Arm Pike Press Handstand",
    "Tuck L Sit",
    "Parallette Straddle L Sit",
    "Ring Turned Out L Sit",
    "Ring Skin The Cat",
    "Manna ",
    "Ring Tuck Back Lever",
    "Ring Advanced Tuck Back Lever",
    "Ring Straddle Back Lever",
    "Ring Half Layout Back Lever",
    "Ring 1 Leg Out Back Lever",
    "Ring Full Back Lever",
    "Ring Back Lever Pullout",
    "Ring German Hang Pullout",
    "Ring Handstand Lower to Back Lever",
    "Ring Tuck Front Lever",
    "Ring Advanced Tuck Front Lever",
    "Ring Straddle Front Lever",
    "Ring Half Layout Front Lever",
    "Ring 1 Leg Out Front Lever",
    "Ring Full Front Lever",
    "Ring Front Lever Pull to Inverted Hang",
    "Ring Inverted Hang",
    "Single Arm Barbell Kneeling Rollout",
    "Single Arm Barbell Standing Rollout",
    "Ring Circle Front Lever",
    "Ring Tuck Front Lever Pull Up",
    "Ring Advanced Tuck Front Lever Pull Up",
    "Ring Straddle Front Lever Pull Up",
    "Ring Dead Hang to Front Lever Pull Up",
    "Ring Full Front Lever Pull Up",
    "Ring Row Feet Elevated",
    "Ring Bulgarian Row Feet Elevated",
    "Ring Archer Row Feet Elevated",
    "Single Arm Ring Row Feet Elevated ",
    "Ring L Sit Pull Up",
    "Ring Bulgarian Pull Up",
    "Ring Bulgarian L Sit Pull Up",
    "Ring Plank",
    "Single Arm Ring Plank",
    "Ring Push Up",
    "Single Arm Ring Push Up",
    "Ring Support Hold",
    "Ring Side Plank",
    "Ring L Sit Muscle Up",
    "Ring Strict Muscle Up",
    "Ring Chest Fly",
    "Single Arm Barbell Bicep Curl",
    "Hollow Rock ",
    "Single Arm Dumbbell Power Snatch",
    "Alternating Single Arm Dumbbell Power Snatch",
    "Single Arm Dumbbell Squat Snatch",
    "Alternating Single Arm Dumbbell Squat Snatch",
    "Single Arm Cable Single Leg Romanian Deadlift",
    "Double Kettlebell Single Leg Romanian Deadlift ",
    "Double Kettlebell Romanian Deadlift ",
    "Single Arm Kettlebell Single Leg Romanian Deadlift",
    "Cable Wide Grip Lat Pulldown",
    "Cable Reverse Grip Lat Pulldown",
    "Cable Seated V Grip Lat Pulldown",
    "Cable Half Kneeling Face Pull",
    "Single Arm Landmine Half Knee Hover Shoulder Press",
    "Dumbbell Seated Good Morning",
    "Bodyweight Hip Thrust",
    "Single Arm Kettlebell Bottoms Up Overhead Squat",
    "Stability Ball Dumbbell Seated Alternating Lateral Raise",
    "Single Arm Dumbbell Bench Press",
    "Dumbbell Bench Press",
    "Dumbbell Incline Bench Press",
    "Stability Ball Dumbbell W Raise",
    "Ring Side Plank Reach Through",
    "Single Arm Dumbbell Contralateral Overhead Bulgarian Split Squat",
    "Single Arm Dumbbell Contralateral Overhead Knee Over Toes Split Squat",
    "Double Kettlebell Z Press",
    "Double Kettlebell Clean",
    "Double Kettlebell Snatch",
    "Double Kettlebell Push Press",
    "Double Kettlebell Split Jerk",
    "Double Kettlebell Clean and Jerk",
    "Double Kettlebell High Pull",
    "Double Kettlebell Sumo Deadlift",
    "Double Kettlebell Bent Over Row",
    "Double Kettlebell Bottoms Up Front Rack Squat",
    "Double Kettlebell Front Rack Knee Over Toes Split Squat",
    "Double Kettlebell Overhead Knee Over Toes Split Squat",
    "Double Kettlebell Thruster",
    "Double Kettlebell Bottoms Up Front Rack Alternating Cossack Squat",
    "Double Kettlebell Bottoms Up Overhead Alternating Cossack Squat",
    "Double Kettlebell Tall Kneeling Overhead Press",
    "Double Kettlebell Front Rack Walking Lunge",
    "Double Kettlebell Overhead Walking Lunge",
    "Double Kettlebell Alternating Sots Press",
    "Double Kettlebell Shrug",
    "Double Kettlebell Hang Squat Clean",
    "Double Kettlebell Hollow Hold",
    "Double Kettlebell Hollow Hold With Flutter Kick",
    "Double Kettlebell Dead Clean to Push Press",
    "Double Kettlebell Pendlay Row",
    "Double Kettlebell Front Rack Split Squat",
    "Double Kettlebell Front Rack Bulgarian Split Squat",
    "Double Kettlebell Overhead Squat",
    "Double Kettlebell Half Kneeling Overhead Press",
    "Double Kettlebell Front Rack Cyclist Squat",
    "Double Kettlebell Front Rack Reverse Lunge",
    "Double Kettlebell Front Rack Step Up",
    "Single Arm Kettlebell Contralateral Overhead Knee Over Toes Split Squat",
    "Single Arm Kettlebell Dead Clean to Rotational Overhead Press",
    "Single Arm Kettlebell Rotational Overhead Press",
    "Single Arm Kettlebell Sumo Deadlift",
    "Single Arm Kettlebell Contralateral Front Rack Knee Over Toes Split Squat",
    "Single Arm Kettlebell Push Press",
    "Single Arm Kettlebell Push Jerk",
    "Single Arm Kettlebell Seated Overhead Press",
    "Single Arm Kettlebell Z Press",
    "Single Arm Kettlebell Contralateral Split Squat Thruster",
    "Double Kettlebell Split Squat Thruster",
    "Kettlebell Swing",
    "Alternating Single Arm Kettlebell Swing",
    "Alternating Single Arm Kettlebell Clean",
    "Alternating Single Arm Kettlebell Snatch",
    "Single Arm Kettlebell Sots Press",
    "Single Arm Kettlebell Bottoms Up Contralateral Overhead Knee Over Toes Split Squat",
    "Single Arm Kettlebell Staggered Stance Swing",
    "Alternating Single Arm Kettlebell Staggered Stance Swing",
    "Single Arm Kettlebell Half Kneeling Swing",
    "Single Arm Kettlebell Half Kneeling Contralateral Bottoms Up Press",
    "Double Kettlebell Outside Swing",
    "Double Kettlebell Outside Snatch",
    "Double Kettlebell Outside Clean",
    "Double Kettlebell Outside Clean and Press",
    "Single Arm Kettlebell Side Swing",
    "Parallette Push Up With Alternating Shoulder Taps",
    "Parallette Tuck Planche",
    "Parallette Dive Bomber Push Up",
    "Dive Bomber Push Up",
    "Parallette L Sit to Tuck Planche",
    "Double Dumbbell Prone Row",
    "Landmine Standing Oblique Twist",
    "Cable Tall Kneeling High to Low Chop",
    "Single Arm Parallette Plank",
    "Single Arm Suspension Plank",
    "Battle Rope Russian Twist",
    "Bird Dog Knee to Elbow",
    "Slam Ball Russian Twist Feet Elevated",
    "Medicine Ball Russian Twist Feet Elevated",
    "Kettlebell Feet Elevated Russian Twist",
    "Parallette Plank Alternating Knee to Elbow",
    "Forearm Plank Knee to Elbow",
    "Loaded Beast to Alternating Kick Through",
    "Ring False Grip Pull Up",
    "Single Arm Kettlebell Clean to Press Windmill",
    "Single Arm Kettlebell Half Kneeling Windmill",
    "Battle Rope Russian Twist Feet Elevated",
    "Superband Dead Bug",
    "Parallette V Sit",
    "Parallette Tuck V Sit",
    "Barbell Staggered Stance Push Press",
    "Double Kettlebell Front Rack Skater Squat",
    "Kettlebell Goblet Skater Squat",
    "Double Kettlebell Front Rack Pistol Squat to Box",
    "Double Kettlebell Front Rack Pistol Squat",
    "Double Kettlebell Overhead Alternating Reverse Lunge",
    "Superband Standing Pallof Press",
    "Superband Half Kneeling Pallof Press",
    "Superband Hip External Rotation (90 Degree)",
    "Barbell Prone Row",
    "Dumbbell Renegade Row Push Up",
    "Single Arm Landmine Row to Rotational Press",
    "Assisted Skater Squat",
    "Superband Pull Through",
    "Miniband Quadruped Hip Extension",
    "Cable Hip Adduction",
    "Superband Tall Kneeling Pallof Press",
    "Slider Eccentric Hamstring Curl",
    "Landmine Lateral Lunge",
    "Double Kettlebell Renegade Row ",
    "Single Arm Dumbbell Cuban Press",
    "Slider Parallette Knee Tuck",
    "Barbell Supinated Shoulder Front Raise",
    "Ring Pike Feet Elevated Handstand Push Up",
    "Parallette Straddle Press to Handstand",
    "Ring L Sit",
    "Ring Tuck Back Lever With Alternating Single Leg Extensions",
    "Ring Tuck Front Lever With Alternating Single Leg Extensions",
    "Single Arm Kettlebell Hollow Hold With Flutter Kick",
    "Single Arm Kettlebell Front Rack Cyclist Squat",
    "Barbell Back Cyclist Squat",
    "Inverted Crunch With Gravity Boots",
    "Double Kettlebell Renegade Row Push Up",
    "Bird Dog Single Arm Kettlebell Row",
    "Barbell Back Rack Step Up",
    "Barbell Front Rack Step Up",
    "Barbell Standing Rollout",
    "Stability Ball Cable Russian Twist",
    "Miniband Frog Pump",
    "Miniband Knee Hover Quadruped Fire Hydrant",
    "Fire Hydrant",
    "Knee Hover Quadruped Fire Hydrant",
    "Barbell Seated Reverse Wrist Curl",
    "Seated Wall Angels",
    "Bent Knee Copenhagen Plank Side Raise",
    "Kneeling Side Plank",
    "Assisted Hip Airplane",
    "Superband Single Leg Ankle Dorsiflexion",
    "Barbell Zercher Squat",
    "Barbell Squat Snatch",
    "Barbell Push Jerk",
    "Barbell Clean and Jerk",
    "Barbell Incline Bench Press",
    "Barbell Hang Squat Clean Thruster",
    "Barbell Squat Clean Thruster",
    "Copenhagen Plank",
    "Bent Knee Copenhagen Plank",
    "Parallette Kneeling Close Grip Tricep Push Up",
    "Miniband Single Leg Hip Thrust",
    "Barbell Deficit Snatch Grip Deadlift",
    "Single Arm Ring Chin Up Eccentrics",
    "Assisted Foot Elevated Knee Over Toes Split Squat",
    "Foot Elevated Knee Over Toes Split Squat",
    "Double Kettlebell Clean to Overhead Press",
    "Single Arm Kettlebell Bent Leg Windmill",
    "Kettlebell Alternating Halo to Goblet Squat",
    "Single Arm Kettlebell Half Kneeling Overhead Press",
    "Double Kettlebell Seesaw Press",
    "Single Arm Kettlebell Side to Side Swing",
    "Single Arm Kettlebell Half Kneeling Clean to Side Press",
    "Parallette Feet Elevated Pike Push Up",
    "Parallette Handstand",
    "Parallette L Sit to Handstand",
    "Ring Straddle L Sit",
    "Parallette Stalder Press to Handstand",
    "Ring Gironda Sternum Chin Up",
    "Ring Archer Push Up",
    "Single Arm Ring Chin Up",
    "Ring L Sit Archer Pull Up",
    "Alternating Single Arm Parallette Push Up",
    "Dumbbell Incline Bench Prone Y Raise",
    "Single Arm Cable Kneeling Shoulder External Rotation",
    "Suspension Face Pull to Overhead Press",
    "Superband Assisted Muscle Up",
    "Stability Ball Sit Up",
    "Single Arm Kettlebell Bottoms Up Turkish Get Up",
    "Single Arm Kettlebell Thruster",
    "Alternating Double Kettlebell Thruster",
    "Ring Scapular Pull Up",
    "Side Lying Hip Adduction",
    "Superband Hollow Body Hold",
    "Suspension Y Raise",
    "Slider Single Leg Eccentric Hamstring Curl ",
    "Barbell Reverse Grip Bench Press",
    "Dumbbell Reverse Grip Bench Press",
    "Side Plank Superband Hanging Adduction",
    "Single Arm Cable Seated Floor Lat Pulldown",
    "Single Arm Resistance Band Half Kneeling Cuban Press",
    "Stability Ball Feet Elevated Frog Pump",
    "Stability Ball Feet Elevated Frog Pump With Miniband",
    "Single Arm Kettlebell Bottoms Up Clean to Overhead Press",
    "Barbell Overhead Cyclist Squat",
    "Barbell Front Rack Cyclist Squat",
    "Single Arm Kettlebell Overhead Cyclist Squat",
    "Dumbbell Cuban Press",
    "Barbell Cyclist Thruster",
    "Single Arm Kettlebell Tactical Snatch",
    "Alternating Single Arm Landmine Thruster",
    "Single Arm Dumbbell Cyclist Thruster",
    "Alternating Single Arm Landmine Cyclist Thruster",
    "Barbell Low Bar Cyclist Squat",
    "Barbell Low Bar Pause Cyclist Squat",
    "Single Arm Kettlebell Snatch to Overhead Reverse Lunge",
    "Double Kettlebell Snatch to Overhead Reverse Lunge",
    "Single Arm Kettlebell Clean to Front Rack Reverse Lunge",
    "Double Kettlebell Clean to Front Rack Reverse Lunge",
    "Single Arm Kettlebell Split Jerk",
    "Alternating Single Arm Kettlebell Split Jerk",
    "Kettlebell Swing to Bottoms Up Horn Grip Goblet Squat",
    "Double Kettlebell Bottoms Up Clean to Front Rack Squat",
    "Double Kettlebell Bottoms Up Overhead Squat",
    "Double Kettlebell Bottoms Up Thruster",
    "Single Arm Kettlebell Bottoms Up Tactical Snatch ",
    "Single Arm Kettlebell Bottoms Up Z Press",
    "Double Kettlebell Bottoms Up Z Press",
    "Double Kettlebell Sots Press",
    "Alternating Double Kettlebell Sots Press",
    "Single Arm Kettlebell Bottoms Up Sots Press",
    "Double Kettlebell Bottoms Up Sots Press",
    "Alternating Double Kettlebell Bottoms Up Sots Press",
    "Double Kettlebell Seesaw Sots Press",
    "Double Kettlebell Bottoms Up Seesaw Sots Press",
    "Alternating Double Kettlebell Z Press",
    "Double Kettlebell Seesaw Z Press",
    "Double Kettlebell Bottoms Up Seesaw Press",
    "Double Kettlebell Bottoms Up Seesaw Z Press",
    "Double Kettlebell Bottoms Up Snatch",
    "Alternating Single Arm Kettlebell Bottoms Up Snatch",
    "Alternating Single Arm Kettlebell Around the World High Catch",
    "Alternating Single Arm Kettlebell Tall Kneeling Around the World High Catch",
    "Single Arm Kettlebell Around the World",
    "Alternating Single Arm Kettlebell Around the World",
    "Single Arm Kettlebell Tall Kneeling Around the World",
    "Alternating Single Arm Tall Kneeling Around the World",
    "Single Arm Kettlebell Waiter Clean",
    "Single Arm Kettlebell Waiter Clean Hot Potato",
    "Alternating Single Arm Kettlebell Waiter Clean",
    "Double Kettlebell Waiter Clean",
    "Kettlebell Swing to Alternating Single Arm Waiter Hold",
    "Double Kettlebell Waiter Clean to Overhead Press",
    "Single Arm Kettlebell Tactical Waiter Clean",
    "Single Arm Kettlebell Tactical Waiter Clean to Overhead Press",
    "Double Kettlebell Waiter Clean to Alternating Overhead Press",
    "Single Arm Kettlebell Waiter Snatch",
    "Alternating Single Arm Kettlebell Waiter Snatch",
    "Single Arm Kettlebell Tactical Waiter Snatch",
    "Double Kettlebell Waiter Snatch",
    "Double Kettlebell Waiter Clean to Thruster",
    "Kettlebell Start Stop Swing",
    "Double Kettlebell Dead Clean",
    "Single Arm Kettlebell Half Kneeling Side Press",
    "Single Arm Kettlebell Bottoms Up Thruster",
    "Alternating Double Kettlebell Bottoms Up Thruster",
    "Single Arm Kettlebell Dead Clean",
    "Alternating Single Arm Kettlebell Dead Clean",
    "Double Kettlebell Push Up to L Sit",
    "Parallette Push Up to L Sit",
    "Single Arm Kettlebell Bottoms Up Half Kneeling Windmill",
    "Alternating Single Arm Kettlebell Half Kneeling Around the World High Catch",
    "Single Arm Kettlebell Start Stop Squat Clean Thruster",
    "Alternating Single Arm Kettlebell Start Stop Squat Clean Thruster",
    "Double Kettlebell Start Stop Squat Clean Thruster",
    "Barbell Single Leg Standing Bent Knee Overhead Press",
    "Single Arm Kettlebell Bent Press",
    "Single Arm Barbell Bent Press",
    "Alternating Single Arm Kettlebell Around the World High Catch to Squat",
    "Single Arm Kettlebell Cossack Squat Thruster",
    "Double Kettlebell Cossack Squat Thruster",
    "Double Kettlebell Alternating Cossack Squat Thruster",
    "Alternating Single Arm Kettlebell Bottoms Up Clean to Overhead Press",
    "Double Kettlebell Bottoms Up Clean to Overhead Press",
    "Double Kettlebell Bottoms Up Overhead Knee Over Toes Split Squat",
    "Single Arm Kettlebell Overhead Knee Over Toes Split Squat",
    "Single Arm Kettlebell Bottoms Up Overhead Knee Over Toes Split Squat",
    "Barbell Overhead Bulgarian Split Squat ",
    "Barbell Bulgarian Split Squat Thruster",
    "Single Arm Barbell Overhead Bulgarian Split Squat ",
    "Single Arm Kettlebell Swing to Bottoms Up Horn Grip Goblet Squat",
    "Double Kettlebell Overhead Pistol Squat",
    "Double Kettlebell Bottoms Up Front Rack Pistol Squat",
    "Double Kettlebell Bottoms Up Overhead Pistol Squat",
    "Standing Wall Angels",
    "Double Kettlebell Clean to Sots Press",
    "Double Kettlebell Bottoms Up Clean to Sots Press",
    "Plate Lu Raise",
    "Single Arm Plate Windmill",
    "Single Arm Plate Turkish Get Up",
    "Plate Steering Wheel",
    "Kettlebell Half Kneeling Alternating Halo",
    "Kettlebell Tall Kneeling Alternating Halo",
    "Kettlebell Tall Kneeling Alternating Hip to Halo",
    "Double Kettlebell Clean to Thruster",
    "Double Kettlebell Single Leg Standing Bent Knee Overhead Press",
    "Double Kettlebell Bottoms Up Single Leg Standing Bent Knee Overhead Press",
    "Single Arm Kettlebell Single Leg Standing Bent Knee Contralateral Overhead Press",
    "Suspension Single Leg Standing Bent Knee Reverse Fly",
    "Suspension Reverse Fly",
    "Suspension Single Leg Standing Bent Knee Y Raise",
    "Suspension Single Leg Standing Bent Knee Face Pull",
    "Suspension Single Leg Standing Bent Knee Face Pull to Overhead Press",
    "Single Arm Kettlebell Bottoms Up Single Leg Standing Bent Knee Contralateral Overhead Press",
    "Double Kettlebell Bottoms Up Overhead Bulgarian Split Squat",
    "Single Arm Kettlebell Bottoms Up Overhead Contralateral Bulgarian Split Squat",
    "Single Arm Kettlebell Suitcase Contralateral Bulgarian Split Squat",
    "Single Arm Kettlebell Suitcase Ipsilateral Bulgarian Split Squat",
    "Double Kettlebell Bottoms Up Front Rack Bulgarian Split Squat",
    "Double Kettlebell Suitcase Bulgarian Split Squat",
    "Double Kettlebell Bulgarian Split Squat Thruster ",
    "Double Kettlebell Bottoms Up Bulgarian Split Squat Thruster",
    "Single Arm Kettlebell Bottoms Up Front Rack Contralateral Bulgarian Split Squat",
    "Single Arm Kettlebell Front Rack Contralateral Bulgarian Split Squat",
    "Single Arm Kettlebell Bottoms Up Front Rack Ipsilateral Bulgarian Split Squat",
    "Single Arm Kettlebell Front Rack Ipsilateral Bulgarian Split Squat",
    "Single Arm Kettlebell Bottoms Up Single Leg Standing Bent Knee Ipsilateral Overhead Press",
    "Barbell Overhead Pistol Squat",
    "Suspension Cuban Press",
    "Suspension Single Leg Standing Bent Knee Cuban Press",
    "Double Kettlebell Turkish Get Up",
    "Single Arm Barbell Overhead Knee Over Toes Split Squat",
    "Single Arm Barbell Knee Over Toes Split Squat Thruster",
    "Barbell Knee Over Toes Split Squat Thruster",
    "Double Kettlebell Knee Over Toes Split Squat Thruster",
    "Double Kettlebell Bottoms Up Knee Over Toes Split Squat Thruster",
    "Double Kettlebell Bottoms Up Overhead Knee Over Toes Split Squat ",
    "Single Arm Kettlebell Bottoms Up Knee Over Toes Split Squat Thruster",
    "Single Arm Barbell Bulgarian Split Squat Thruster",
    "Single Arm Barbell Windmill",
    "Bodyweight Bent Leg Windmill",
    "Bodyweight Windmill",
    "Superband Half Knee Hover Pallof Press",
    "Single Arm Barbell Turkish Get Up",
    "Single Arm Barbell Single Leg Standing Bent Knee Contralateral Overhead Press ",
    "Single Arm Barbell Single Leg Standing Bent Knee Ipsilateral Overhead Press",
    "Kettlebell Bottoms Up Horn Grip Goblet Bulgarian Split Squat",
    "Double Kettlebell Single Leg Standing Bent Knee Overhead Press",
    "Double Kettlebell Snatch to Overhead Squat",
    "Single Arm Kettlebell Half Kneeling Dead Clean",
    "Single Arm Kettlebell Half Kneeling Clean",
    "Single Arm Kettlebell Half Kneeling Snatch",
    "Double Kettlebell Front Rack Alternating Curtsy Lunge",
    "Double Kettlebell Front Rack Squat to Alternating Curtsy Lunge",
    "Kettlebell Bottoms Up Horn Grip Toe Balance Squat",
    "Single Arm Contralateral Single Leg Push Up",
    "Single Arm Barbell Overhead Toe Balance Squat",
    "Barbell Overhead Toe Balance Squat",
    "Double Kettlebell Dead Squat Clean",
    "Single Arm Kettlebell Dead Squat Clean",
    "Ring Kneeling Rollout",
    "Single Arm Ring Kneeling Rollout",
    "Ring Standing Rollout",
    "Ring Alternating Single Arm Reach Push Up",
    "Ring L Sit Dips",
    "Kettlebell Goblet Cyclist Squat",
    "Kettlebell Bottoms Up Horn Grip Cyclist Squat",
    "Single Arm Kettlebell Bottoms Up Front Rack Cyclist Squat",
    "Double Kettlebell Dead Clean to Overhead Press",
    "Double Kettlebell Dead Clean to Thruster",
    "Single Arm Kettlebell Dead Snatch",
    "Alternating Single Arm Kettlebell Dead Snatch",
    "Double Kettlebell Dead Snatch",
    "Barbell Decline Bench Press",
    "Assisted Bodyweight Bulgarian Split Squat",
    "Bodyweight Bulgarian Split Squat",
    "Stability Ball Otis Up",
    "Plate Otis Up",
    "Double Kettlebell Otis Up",
    "Single Arm Kettlebell Otis Up",
    "Kettlebell Horn Grip Otis Up",
    "Double Kettlebell Bottoms Up Otis Up",
    "Single Arm Kettlebell Bottoms Up Otis Up",
    "Single Arm Kettlebell Bottoms Up Turkish Sit Up",
    "Double Kettlebell Bottoms Up Turkish Sit Up",
    "Double Kettlebell Bottoms Up Turkish Sit Up to Z Press",
    "Single Arm Kettlebell Turkish Sit Up to Z Press",
    "Single Arm Kettlebell Bottoms Up Turkish Sit Up to Z Press",
    "Dumbbell Decline Bench Press",
    "Dumbbell Flat Bench Chest Fly",
    "Dumbbell Decline Bench Chest Fly",
    "Double Kettlebell Alternating Rotational Overhead Press",
    "Double Kettlebell Clean to Alternating Rotational Overhead Press",
    "Single Arm Kettlebell Rotational Thruster",
    "Alternating Single Arm Kettlebell Clean to Rotational Thruster",
    "Double Kettlebell Overhead Alternating Cossack Squat",
    "Alternating Single Arm Kettlebell Clean to Rotational Overhead Press",
    "Alternating Single Arm Kettlebell Bottoms Up Clean to Rotational Overhead Press",
    "Double Kettlebell Bottoms Up Clean to Alternating Rotational Overhead Press",
    "Double Kettlebell Bottoms Up Dead Clean",
    "Double Kettlebell Bottoms Up Dead Clean to Overhead Press",
    "Double Kettlebell Bottoms Up Dead Clean to Thruster",
    "Double Kettlebell Bottoms Up Dead Clean to Alternating Rotational Overhead Press",
    "Double Kettlebell Bottoms Up Dead Clean to Alternating Rotational Thruster",
    "Double Kettlebell Dead Clean to Alternating Rotational Overhead Press",
    "Double Kettlebell Dead Clean to Alternating Rotational Thruster",
    "Single Ring Chin Up",
    "Double Kettlebell Windmill",
    "Single Arm Suspension Single Leg Standing Bent Knee Contralateral Low Row",
    "Single Arm Suspension Single Leg Standing Bent Knee Ipsilateral Low Row",
    "Suspension Single Leg Standing Bent Knee Bicep Curl",
    "Single Arm Suspension Single Leg Bent Knee Contralateral Bicep Curl",
    "Single Arm Suspension Single Leg Bent Knee Ipsilateral Bicep Curl",
    "Single Arm Plate Teacup",
    "Ring L Sit Chin Up",
    "Single Ring L Sit Chin Up",
    "Barbell Front Rack Bulgarian Split Squat",
    "Barbell Back Rack Bulgarian Split Squat",
    "Single Arm Suspension Contralateral Pistol Squat",
    "Barbell Front Rack Alternating Curtsy Lunge",
    "Dragon Flag",
    "Double Kettlebell Dragon Flag",
    "Ring Iron Cross",
    "Parallette Tuck Planche Push Up",
    "Parallette Full Planche",
    "Parallette Full Planche Push Up",
    "Ring Inverted Iron Cross",
    "Ring Maltese Push Up",
    "Ring Tuck Planche",
    "Ring Tuck Planche Push Up",
    "Ring Full Planche",
    "Ring Full Planche Push Up",
    "Ring Grip Full Planche Push Up",
    "Ring Grip Full Planche",
    "Bodyweight Full Planche",
    "Cable Quadruped Hip Abduction",
    "Double Kettlebell Alternating Push Press",
    "Double Kettlebell Front Rack 90-90 Hip Shift to Alternating Overhead Press",
    "Parallette L Sit to Tuck Planche Push Up",
    "Ring L Sit to Tuck Planche Push Up",
    "Parallette Straddle Planche",
    "Parallette Straddle Planche Push Up",
    "Ring Straddle Planche",
    "Ring Straddle Planche Push Up",
    "Barbell Turkish Sit Up",
    "Plate Turkish Sit Up",
    "Barbell Seated Overhead Press",
    "Single Arm Barbell Turkish Sit Up",
    "Dumbbell Crush Grip Romanian Deadlift",
    "Ring Pelican Curl",
    "Kettlebell Dead Bug",
    "Single Arm Kettlebell Bottoms Up Copenhagen Plank",
    "Ring Chin Up",
    "Ring Two Finger Chin Up",
    "Dumbbell Crush Grip Bent Over Row",
    "Double Kettlebell Bottoms Up Front Rack Walking Lunge",
    "Dumbbell Crush Grip Bicep Curl to Overhead Press",
    "Dumbbell Crush Grip Overhead Press",
    "Dumbbell Crush Grip Hollow Body Hold Flutter Kicks",
    "Dumbbell Crush Grip Floor Chest Press",
    "Parallette Crow Pose",
    "Dumbbell Crush Grip Z Press",
    "Kettlebell Dead Clean to Horn Grip Goblet Squat",
    "Dumbbell Crush Grip Standing Overhead Tricep Extension",
    "Double Kettlebell Bottoms Up Front Rack Walking Lunge",
    "Double Kettlebell Bottoms Up Overhead Walking Lunge",
    "Barbell Front Rack Alternating Cossack Squat Hold to Overhead Press",
    "Double Kettlebell Bottoms Up Front Rack March",
    "Double Kettlebell Bottoms Up Overhead March",
    "Double Kettlebell Bottoms Up Alternating Contralateral Overhead Press March",
    "Barbell Half Kneeling Overhead Press",
    "Barbell Tall Kneeling Overhead Press",
    "Single Arm Kettlebell Tactical Clean",
    "Barbell Overhead March",
    "Single Arm Barbell Overhead March",
    "Double Kettlebell Bottoms Up Overhead Adductor Slide",
    "Double Kettlebell Bottoms Up Front Rack Adductor Slide",
    "Double Kettlebell Front Rack Adductor Slide",
    "Bodyweight Adductor Slide",
    "Parallette Plyometric Push Up",
    "Parallette Plyometric Clapping Push Up",
    "Alternating Single Arm Kettlebell Ballistic Row",
    "Double Kettlebell Front Rack Pivot Split Squat",
    "Double Kettlebell Bottoms Up Front Rack Pivot Split Squat",
    "Double Kettlebell Bottoms Up Overhead Pivot Split Squat",
    "Dumbbell Front Rack Pivot Split Squat",
    "Bodyweight Row Feet Elevated",
    "Bodyweight Row",
    "Ring Row",
    "Ring Bulgarian Row",
    "Kettlebell Half Kneeling Rotational Swing",
    "Double Kettlebell Push Jerk",
    "Double Kettlebell Clean to Push Jerk",
    "Slider Barbell Overhead Reverse Lunge",
    "Slider Single Arm Barbell Overhead Reverse Lunge",
    "Pseudo Planche Push Up",
    "Parallette Pseudo Planche Push Up",
    "Kettlebell Half Knee Hover Low to High Chop",
    "Kettlebell Half Knee Hover Alternating Halo",
    "Double Kettlebell Front Rack March",
    "Double Kettlebell Suitcase March",
    "Single Arm Kettlebell Rotational Snatch",
    "Dumbbell Staggered Stance Romanian Deadlift",
    "Barbell Staggered Stance Romanian Deadlift",
    "Single Arm Kettlebell Contralateral Staggered Stance Romanian Deadlift",
    "Ring Hanging Knees to Elbows",
    "Barbell Staggered Stance Overhead Press",
    "Double Kettlebell Dead Clean to Front Rack Squat",
    "Superband Assisted Nordic Hamstring Curl",
    "Double Kettlebell Front Rack Alternating Shin Box Hip Extension to Overhead Press",
    "Bodyweight Alternating Shin Box to Hip Extension",
    "Double Kettlebell Overhead Alternating Shin Box to Hip Extension",
    "Double Kettlebell Bottoms Up Turkish Get Up",
    "Kettlebell Staggered Stance Rotational Swing",
    "Single Arm Kettlebell Suitcase Curtsy Lunge",
    "Single Arm Kettlebell Suitcase Alternating Curtsy Lunge Pass Through",
    "Single Arm Kettlebell Suitcase Walking Lunge Pass Through",
    "Double Kettlebell Bottoms Up Bench Press",
    "Double Kettlebell Overhead Press",
    "Double Kettlebell Bottoms Up Overhead Press",
    "Double Kettlebell Suitcase Carry",
    "Single Arm Kettlebell Suitcase Carry",
    "Single Arm Dumbbell Suitcase Carry",
    "Dumbbell Glute Bridge Bench Press",
    "Double Kettlebell Bottoms Up Glute Bridge Bench Press",
    "Double Kettlebell Bottoms Up Single Leg Glute Bridge Bench Press",
    "Bodyweight Foot Elevated Cossack Squat",
    "Kettlebell Goblet Foot Elevated Cossack Squat",
    "Barbell Overhead Foot Elevated Cossack Squat",
    "Landmine Half Knee Hover Oblique Twist",
    "Alternating Single Arm Kettlebell Knee Hover Quadruped Pull Through",
    "Barbell Back Rack Foot Elevated Cossack Squat",
    "Barbell Front Rack Foot Elevated Cossack Squat",
    "Cable Seated Floor V Grip Lat Pulldown",
    "Barbell Overhead Low Switch Cossack Squat",
    "Single Arm Kettlebell High Pull",
    "Double Kettlebell Suitcase Deficit Bulgarian Split Squat",
    "Alternating Single Arm Kettlebell Front Rack Squat",
    "Alternating Single Arm Kettlebell Thruster",
    "Double Kettlebell Suitcase Knee Over Toes Split Squat",
    "Double Kettlebell Sumo Deadlift to Push Up",
    "Alternating Single Arm Kettlebell Clean to Thruster",
    "Battle Rope Half Knee Hover Alternating Side Slam",
    "Superband Standing Adduction",
    "Superband Lateral Adduction Steps",
    "Single Arm Kettlebell Bottoms Up Copenhagen Plank Side Raise",
    "Single Arm Kettlebell Single Leg Balance Transfer",
    "Bosu Ball Single Arm Kettlebell Single Leg Balance Transfer",
    "Single Arm Kettlebell Suitcase Foot Elevated Knee Over Toes Split Squat",
    "Single Arm Kettlebell Suitcase Knee Over Toes Split Squat",
    "Suspension Cossack Squat",
    "Battle Rope Single Leg Balance Alternating Wave",
    "Battle Rope Alternating Wave",
    "Battle Rope Half Knee Hover Alternating Wave",
    "Superband Assisted Dips",
    "Cable Tall Kneeling Face Pull",
    "Suspension Split Squat",
    "Double Kettlebell Suitcase Deadlift",
    "Suspension Cyclist Squat",
    "Cable Rope Tall Kneeling Tricep Pushdown",
    "Cable Rope Staggered Stance Tricep Pushdown",
    "Suspension Single Arm Contralateral Skater Squat",
    "Double Kettlebell Bottoms Up Clean",
    "Alternating Single Arm Kettlebell Feet Elevated Plank Pull Through",
    "Double Kettlebell Clean to Alternating Thruster",
    "Double Kettlebell Clean to Alternating Overhead Press",
    "Bodyweight Cyclist Squat",
    "Double Kettlebell Bottoms Up Clean to Thruster",
    "Double Kettlebell Bottoms Up Clean to Alternating Thruster",
    "Double Kettlebell Bottoms Up Clean to Alternating Overhead Press",
    "Double Kettlebell Clean to Split Jerk",
    "Double Kettlebell Bottoms Up Clean to Split Jerk",
    "Single Arm Kettlebell Clean to Split Jerk",
    "Alternating Single Arm Kettlebell Clean to Split Jerk",
    "Single Arm Kettlebell Bottoms Up Clean to Split Jerk",
    "Alternating Single Arm Kettlebell Bottoms Up Clean to Split Jerk",
    "Double Kettlebell Bottoms Up Split Jerk",
    "Single Arm Kettlebell Bottoms Up Split Jerk",
    "Alternating Single Arm Kettlebell Bottoms Up Clean",
    "Single Arm Kettlebell Bottoms Up Clean",
    "Slider Single Leg Hamstring Curl",
    "Alternating Single Arm Kettlebell Bottoms Up Clean to Thruster",
    "Single Arm Suspension Cyclist Squat",
    "Alternating Single Arm Kettlebell Bottoms Up Clean to Front Rack Squat",
    "Single Arm Kettlebell Split Squat Thruster",
    "Barbell Low Bar Pause Back Squat",
    "Barbell Pause Front Squat",
    "Barbell High Bar Pause Back Squat",
    "Barbell Overhead Pause Squat",
    "Double Kettlebell Suitcase Alternating Reverse Lunge",
    "Ring Hanging Knees to Wrists",
    "Suspension Adductor Slide",
    "Alternating Single Arm Kettlebell Sumo Deadlift",
    "Dumbbell Goblet Cyclist Squat",
    "Barbell Front Rack Adductor Slide",
    "Barbell Back Rack Adductor Slide",
    "Barbell Overhead Alternating Cossack Squat",
    "Barbell Overhead Alternating Reverse Lunge",
    "Barbell Overhead Press to Alternating Reverse Lunge",
    "Miniband Side Plank Hip Abduction",
    "Slider Double Kettlebell Suitcase Reverse Lunge",
    "Slider Double Kettlebell Front Rack Reverse Lunge",
    "Slider Double Kettlebell Overhead Reverse Lunge",
    "Single Arm Kettlebell Suitcase March",
    "Single Arm Kettlebell Bottoms Up Overhead March",
    "Single Arm Kettlebell Bottoms Up Front Rack March",
    "Parallette Close Grip Single Leg Push Up",
    "Double Kettlebell Half Snatch",
    "Alternating Single Arm Kettlebell Half Snatch",
    "Single Arm Kettlebell Half Snatch",
    "Double Kettlebell Half Snatch to Thruster",
    "Alternating Single Arm Kettlebell Half Snatch to Thruster",
    "Single Arm Kettlebell Bottoms Up Overhead Cossack Squat",
    "Kettlebell Goblet Horse Stance Squat",
    "Suspension Alternating Curtsy Lunge",
    "Double Kettlebell Alternating Forward Lunge Snatch",
    "Barbell Front Rack Alternating Forward Lunge",
    "Barbell Front Rack Alternating Reverse Lunge",
    "Barbell Overhead Alternating Forward Lunge",
    "Macebell 360",
    "Single Arm Macebell 360",
    "Macebell 10 to 2 ",
    "Macebell Barbarian Squat",
    "Single Arm Macebell Barbarian Squat",
    "Macebell Ballistic Curl",
    "Macebell Single Leg Standing Ballistic Curl",
    "Macebell Half Knee Hover Low to High Chop",
    "Single Arm Macebell Single Leg Standing Bent Knee 360",
    "Double Indian Club Outer Heart Shaped Swing",
    "Single Arm Indian Club Outer Heart Shaped Swing",
    "Macebell Front Swing to 360",
    "Macebell Alternating Front Swing to 360",
    "Clubbell Swing to Gamma Cast",
    "Macebell Alternating 360",
    "Macebell Bulgarian Split Squat to Alternating 360",
    "Single Arm Landmine Single Leg Standing Bent Knee Ipsilateral Shoulder Press",
    "Single Arm Landmine Single Leg Standing Bent Knee Contralateral Shoulder Press",
    "Alternating Single Arm Landmine Single Leg Standing Bent Knee Shoulder Press",
    "Double Kettlebell Feet Elevated Renegade Row",
    "Double Kettlebell Feet Elevated Renegade Row Push Up",
    "Macebell Alternating 360 to Lateral Uppercut",
    "Macebell Alternating 360 to Alternating Lateral Lunge Front Press",
    "Clubbell Shield Cast",
    "Single Arm Clubbell Shield Cast",
    "Alternating Double Clubbell Shield Cast",
    "Single Arm Clubbell Inside Circle",
    "Alternating Double Clubbell Inside Circles",
    "Clubbell Inside Circle",
    "Clubbell Alternating Inside Circle",
    "Double Clubbell Side Shoulder Cast",
    "Double Clubbell Side Shoulder Cast to Side Flag Press",
    "Double Clubbell Swipe to Alternating Reverse Lunge Side Shoulder Cast to Side Flag Press",
    "Clubbell Swing to Alternating Side Shoulder Park Squat",
    "Double Clubbell Single Leg Standing Bent Knee Side Shoulder Cast to Side Flag Press",
    "Clubbell Swing to Barbarian Squat",
    "Clubbell Mill",
    "Clubbell Inside Pendulum",
    "Clubbell Half Kneeling Shield Cast",
    "Clubbell Half Knee Hover Shield Cast",
    "Clubbell Single Leg Standing Bent Knee Shield Cast",
    "Double Clubbell Iron Cross",
    "Double Clubbell Half Kneeling Iron Cross",
    "Double Clubbell Half Knee Hover Iron Cross",
    "Double Clubbell Single Leg Standing Bent Knee Iron Cross",
    "Double Kettlebell Half Snatch to Overhead Press",
    "Double Kettlebell Half Snatch to Front Rack Squat",
    "Clubbell Alternating Inside Circles",
    "Double Clubbell Alternating Reverse Lunge Front Flag Press",
    "Clubbell Gamma Cast",
    "Clubbell Half Kneeling Gamma Cast",
    "Clubbell Half Knee Hover Gamma Cast",
    "Clubbell Single Leg Standing Bent Knee Gamma Cast",
    "Single Arm Clubbell Pullover",
    "Double Clubbell Pullover",
    "Clubbell Pullover",
    "Clubbell Side Swing",
    "Single Arm Clubbell Side Swing",
    "Single Arm Clubbell Inside Pendulum",
    "Double Clubbell Swipe",
    "Single Arm Clubbell Swipe",
    "Single Arm Clubbell Crossbody Swipe",
    "Macebell Alternating 360 to Front Flag Press",
    "Single Arm Clubbell Inside Circle to Shield Cast",
    "Clubbell Barbarian Squat",
    "Single Arm Clubbell Inside Circle to Outside Circle",
    "Clubbell Side to Side Swing",
    "Double Clubbell Barbarian Squat",
    "Alternating Single Arm Clubbell Inside Circle",
    "Single Arm Clubbell Side to Side Swing",
    "Alternating Single Arm Clubbell Side to Side Swing",
    "Clubbell Alternating Pendulum to Gamma Cast",
    "Single Arm Clubbell Single Leg Standing Bent Knee Contralateral Shield Cast",
    "Double Clubbell Side Flag Press",
    "Clubbell Front Flag Press",
    "Single Arm Clubbell Inside Circle to Front Flag Press",
    "Single Arm Kettlebell Bottoms Up Overhead Adductor Slide",
    "Double Clubbell Order Bulgarian Split Squat",
    "Barbell Hang Squat Clean",
    "Kettlebell Single Leg Standing Hip Flexion",
    "Miniband Supine Alternating Hip Flexion",
    "Double Indian Club Inner Heart Shaped Swing",
    "Single Arm Indian Club Inner Heart Shaped Swing",
    "Alternating Double Indian Club Inner Heart Shaped Swing",
    "Double Indian Club Crescent Swing",
    "Single Arm Clubbell Barbarian Squat",
    "Single Arm Clubbell Single Leg Standing Bent Knee Ipsilateral Shield Cast",
    "Clubbell Order Cyclist Squat",
    "Single Arm Clubbell Order Contralateral Bulgarian Split Squat",
    "Alternating Double Clubbell Side Flag Press",
    "Single Arm Clubbell Side Flag Press",
    "Single Arm Clubbell Side Shoulder Cast",
    "Clubbell Order Squat",
    "Single Arm Clubbell Order Ipsilateral Bulgarian Split Squat",
    "Single Arm Clubbell Order Squat",
    "Double Clubbell Order Squat",
    "Single Arm Macebell Front Swing to 360",
    "Single Arm Ring Dead Hang",
    "Clubbell Torch Press",
    "Single Arm Clubbell Torch Press",
    "Double Clubbell Torch Press",
    "Alternating Double Clubbell Torch Press",
    "Single Arm Clubbell Front Flag Press",
    "Double Clubbell Front Flag Press",
    "Alternating Double Clubbell Front Flag Press",
    "Double Indian Club Lateral Internal and External Rotations",
    "Single Arm Indian Club Lateral Internal and External Rotation",
    "Double Indian Club Overhead Arm Circles",
    "Double Indian Club Lateral Arm Circles",
    "Resistance Band Shoulder Dislocates",
    "Suspension Reverse Grip Bicep Curl",
    "Running",
    "Jogging",
    "Swimming",
    "Cycling",
    "Stationary Bike",
    "Rowing",
    "Rowing Machine",
    "Elliptical Trainer Machine",
    "Cross Trainer Machine"
  ];

  Map<String, Map<String, String>> exerciseMap = {
    "Stability Ball Dead Bug": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Glute Bridge": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Bird Dog": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Stability Ball Seated Russian Twist ": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Rectus Abdominis ",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Stability Ball Feet Elevated Crunch ": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Hanging Knee Raise ": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Parallette Mountain Climber": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Parallette Push Up": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Knee Hover Bird Dog": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Stability Ball Pass": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dead Bug": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Heel Taps": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Rectus Abdominis ",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Flutter Kicks": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Kneeling Plank": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Seated Ab Circles": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Hanging Oblique Knee Raise": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Rectus Abdominis ",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Stability Ball Stir The Pot": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Side Kick Through": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring L Hang Flutter Kicks ": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Slam Ball Russian Twist": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Rectus Abdominis ",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Otis Up": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Dumbbell Side Plank Reach Through ": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Rectus Abdominis ",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ab Wheel Kneeling Rollout": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Cable Seated Crunch": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Cable Kneeling Crunch": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Medicine Ball V-Up": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Suspension Knee Tuck": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Suspension Lateral Knee Tuck": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Push Up Alternating Kick Through": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Rectus Abdominis",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Dumbbell Turkish Get Up": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Rectus Abdominis",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Bear Crawl": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Stability Ball Knee Tuck": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Hanging Leg Raise ": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Parallette L Sit": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Standing Walkout Plank": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Standing Walkout Push-Up ": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Rectus Abdominis ",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Climb": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ipsilateral Bird Dog": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Copenhagen Plank Knee to Elbow": {
      "target-muscle": "Adductors",
      "primary-muscle": "Adductor Magnus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Dead Hang": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Suspension Archer Row ": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Suspension Alternating Archer Row Hold ": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Pull Up Eccentrics ": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Pull Up": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Chin Up Eccentrics ": {
      "target-muscle": "Biceps",
      "primary-muscle": "Biceps Brachii",
      "secondary-muscle": "Latissimus Dorsi",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Miniband Fire Hydrant": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "Gluteus Medius",
      "tertiary-muscle": "Gluteus Minimus",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Medicine Ball Russian Twist": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Rectus Abdominis ",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Side Plank": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Rectus Abdominis ",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Cable Reverse Ankle Strap Crunch": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Cable Half Kneeling High to Low Chop": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Rectus Abdominis ",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Cable Half Kneeling Low to High Chop": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Rectus Abdominis ",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Kettlebell Half Kneeling Low to High Chop": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Rectus Abdominis ",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Cable Half Kneeling Pallof Press": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Rectus Abdominis",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Cable Standing High to Low Chop ": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Rectus Abdominis ",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Cable Standing Low to High Chop": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Rectus Abdominis ",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Dumbbell Windmill": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Windmill": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Kettlebell Russian Twist": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Feet On Wall Mountain Climber ": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Single Arm Kettlebell Plank Pull Through": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "Obliques",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Hollow Body Hold": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Crush Grip Hollow Body Hold": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Inverted Hanging Crunch": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Inverted Hanging Oblique Crunch": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Single Leg Standing Bent Knee Around The World ": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Supine Alternating Single Leg Raise": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Supine Leg Raise": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Miniband Bicycle Crunch": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Side Plank Reach Through": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Rectus Abdominis ",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Sit Up": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Butterfly Sit Up": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Slider Mountain Climber": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Slider Pike ": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Stability Ball Pike": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Slider Wide Mountain Climber": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Stability Ball Crunch": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Stability Ball Feet Elevated Oblique Crunch": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Stability Ball Kneeling Rollout": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Stability Ball Single Leg Knee Tuck": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Stability Ball Single Leg Pike": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Parallette Kneeling Push Up": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Swing": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "Biceps Femoris",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Romanian Deadlift": {
      "target-muscle": "Hamstrings",
      "primary-muscle": "Biceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Dumbbell Side Plank": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Rectus Abdominis ",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Leg Glute Bridge": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Glute Bridge": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Glute Bridge Alternating Single Leg Extension": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Miniband Side Lying Clamshell": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "Gluteus Medius",
      "tertiary-muscle": "Gluteus Minimus",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Miniband Side Lying Hip Abduction": {
      "target-muscle": "Abductors",
      "primary-muscle": "Gluteus Medius",
      "secondary-muscle": "Gluteus Minimus",
      "tertiary-muscle": "Tensor Fasciae Latae",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Miniband Bench Seated Hip Abduction": {
      "target-muscle": "Abductors",
      "primary-muscle": "Gluteus Medius",
      "secondary-muscle": "Gluteus Minimus",
      "tertiary-muscle": "Tensor Fasciae Latae",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Miniband Glute Bridge With Hip Abduction": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "Gluteus Medius",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Stability Ball Hip Thrust": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Stability Ball Dumbbell Hip Thrust": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Bodyweight Frog Pump": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Frog Pump": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Cable Glute Kickback": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Foot Elevated Single Leg Glute Bridge": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Suspension Glute Bridge": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Miniband Thigh Lateral Walk": {
      "target-muscle": "Abductors",
      "primary-muscle": "Gluteus Medius",
      "secondary-muscle": "Gluteus Minimus",
      "tertiary-muscle": "Tensor Fasciae Latae",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Miniband Shin Lateral Walk": {
      "target-muscle": "Abductors",
      "primary-muscle": "Gluteus Medius",
      "secondary-muscle": "Gluteus Minimus",
      "tertiary-muscle": "Tensor Fasciae Latae",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Miniband Feet Lateral Walk": {
      "target-muscle": "Abductors",
      "primary-muscle": "Gluteus Medius",
      "secondary-muscle": "Gluteus Minimus",
      "tertiary-muscle": "Tensor Fasciae Latae",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Miniband Standing Glute Kickback": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Hip Thrust": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Single Leg Hip Thrust": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Stability Ball Single Leg Glute Bridge": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Miniband Standing Hip Abduction": {
      "target-muscle": "Abductors",
      "primary-muscle": "Gluteus Medius",
      "secondary-muscle": "Gluteus Minimus",
      "tertiary-muscle": "Tensor Fasciae Latae",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Miniband 3-Way Cha Cha": {
      "target-muscle": "Abductors",
      "primary-muscle": "Gluteus Medius",
      "secondary-muscle": "Gluteus Minimus",
      "tertiary-muscle": "Tensor Fasciae Latae",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Standing Calf Raise": {
      "target-muscle": "Calves",
      "primary-muscle": "Gastrocnemius",
      "secondary-muscle": "Soleus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Cable Hip Abduction": {
      "target-muscle": "Abductors",
      "primary-muscle": "Gluteus Medius",
      "secondary-muscle": "Gluteus Minimus",
      "tertiary-muscle": "Tensor Fasciae Latae",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Miniband Wall Sit Hip Abduction": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Medius",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Overhead Adductor Slide": {
      "target-muscle": "Adductors",
      "primary-muscle": "Adductor Magnus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Stability Ball T's Y's I's ": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Resistance Band Standing Reverse Fly": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Resistance Band Lateral Raise": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Medial Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Lateral Raise": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Medial Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Resistance Band Standing Shoulder External Rotation": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Infraspinatus",
      "tertiary-muscle": "Teres Minor",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Seated Lateral Raise": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Medial Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Pike Push Up": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Dumbbell Side Lying Shoulder External Rotation": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Infraspinatus",
      "tertiary-muscle": "Teres Minor",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Dumbbell Seated Shoulder External Rotation": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Infraspinatus",
      "tertiary-muscle": "Teres Minor",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Miniband Standing Shoulder External Rotation": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Infraspinatus",
      "tertiary-muscle": "Teres Minor",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Seated Cuban Rotation": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Infraspinatus",
      "tertiary-muscle": "Teres Minor",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Standing Cuban Rotation": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Infraspinatus",
      "tertiary-muscle": "Teres Minor",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Cable Half Kneeling Shoulder External Rotation 90 Degrees": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Infraspinatus",
      "tertiary-muscle": "Teres Minor",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Dumbbell Side Lying Shoulder Internal Rotation": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Subscapularis ",
      "secondary-muscle": "Teres Major",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Parallette Feet Elevated Pike Push Up ": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Thruster": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Parallette Wall Supported Handstand Push Up": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Sots Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Dumbbell V Sit Shoulder Press ": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "Rectus Abdominis ",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Z Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Dumbbell Z Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Stability Ball Dumbbell Arnold Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Dumbbell Half Kneeling Overhead Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "Rectus Abdominis ",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Cable Lateral Raise": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Medial Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Thruster": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Dumbbell Thruster": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Parallette Handstand Push Up": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Seated Overhead Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Overhead Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Dumbbell Overhead Carry": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Obliques",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Freestanding Handstand Push Up": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Shrug": {
      "target-muscle": "Trapezius",
      "primary-muscle": "Upper Trapezius",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Shrug": {
      "target-muscle": "Trapezius",
      "primary-muscle": "Upper Trapezius",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Cable Standing Face Pull": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Infraspinatus",
      "tertiary-muscle": "Teres Minor",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Cable Seated Face Pull": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Infraspinatus",
      "tertiary-muscle": "Teres Minor",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Standing Scaption": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Serratus Anterior",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Seated Scaption": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Serratus Anterior",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Stability Ball Dumbbell Seated Scaption": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Serratus Anterior",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Cable Standing Knee Strap Hip External Rotation (90 Degrees)": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "Gluteus Medius",
      "tertiary-muscle": "Gluteus Minimus",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Cable Hip External Rotation": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "Gluteus Medius",
      "tertiary-muscle": "Gluteus Minimus",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Bicep Curl": {
      "target-muscle": "Biceps",
      "primary-muscle": "Biceps Brachii",
      "secondary-muscle": "Brachialis",
      "tertiary-muscle": "Brachioradialis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Alternating Bicep Curl": {
      "target-muscle": "Biceps",
      "primary-muscle": "Biceps Brachii",
      "secondary-muscle": "Brachialis",
      "tertiary-muscle": "Brachioradialis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Alternating Hammer Curl": {
      "target-muscle": "Biceps",
      "primary-muscle": "Biceps Brachii",
      "secondary-muscle": "Brachialis",
      "tertiary-muscle": "Brachioradialis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Alternating Cross Body Hammer Curl": {
      "target-muscle": "Biceps",
      "primary-muscle": "Biceps Brachii",
      "secondary-muscle": "Brachialis",
      "tertiary-muscle": "Brachioradialis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Cable Guillotine Curl": {
      "target-muscle": "Biceps",
      "primary-muscle": "Biceps Brachii",
      "secondary-muscle": "Brachialis",
      "tertiary-muscle": "Brachioradialis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Cable Supine Bicep Curl": {
      "target-muscle": "Biceps",
      "primary-muscle": "Biceps Brachii",
      "secondary-muscle": "Brachialis",
      "tertiary-muscle": "Brachioradialis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Dumbbell Incline Bench Preacher Curl": {
      "target-muscle": "Biceps",
      "primary-muscle": "Biceps Brachii",
      "secondary-muscle": "Brachialis",
      "tertiary-muscle": "Brachioradialis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Crush Grip Bicep Curl": {
      "target-muscle": "Biceps",
      "primary-muscle": "Biceps Brachii",
      "secondary-muscle": "Brachialis",
      "tertiary-muscle": "Brachioradialis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Zottman Curl": {
      "target-muscle": "Biceps",
      "primary-muscle": "Biceps Brachii",
      "secondary-muscle": "Brachialis",
      "tertiary-muscle": "Brachioradialis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Waiter Curl": {
      "target-muscle": "Biceps",
      "primary-muscle": "Biceps Brachii",
      "secondary-muscle": "Brachialis",
      "tertiary-muscle": "Brachioradialis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "High Cable Straight Bar Bicep Curl": {
      "target-muscle": "Biceps",
      "primary-muscle": "Biceps Brachii",
      "secondary-muscle": "Brachialis",
      "tertiary-muscle": "Brachioradialis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Cable Straight Bar Drag Curl": {
      "target-muscle": "Biceps",
      "primary-muscle": "Biceps Brachii",
      "secondary-muscle": "Brachialis",
      "tertiary-muscle": "Brachioradialis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Spider Curl": {
      "target-muscle": "Biceps",
      "primary-muscle": "Biceps Brachii",
      "secondary-muscle": "Brachialis",
      "tertiary-muscle": "Brachioradialis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "EZ Bar Spider Curl": {
      "target-muscle": "Biceps",
      "primary-muscle": "Biceps Brachii",
      "secondary-muscle": "Brachialis",
      "tertiary-muscle": "Brachioradialis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Parallette Side Plank": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Rectus Abdominis ",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Parallette Feet Elevated Push Up": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Parallette Side Plank Reach Through": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Rectus Abdominis ",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Parallette Plank Single Arm Dumbbell Row": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "Obliques",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Stability Ball Cable Preacher Curl": {
      "target-muscle": "Biceps",
      "primary-muscle": "Biceps Brachii",
      "secondary-muscle": "Brachialis",
      "tertiary-muscle": "Brachioradialis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Dumbbell Standing Concentration Curl": {
      "target-muscle": "Biceps",
      "primary-muscle": "Biceps Brachii",
      "secondary-muscle": "Brachialis",
      "tertiary-muscle": "Brachioradialis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Reverse Barbell Curl": {
      "target-muscle": "Forearms",
      "primary-muscle": "Brachioradialis",
      "secondary-muscle": "Biceps Brachii",
      "tertiary-muscle": "Brachialis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "EZ Bar Standing Bicep Curl": {
      "target-muscle": "Biceps",
      "primary-muscle": "Biceps Brachii",
      "secondary-muscle": "Brachialis",
      "tertiary-muscle": "Brachioradialis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Cable Rope Hammer Curl": {
      "target-muscle": "Biceps",
      "primary-muscle": "Biceps Brachii",
      "secondary-muscle": "Brachialis",
      "tertiary-muscle": "Brachioradialis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Cable Standing High Bicep Curl": {
      "target-muscle": "Biceps",
      "primary-muscle": "Biceps Brachii",
      "secondary-muscle": "Brachialis",
      "tertiary-muscle": "Brachioradialis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Suspension Bicep Curl": {
      "target-muscle": "Biceps",
      "primary-muscle": "Biceps Brachii",
      "secondary-muscle": "Brachialis",
      "tertiary-muscle": "Brachioradialis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Standing Tricep Kickback": {
      "target-muscle": "Triceps",
      "primary-muscle": "Triceps Brachii ",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "EZ Bar Seated Overhead Tricep Extension": {
      "target-muscle": "Triceps",
      "primary-muscle": "Triceps Brachii ",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "EZ Bar Standing Overhead Tricep Extension": {
      "target-muscle": "Triceps",
      "primary-muscle": "Triceps Brachii ",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Seated Overhead Tricep Extension": {
      "target-muscle": "Triceps",
      "primary-muscle": "Triceps Brachii ",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Standing Overhead Tricep Extension": {
      "target-muscle": "Triceps",
      "primary-muscle": "Triceps Brachii ",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Diamond Push Up": {
      "target-muscle": "Triceps",
      "primary-muscle": "Triceps Brachii ",
      "secondary-muscle": "Pectoralis Major",
      "tertiary-muscle": "Anterior Deltoids",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Close Grip Floor Chest Press": {
      "target-muscle": "Triceps",
      "primary-muscle": "Triceps Brachii ",
      "secondary-muscle": "Pectoralis Major",
      "tertiary-muscle": "Anterior Deltoids",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Close Grip Bench Press": {
      "target-muscle": "Triceps",
      "primary-muscle": "Triceps Brachii ",
      "secondary-muscle": "Pectoralis Major",
      "tertiary-muscle": "Anterior Deltoids",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Close Grip Incline Bench Press": {
      "target-muscle": "Triceps",
      "primary-muscle": "Triceps Brachii ",
      "secondary-muscle": "Pectoralis Major",
      "tertiary-muscle": "Anterior Deltoids",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "EZ Bar Lying Tricep Extension ": {
      "target-muscle": "Triceps",
      "primary-muscle": "Triceps Brachii ",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Stability Ball Feet Elevated Diamond Push Up": {
      "target-muscle": "Triceps",
      "primary-muscle": "Triceps Brachii ",
      "secondary-muscle": "Pectoralis Major",
      "tertiary-muscle": "Anterior Deltoids",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Bodyweight Tricep Extension": {
      "target-muscle": "Triceps",
      "primary-muscle": "Triceps Brachii ",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Cable Rope Standing Overhead Tricep Extension": {
      "target-muscle": "Triceps",
      "primary-muscle": "Triceps Brachii ",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Cable Rope Standing Tricep Pushdown ": {
      "target-muscle": "Triceps",
      "primary-muscle": "Triceps Brachii ",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Dips": {
      "target-muscle": "Triceps",
      "primary-muscle": "Triceps Brachii ",
      "secondary-muscle": "Rectus Abdominis ",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Cable Reverse Tricep Pulldown": {
      "target-muscle": "Triceps",
      "primary-muscle": "Triceps Brachii ",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Suitcase Carry": {
      "target-muscle": "Forearms",
      "primary-muscle": "Brachioradialis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Seated Wrist Curl": {
      "target-muscle": "Forearms",
      "primary-muscle": "Brachioradialis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "EZ Bar Reverse Curl": {
      "target-muscle": "Forearms",
      "primary-muscle": "Brachioradialis",
      "secondary-muscle": "Biceps Brachii",
      "tertiary-muscle": "Brachialis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Incline Push Up": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "Anterior Deltoids",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Kneeling Push Up": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "Anterior Deltoids",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Suspension Chest Press": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "Anterior Deltoids",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Suspension Chest Fly": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Glute Bridge Chest Press": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "Anterior Deltoids",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Stability Ball Single Arm Dumbbell Chest Press": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "Anterior Deltoids",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Stability Ball Dumbbell Chest Fly": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Burpee": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "Anterior Deltoids",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Devil Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Pectoralis Major",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Single Arm Dumbbell Devil Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Pectoralis Major",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Dumbbell Hollow Body Chest Press": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "Anterior Deltoids",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Plyometric Push Up On Weight Plates": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "Anterior Deltoids",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Stability Ball Dumbbell Pullover ": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Incline Bench Chest Fly": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Push Up": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "Anterior Deltoids",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Aztec Push Up": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "Anterior Deltoids",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Ring Grip Push Up": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "Anterior Deltoids",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Rolling Squat Burpee": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "Anterior Deltoids",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Grip Push Up": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "Anterior Deltoids",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Suspension Low Row": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Suspension Mid Row": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Suspension Face Pull": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Infraspinatus",
      "tertiary-muscle": "Teres Minor",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Cable Seated V Grip Low Row": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Landmine V Grip Row": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Landmine Row": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Bent Over Row": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Gorilla Row": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Superband Assisted Wide Grip Pull Up": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Resistance Band Half Kneeling Face Pull": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Infraspinatus",
      "tertiary-muscle": "Teres Minor",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Dumbbell Single Leg Contralateral Bent Over Row": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Stability Ball Prone Cobra": {
      "target-muscle": "Back",
      "primary-muscle": "Erector Spinae ",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Prone Cobra": {
      "target-muscle": "Back",
      "primary-muscle": "Erector Spinae ",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Pendlay Row": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Single Leg Row": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Cable Straight Bar Pullover": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Dumbbell Bird Dog Row": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "Rectus Abdominis ",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Cable Half Kneeling Lat Pulldown": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Cable Half Kneeling Low Row": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Suspension Row": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "Biceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Dumbbell Suitcase Deadlift": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "Obliques",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Suitcase Deadlift": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "Obliques",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Incline Bench Prone Row": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Archer Pull Up": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Renegade Row ": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Conventional Deadlift": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Sumo Deadlift": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Rack Pull": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Snatch Grip Deadlift": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Pendlay Row": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Stability Ball Hyperextension": {
      "target-muscle": "Back",
      "primary-muscle": "Erector Spinae ",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Seated Good Morning ": {
      "target-muscle": "Back",
      "primary-muscle": "Erector Spinae ",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Good Morning": {
      "target-muscle": "Back",
      "primary-muscle": "Erector Spinae ",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Wall Sit ": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Wall Slide Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Stability Ball Wall Slide Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Suspension Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Suspension Alternating Reverse Lunge": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Bodyweight Squat to Bench": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Bodyweight Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Assisted Bodyweight Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Bodyweight Walking Lunge": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Goblet Squat ": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Miniband Romanian Deadlift": {
      "target-muscle": "Hamstrings",
      "primary-muscle": "Biceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Superband Resisted Skater Jump": {
      "target-muscle": "Abductors",
      "primary-muscle": "Gluteus Medius",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Cable Prone Single Leg Hamstring Curl": {
      "target-muscle": "Hamstrings",
      "primary-muscle": "Biceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Candlestick Roll Up Tuck Jump": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Bench Press": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "Anterior Deltoids",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Bicep Curl": {
      "target-muscle": "Biceps",
      "primary-muscle": "Biceps Brachii",
      "secondary-muscle": "Brachialis",
      "tertiary-muscle": "Brachioradialis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Block Pull Deadlift": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Box Pause Back Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Deficit Deadlift": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Front Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Glute Bridge": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Halting Deadlift": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell High Bar Back Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Low Bar Back Squat": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "Biceps Femoris",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Overhead Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Power Clean": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "Biceps Femoris",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Power Snatch": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "Biceps Femoris",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Push Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Romanian Deadlift": {
      "target-muscle": "Hamstrings",
      "primary-muscle": "Biceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Row": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "Biceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Back Rack Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Stiff Legged Deadlift": {
      "target-muscle": "Hamstrings",
      "primary-muscle": "Biceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Sumo Squat": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Bodyweight Pistol Squat": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Bodyweight Skater Squat": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Cable Pull Through": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Suitcase Bulgarian Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Dumbbell Contralateral Overhead Step Up": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Suitcase Deficit Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Suitcase Alternating Forward Lunge": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Suitcase Alternating Reverse Lunge": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Seated Reverse Fly": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Suitcase Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Suitcase Box Step Up": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Face the Wall Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Feet Elevated Glute Bridge": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Clean": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Clean to Overhead Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Kettlebell Alternating Halo": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Posterior Deltoids",
      "tertiary-muscle": "Medial Deltoids",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Overhead Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Snatch": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Kettlebell Sumo Deadlift": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Turkish Get Up": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Rectus Abdominis",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Miniband Monster Walk": {
      "target-muscle": "Abductors",
      "primary-muscle": "Gluteus Medius",
      "secondary-muscle": "Gluteus Medius",
      "tertiary-muscle": "Tensor Fasciae Latae",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Quadruped Hip Extension": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Suspension Pistol Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Suspension Skater Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Tuck Jump": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Single Leg Wall Sit": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Leg Romanian Deadlift Jump": {
      "target-muscle": "Hamstrings",
      "primary-muscle": "Biceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Dumbbell Overhead Walking Lunge": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Stability Ball Overhead Walking Lunge": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Stability Ball Dumbbell Suitcase Bulgarian Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Bodyweight Leg Extension": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Lateral Bench Jump": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Dumbbell Front Rack Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Skater Jump": {
      "target-muscle": "Abductors",
      "primary-muscle": "Gluteus Medius",
      "secondary-muscle": "Adductor Magnus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Slider Single Arm Dumbbell Front Rack Reverse Lunge": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Cable Prone Hamstring Curl": {
      "target-muscle": "Hamstrings",
      "primary-muscle": "Biceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Bulgarian Split Squat Jumps": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Cable Standing Single Leg Hamstring Curl": {
      "target-muscle": "Hamstrings",
      "primary-muscle": "Biceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Nordic Hamstring Curl": {
      "target-muscle": "Hamstrings",
      "primary-muscle": "Biceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Superband Assisted Pistol Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Kettlebell Goblet Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Front Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Suitcase Walking Lunge": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Back Rack Walking Lunge": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Box Pistol Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Overhead Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Overhead Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Landmine Goblet Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Stability Ball Hamstring Curl": {
      "target-muscle": "Hamstrings",
      "primary-muscle": "Biceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Slider Hamstring Curl": {
      "target-muscle": "Hamstrings",
      "primary-muscle": "Biceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Hamstring Walkout ": {
      "target-muscle": "Hamstrings",
      "primary-muscle": "Biceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Slider Dumbbell Goblet Reverse Lunge": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dragon Pistol Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Dumbbell Front Rack Cossack Squat to Overhead Press": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "Anterior Deltoids",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Stability Ball Single Leg Hamstring Curl": {
      "target-muscle": "Hamstrings",
      "primary-muscle": "Biceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Single Leg Romanian Deadlift": {
      "target-muscle": "Hamstrings",
      "primary-muscle": "Biceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Suitcase Lateral Lunge": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Frankenstein Walking Lunge": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Overhead Walking Lunge": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Overhead Lateral Lunge": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Squat Clean": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Landmine Clean and Jerk": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Landmine Hack Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Landmine Shoulder Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Single Arm Landmine Shoulder Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Landmine Half Kneeling Shoulder Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Landmine Tall Kneeling Shoulder Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Landmine Meadows Row": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Landmine Z Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Z Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Landmine Half Kneeling Oblique Twist ": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Cable Seated Bicep Curl": {
      "target-muscle": "Biceps",
      "primary-muscle": "Biceps Brachii",
      "secondary-muscle": "Brachialis",
      "tertiary-muscle": "Brachioradialis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Dumbbell Seated Concentration Curl": {
      "target-muscle": "Biceps",
      "primary-muscle": "Biceps Brachii",
      "secondary-muscle": "Brachialis",
      "tertiary-muscle": "Brachioradialis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Incline Bench Alternating Bicep Curl": {
      "target-muscle": "Biceps",
      "primary-muscle": "Biceps Brachii",
      "secondary-muscle": "Brachialis",
      "tertiary-muscle": "Brachioradialis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Suspension Bicep Curl": {
      "target-muscle": "Biceps",
      "primary-muscle": "Biceps Brachii",
      "secondary-muscle": "Brachialis",
      "tertiary-muscle": "Brachioradialis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Stability Ball Single Arm Plank": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Stability Ball Feet Elevated Single Arm Plank": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Landmine Zercher Skater Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Landmine Reverse Lunge to Single Arm Shoulder Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Landmine Thruster": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Landmine Romanian Deadlift": {
      "target-muscle": "Hamstrings",
      "primary-muscle": "Biceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Landmine Single Leg Romanian Deadlift": {
      "target-muscle": "Hamstrings",
      "primary-muscle": "Biceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Landmine Tall Kneeling Oblique Twist": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Rectus Abdominis",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Landmine Russian Twist": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Rectus Abdominis",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Landmine Thruster": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Landmine Calf Raise": {
      "target-muscle": "Calves",
      "primary-muscle": "Gastrocnemius",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Cable Tall Kneeling Overhead Tricep Extension ": {
      "target-muscle": "Triceps",
      "primary-muscle": "Triceps Brachii",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Cable Rope Skullcrusher": {
      "target-muscle": "Triceps",
      "primary-muscle": "Triceps Brachii",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Clean to Overhead Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Dumbbell Seated Cuban Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Infraspinatus",
      "tertiary-muscle": "Teres Minor",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Landmine Zercher Curtsy Lunge": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Back Rack Cossack Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Adductor Magnus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Overhead Cossack Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Adductor Magnus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Front Rack Alternating Cossack Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Adductor Magnus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Kettlebell Goblet Cossack Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Adductor Magnus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Goblet Cossack Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Adductor Magnus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Bodyweight Cossack Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Adductor Magnus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Bodyweight Knee Over Toes Split Squat ": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Back Rack Knee Over Toes Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Front Rack Knee Over Toes Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Overhead Knee Over Toes Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Barbell Overhead Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Single Leg Bent Knee Bicep Curl": {
      "target-muscle": "Biceps",
      "primary-muscle": "Biceps Brachii",
      "secondary-muscle": "Brachialis",
      "tertiary-muscle": "Brachioradialis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Slider Knee Tuck": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Wall Facing Handstand": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Freestanding Handstand ": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Suspension Atomic Push Up": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Rectus Abdominis",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Suspension Pike": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Suspension Side Plank Reach Through": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Rectus Abdominis ",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Cocoon Crunch": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ab Wheel Standing Rollout": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Cable Fire Hydrant": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "Gluteus Medius",
      "tertiary-muscle": "Gluteus Minimus",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Cable Tall Kneeling Pull Through": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Stability Ball Bent Knee Reverse Hyperextension": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Bent Knee Reverse Hyperextension on Bench": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Parallette Tuck L Sit": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Parallette Close Grip Push Up": {
      "target-muscle": "Triceps",
      "primary-muscle": "Triceps Brachii",
      "secondary-muscle": "Pectoralis Major",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Parallette Feet Elevated Close Grip Tricep Push Up": {
      "target-muscle": "Chest",
      "primary-muscle": "Triceps Brachii",
      "secondary-muscle": "Pectoralis Major",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Parallette Single Leg L Sit": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Stability Ball Bottoms Up": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Stability Ball Windshield Wiper": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Rectus Abdominis",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Stability Ball Tall Kneeling Balance": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Stability Ball Oblique Crunch ": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Stability Ball Elbow Plank": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Feet Elevated Push Up": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Turkish Sit Up": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Dumbbell Turkish Sit Up": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Landmine Turkish Sit Up": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Turkish Sit Up": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Dumbbell Turkish Sit Up": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Turkish Sit Up to Z Press": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "Anterior Deltoids",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Front Rack Alternating Cossack Squat": {
      "target-muscle": "Adductors",
      "primary-muscle": "Adductor Magnus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Dumbbell Front Rack Alternating Cossack Squat": {
      "target-muscle": "Adductors",
      "primary-muscle": "Adductor Magnus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Swing": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "Biceps Femoris",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Front Rack Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Front Rack Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Front Rack Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Front Rack Carry": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Front Rack Alternating Cossack Squat": {
      "target-muscle": "Adductors",
      "primary-muscle": "Adductor Magnus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Squat Clean": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Stability Ball Feet Elevated Parallette Push Up": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Stability Ball Feet Elevated Parallette Plank": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Stability Ball Feet Elevated Single Arm Parallette Plank": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Stability Ball Feet Elevated Alternating Single Arm Parallette Plank": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Archer Push Up": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Parallette Archer Push Up": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Parallette Wide Push Up": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Suitcase Knee Over Toes Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Alternating Front Raise": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Pectoralis Major",
      "tertiary-muscle": "Biceps Brachii",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Front Raise": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Pectoralis Major",
      "tertiary-muscle": "Biceps Brachii",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Cable Front Raise": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Pectoralis Major",
      "tertiary-muscle": "Biceps Brachii",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Cable Straight Bar Front Raise": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Pectoralis Major",
      "tertiary-muscle": "Biceps Brachii",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Kettlebell Bottoms Up Horn Grip Standing Bicep Curl": {
      "target-muscle": "Biceps",
      "primary-muscle": "Biceps Brachii",
      "secondary-muscle": "Brachialis",
      "tertiary-muscle": "Brachioradialis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Bottoms Up Front Rack Carry": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Front Rack Carry": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Overhead Walking Lunge": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Bottoms Up Front Rack Walking Lunge": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Half Kneeling Contralateral Bottoms Up Overhead Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Kneeling Rollout": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Close Grip Bench Press": {
      "target-muscle": "Triceps",
      "primary-muscle": "Triceps Brachii",
      "secondary-muscle": "Pectoralis Major",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Suspension Chest Press": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "Rectus Abdominis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Cable Tall Kneeling Pallof Press": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Rectus Abdominis",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Cable Bicep Curl": {
      "target-muscle": "Biceps",
      "primary-muscle": "Biceps Brachii",
      "secondary-muscle": "Brachialis",
      "tertiary-muscle": "Brachioradialis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Cable Reverse Straight Bar Curl": {
      "target-muscle": "Forearms",
      "primary-muscle": "Brachioradialis",
      "secondary-muscle": "Biceps Brachii",
      "tertiary-muscle": "Brachialis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Cable Shotgun Row": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "Biceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Hang Power Clean": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Landmine Goblet Cossack Squat": {
      "target-muscle": "Adductors",
      "primary-muscle": "Adductor Magnus",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Landmine Low Handle Cossack Squat": {
      "target-muscle": "Adductors",
      "primary-muscle": "Adductor Magnus",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Shoulder Stand": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "Rectus Abdominis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Strap Handstand": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "Rectus Abdominis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Handstand": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "Rectus Abdominis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Pike Headstand Push Up": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Feet Elevated Pike Headstand Push Up": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Wall Headstand Push Up": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Freestanding Headstand Push Up": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Bulgarian Handstand Push Up": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Strap Handstand Push Up": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Freestanding Handstand Push Up": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Bent Arm Press Handstand": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Parallette L Sit to Bent Arm Press Handstand": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Chest Roll to Straight Body Press Handstand": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Bent Arm Bent Body Press Handstand": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Dip to Handstand": {
      "target-muscle": "Triceps",
      "primary-muscle": "Triceps Brachii",
      "secondary-muscle": "Anterior Deltoids",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Handstand to Elbow Lever to Handstand": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Dip Straight Body Press to Handstand": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Wall Straddle Press Handstand Eccentrics": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Straddle Stand Press Handstand ": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Pike Stand Press Handstand": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Parallette L Sit Straddle Press Handstand": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Parallette L Sit Pike Press Handstand": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Straight Arm L Sit Straddle Press Handstand": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Straight Arm Pike Press Handstand": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Tuck L Sit": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Parallette Straddle L Sit": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Turned Out L Sit": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Skin The Cat": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Manna ": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Tuck Back Lever": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Advanced Tuck Back Lever": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Straddle Back Lever": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Half Layout Back Lever": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring 1 Leg Out Back Lever": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Full Back Lever": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Back Lever Pullout": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring German Hang Pullout": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Handstand Lower to Back Lever": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Tuck Front Lever": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Advanced Tuck Front Lever": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Straddle Front Lever": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Half Layout Front Lever": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring 1 Leg Out Front Lever": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Full Front Lever": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Front Lever Pull to Inverted Hang": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Inverted Hang": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Barbell Kneeling Rollout": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Barbell Standing Rollout": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Circle Front Lever": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Tuck Front Lever Pull Up": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Advanced Tuck Front Lever Pull Up": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Straddle Front Lever Pull Up": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Dead Hang to Front Lever Pull Up": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Full Front Lever Pull Up": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Row Feet Elevated": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "Biceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Bulgarian Row Feet Elevated": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "Biceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Archer Row Feet Elevated": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "Biceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Ring Row Feet Elevated ": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "Biceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring L Sit Pull Up": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "Biceps Brachii",
      "tertiary-muscle": "Rectus Abdominis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Bulgarian Pull Up": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "Biceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Bulgarian L Sit Pull Up": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "Biceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Plank": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Ring Plank": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Push Up": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Ring Push Up": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Support Hold": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Side Plank": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Rectus Abdominis ",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring L Sit Muscle Up": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Strict Muscle Up": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Chest Fly": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Barbell Bicep Curl": {
      "target-muscle": "Biceps",
      "primary-muscle": "Biceps Brachii",
      "secondary-muscle": "Brachialis",
      "tertiary-muscle": "Brachioradialis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Hollow Rock ": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Dumbbell Power Snatch": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Single Arm Dumbbell Power Snatch": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Dumbbell Squat Snatch": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Single Arm Dumbbell Squat Snatch": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Cable Single Leg Romanian Deadlift": {
      "target-muscle": "Hamstrings",
      "primary-muscle": "Biceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Single Leg Romanian Deadlift ": {
      "target-muscle": "Hamstrings",
      "primary-muscle": "Biceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Romanian Deadlift ": {
      "target-muscle": "Hamstrings",
      "primary-muscle": "Biceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Single Leg Romanian Deadlift": {
      "target-muscle": "Hamstrings",
      "primary-muscle": "Biceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Cable Wide Grip Lat Pulldown": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Cable Reverse Grip Lat Pulldown": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Cable Seated V Grip Lat Pulldown": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Cable Half Kneeling Face Pull": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Infraspinatus",
      "tertiary-muscle": "Teres Minor",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Landmine Half Knee Hover Shoulder Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Seated Good Morning": {
      "target-muscle": "Back",
      "primary-muscle": "Erector Spinae",
      "secondary-muscle": "Biceps Femoris",
      "tertiary-muscle": "Gluteus Maximus",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Bodyweight Hip Thrust": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Bottoms Up Overhead Squat": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Stability Ball Dumbbell Seated Alternating Lateral Raise": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Medial Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Dumbbell Bench Press": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Bench Press": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Incline Bench Press": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Stability Ball Dumbbell W Raise": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Side Plank Reach Through": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Rectus Abdominis ",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Dumbbell Contralateral Overhead Bulgarian Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Dumbbell Contralateral Overhead Knee Over Toes Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Z Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Clean": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Snatch": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Push Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Split Jerk": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Clean and Jerk": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell High Pull": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Sumo Deadlift": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "Biceps Femoris",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bent Over Row": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Front Rack Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Front Rack Knee Over Toes Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Overhead Knee Over Toes Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Thruster": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Front Rack Alternating Cossack Squat": {
      "target-muscle": "Adductors",
      "primary-muscle": "Adductor Magnus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Overhead Alternating Cossack Squat": {
      "target-muscle": "Adductors",
      "primary-muscle": "Adductor Magnus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Tall Kneeling Overhead Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Front Rack Walking Lunge": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Overhead Walking Lunge": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Alternating Sots Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Shrug": {
      "target-muscle": "Trapezius ",
      "primary-muscle": "Upper Trapezius",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Hang Squat Clean": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Hollow Hold": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Hollow Hold With Flutter Kick": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Dead Clean to Push Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Pendlay Row": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "Biceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Front Rack Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Front Rack Bulgarian Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Overhead Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Half Kneeling Overhead Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Front Rack Cyclist Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Front Rack Reverse Lunge": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Front Rack Step Up": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Contralateral Overhead Knee Over Toes Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Dead Clean to Rotational Overhead Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Rotational Overhead Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Sumo Deadlift": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Contralateral Front Rack Knee Over Toes Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Push Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Push Jerk": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Seated Overhead Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Z Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Contralateral Split Squat Thruster": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Split Squat Thruster": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Kettlebell Swing": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Single Arm Kettlebell Swing": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Single Arm Kettlebell Clean": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Single Arm Kettlebell Snatch": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Sots Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Bottoms Up Contralateral Overhead Knee Over Toes Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Staggered Stance Swing": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Single Arm Kettlebell Staggered Stance Swing": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Half Kneeling Swing": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Half Kneeling Contralateral Bottoms Up Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Outside Swing": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Outside Snatch": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Outside Clean": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Outside Clean and Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Side Swing": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Parallette Push Up With Alternating Shoulder Taps": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Parallette Tuck Planche": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "Biceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Parallette Dive Bomber Push Up": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dive Bomber Push Up": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Parallette L Sit to Tuck Planche": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Dumbbell Prone Row": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Landmine Standing Oblique Twist": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Cable Tall Kneeling High to Low Chop": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Parallette Plank": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Suspension Plank": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Battle Rope Russian Twist": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Bird Dog Knee to Elbow": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "Obliques",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Slam Ball Russian Twist Feet Elevated": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Rectus Abdominis ",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Medicine Ball Russian Twist Feet Elevated": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Rectus Abdominis ",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Kettlebell Feet Elevated Russian Twist": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Rectus Abdominis ",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Parallette Plank Alternating Knee to Elbow": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Forearm Plank Knee to Elbow": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Loaded Beast to Alternating Kick Through": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring False Grip Pull Up": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Clean to Press Windmill": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Rectus Abdominis",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Half Kneeling Windmill": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Rectus Abdominis ",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Battle Rope Russian Twist Feet Elevated": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Rectus Abdominis ",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Superband Dead Bug": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Parallette V Sit": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Parallette Tuck V Sit": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Staggered Stance Push Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Front Rack Skater Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Kettlebell Goblet Skater Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Front Rack Pistol Squat to Box": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Front Rack Pistol Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Overhead Alternating Reverse Lunge": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Superband Standing Pallof Press": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Superband Half Kneeling Pallof Press": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Superband Hip External Rotation (90 Degree)": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "Gluteus Medius",
      "tertiary-muscle": "Gluteus Minimus",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Prone Row": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Renegade Row Push Up": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Landmine Row to Rotational Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Assisted Skater Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Superband Pull Through": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Miniband Quadruped Hip Extension": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Cable Hip Adduction": {
      "target-muscle": "Adductors",
      "primary-muscle": "Adductor Magnus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Superband Tall Kneeling Pallof Press": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Slider Eccentric Hamstring Curl": {
      "target-muscle": "Hamstrings",
      "primary-muscle": "Biceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Landmine Lateral Lunge": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Renegade Row ": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Dumbbell Cuban Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Infraspinatus",
      "tertiary-muscle": "Teres Minor",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Slider Parallette Knee Tuck": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Supinated Shoulder Front Raise": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Pectoralis Major",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Pike Feet Elevated Handstand Push Up": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Parallette Straddle Press to Handstand": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring L Sit": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Tuck Back Lever With Alternating Single Leg Extensions": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Tuck Front Lever With Alternating Single Leg Extensions": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Hollow Hold With Flutter Kick": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Front Rack Cyclist Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Back Cyclist Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Inverted Crunch With Gravity Boots": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Renegade Row Push Up": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Bird Dog Single Arm Kettlebell Row": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "Rectus Abdominis ",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Back Rack Step Up": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Front Rack Step Up": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Standing Rollout": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Stability Ball Cable Russian Twist": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Miniband Frog Pump": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Miniband Knee Hover Quadruped Fire Hydrant": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "Gluteus Medius",
      "tertiary-muscle": "Gluteus Minimus",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Fire Hydrant": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "Gluteus Medius",
      "tertiary-muscle": "Gluteus Minimus",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Knee Hover Quadruped Fire Hydrant": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "Gluteus Medius",
      "tertiary-muscle": "Gluteus Minimus",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Seated Reverse Wrist Curl": {
      "target-muscle": "Forearms",
      "primary-muscle": "Brachioradialis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Seated Wall Angels": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Infraspinatus",
      "tertiary-muscle": "Teres Minor",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Bent Knee Copenhagen Plank Side Raise": {
      "target-muscle": "Adductors",
      "primary-muscle": "Adductor Magnus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Kneeling Side Plank": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Rectus Abdominis",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Assisted Hip Airplane": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Medius",
      "secondary-muscle": "Gluteus Minimus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Superband Single Leg Ankle Dorsiflexion": {
      "target-muscle": "",
      "primary-muscle": "Tibialis Anterior",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Zercher Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Squat Snatch": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "Biceps Femoris",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Push Jerk": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "Biceps Femoris",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Clean and Jerk": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "Biceps Femoris",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Incline Bench Press": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Hang Squat Clean Thruster": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Squat Clean Thruster": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Copenhagen Plank": {
      "target-muscle": "Adductors",
      "primary-muscle": "Adductor Magnus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Bent Knee Copenhagen Plank": {
      "target-muscle": "Adductors",
      "primary-muscle": "Adductor Magnus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Parallette Kneeling Close Grip Tricep Push Up": {
      "target-muscle": "Triceps",
      "primary-muscle": "Triceps Brachii",
      "secondary-muscle": "Pectoralis Major",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Miniband Single Leg Hip Thrust": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Deficit Snatch Grip Deadlift": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Ring Chin Up Eccentrics": {
      "target-muscle": "Biceps",
      "primary-muscle": "Biceps Brachii",
      "secondary-muscle": "Latissimus Dorsi",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Assisted Foot Elevated Knee Over Toes Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Foot Elevated Knee Over Toes Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Clean to Overhead Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "Gluteus Minimus",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Bent Leg Windmill": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Kettlebell Alternating Halo to Goblet Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Half Kneeling Overhead Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Seesaw Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Side to Side Swing": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Half Kneeling Clean to Side Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Rectus Abdominis",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Parallette Feet Elevated Pike Push Up": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Parallette Handstand": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Parallette L Sit to Handstand": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Straddle L Sit": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Parallette Stalder Press to Handstand": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Rectus Abdominis",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Gironda Sternum Chin Up": {
      "target-muscle": "Biceps",
      "primary-muscle": "Biceps Brachii",
      "secondary-muscle": "Latissimus Dorsi",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Archer Push Up": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Ring Chin Up": {
      "target-muscle": "Biceps",
      "primary-muscle": "Biceps Brachii",
      "secondary-muscle": "Latissimus Dorsi",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring L Sit Archer Pull Up": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "Biceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Single Arm Parallette Push Up": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Incline Bench Prone Y Raise": {
      "target-muscle": "Trapezius ",
      "primary-muscle": "Lower Trapezius",
      "secondary-muscle": "Posterior Deltoids",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Cable Kneeling Shoulder External Rotation": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Infraspinatus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Suspension Face Pull to Overhead Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Infraspinatus",
      "tertiary-muscle": "Teres Minor",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Superband Assisted Muscle Up": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Stability Ball Sit Up": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Bottoms Up Turkish Get Up": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Rectus Abdominis",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Thruster": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Double Kettlebell Thruster": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Scapular Pull Up": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "Rhomboids",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Side Lying Hip Adduction": {
      "target-muscle": "Adductors",
      "primary-muscle": "Adductor Magnus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Superband Hollow Body Hold": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Suspension Y Raise": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Slider Single Leg Eccentric Hamstring Curl ": {
      "target-muscle": "Hamstrings",
      "primary-muscle": "Biceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Reverse Grip Bench Press": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Reverse Grip Bench Press": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Side Plank Superband Hanging Adduction": {
      "target-muscle": "Adductors",
      "primary-muscle": "Adductor Magnus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Cable Seated Floor Lat Pulldown": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "Biceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Resistance Band Half Kneeling Cuban Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Stability Ball Feet Elevated Frog Pump": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Stability Ball Feet Elevated Frog Pump With Miniband": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Bottoms Up Clean to Overhead Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Overhead Cyclist Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Front Rack Cyclist Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Overhead Cyclist Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Cuban Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Cyclist Thruster": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Tactical Snatch": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Single Arm Landmine Thruster": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Dumbbell Cyclist Thruster": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Single Arm Landmine Cyclist Thruster": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Low Bar Cyclist Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Low Bar Pause Cyclist Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Snatch to Overhead Reverse Lunge": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Snatch to Overhead Reverse Lunge": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Clean to Front Rack Reverse Lunge": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Clean to Front Rack Reverse Lunge": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Split Jerk": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Single Arm Kettlebell Split Jerk": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Kettlebell Swing to Bottoms Up Horn Grip Goblet Squat": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Clean to Front Rack Squat": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Overhead Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Thruster": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Bottoms Up Tactical Snatch ": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Bottoms Up Z Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Z Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Sots Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Double Kettlebell Sots Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Bottoms Up Sots Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Sots Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Double Kettlebell Bottoms Up Sots Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Seesaw Sots Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Seesaw Sots Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Double Kettlebell Z Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Seesaw Z Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Seesaw Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Seesaw Z Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Snatch": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Single Arm Kettlebell Bottoms Up Snatch": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Single Arm Kettlebell Around the World High Catch": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Single Arm Kettlebell Tall Kneeling Around the World High Catch": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Around the World": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Single Arm Kettlebell Around the World": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Tall Kneeling Around the World": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Single Arm Tall Kneeling Around the World": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Waiter Clean": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Waiter Clean Hot Potato": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Single Arm Kettlebell Waiter Clean": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Waiter Clean": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Kettlebell Swing to Alternating Single Arm Waiter Hold": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Waiter Clean to Overhead Press": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Tactical Waiter Clean": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Tactical Waiter Clean to Overhead Press": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "Anterior Deltoids",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Waiter Clean to Alternating Overhead Press": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "Anterior Deltoids",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Waiter Snatch": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Single Arm Kettlebell Waiter Snatch": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Tactical Waiter Snatch": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Waiter Snatch": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Waiter Clean to Thruster": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Kettlebell Start Stop Swing": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Dead Clean": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Half Kneeling Side Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Rectus Abdominis",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Bottoms Up Thruster": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Double Kettlebell Bottoms Up Thruster": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Dead Clean": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Single Arm Kettlebell Dead Clean": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Push Up to L Sit": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Rectus Abdominis",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Parallette Push Up to L Sit": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Rectus Abdominis",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Bottoms Up Half Kneeling Windmill": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Rectus Abdominis ",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Single Arm Kettlebell Half Kneeling Around the World High Catch": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Start Stop Squat Clean Thruster": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Single Arm Kettlebell Start Stop Squat Clean Thruster": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Start Stop Squat Clean Thruster": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Single Leg Standing Bent Knee Overhead Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Bent Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Barbell Bent Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Single Arm Kettlebell Around the World High Catch to Squat": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Cossack Squat Thruster": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Adductor Magnus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Cossack Squat Thruster": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Adductor Magnus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Alternating Cossack Squat Thruster": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Adductor Magnus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Single Arm Kettlebell Bottoms Up Clean to Overhead Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Clean to Overhead Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Overhead Knee Over Toes Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Overhead Knee Over Toes Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Bottoms Up Overhead Knee Over Toes Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Overhead Bulgarian Split Squat ": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Bulgarian Split Squat Thruster": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "Gluteus Maximus",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Barbell Overhead Bulgarian Split Squat ": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Swing to Bottoms Up Horn Grip Goblet Squat": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Overhead Pistol Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Front Rack Pistol Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Overhead Pistol Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Standing Wall Angels": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Infraspinatus",
      "tertiary-muscle": "Teres Minor",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Clean to Sots Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Clean to Sots Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Plate Lu Raise": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Infraspinatus",
      "secondary-muscle": "Posterior Deltoids",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Plate Windmill": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Rectus Abdominis ",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Plate Turkish Get Up": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Rectus Abdominis",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Plate Steering Wheel": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Kettlebell Half Kneeling Alternating Halo": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Posterior Deltoids",
      "tertiary-muscle": "Medial Deltoids",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Kettlebell Tall Kneeling Alternating Halo": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Posterior Deltoids",
      "tertiary-muscle": "Medial Deltoids",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Kettlebell Tall Kneeling Alternating Hip to Halo": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Posterior Deltoids",
      "tertiary-muscle": "Medial Deltoids",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Clean to Thruster": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Single Leg Standing Bent Knee Overhead Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Single Leg Standing Bent Knee Overhead Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Single Leg Standing Bent Knee Contralateral Overhead Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Suspension Single Leg Standing Bent Knee Reverse Fly": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Suspension Reverse Fly": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Suspension Single Leg Standing Bent Knee Y Raise": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Suspension Single Leg Standing Bent Knee Face Pull": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Infraspinatus",
      "tertiary-muscle": "Teres Minor",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Suspension Single Leg Standing Bent Knee Face Pull to Overhead Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Infraspinatus",
      "tertiary-muscle": "Teres Minor",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Bottoms Up Single Leg Standing Bent Knee Contralateral Overhead Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Overhead Bulgarian Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Bottoms Up Overhead Contralateral Bulgarian Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Suitcase Contralateral Bulgarian Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Suitcase Ipsilateral Bulgarian Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Front Rack Bulgarian Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Suitcase Bulgarian Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bulgarian Split Squat Thruster ": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "Gluteus Maximus",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Bulgarian Split Squat Thruster": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "Gluteus Maximus",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Bottoms Up Front Rack Contralateral Bulgarian Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Front Rack Contralateral Bulgarian Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Bottoms Up Front Rack Ipsilateral Bulgarian Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Front Rack Ipsilateral Bulgarian Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Bottoms Up Single Leg Standing Bent Knee Ipsilateral Overhead Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Overhead Pistol Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Suspension Cuban Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Suspension Single Leg Standing Bent Knee Cuban Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Turkish Get Up": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "Obliques",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Barbell Overhead Knee Over Toes Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Barbell Knee Over Toes Split Squat Thruster": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "Gluteus Maximus",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Knee Over Toes Split Squat Thruster": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "Gluteus Maximus",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Knee Over Toes Split Squat Thruster": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "Gluteus Maximus",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Knee Over Toes Split Squat Thruster": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "Gluteus Maximus",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Overhead Knee Over Toes Split Squat ": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Bottoms Up Knee Over Toes Split Squat Thruster": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "Gluteus Maximus",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Barbell Bulgarian Split Squat Thruster": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "Gluteus Maximus",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Barbell Windmill": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Rectus Abdominis",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Bodyweight Bent Leg Windmill": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Bodyweight Windmill": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Superband Half Knee Hover Pallof Press": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Barbell Turkish Get Up": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Rectus Abdominis",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Barbell Single Leg Standing Bent Knee Contralateral Overhead Press ": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Rectus Abdominis",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Barbell Single Leg Standing Bent Knee Ipsilateral Overhead Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Rectus Abdominis",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Kettlebell Bottoms Up Horn Grip Goblet Bulgarian Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Snatch to Overhead Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Half Kneeling Dead Clean": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Half Kneeling Clean": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Half Kneeling Snatch": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Front Rack Alternating Curtsy Lunge": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Front Rack Squat to Alternating Curtsy Lunge": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Kettlebell Bottoms Up Horn Grip Toe Balance Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Contralateral Single Leg Push Up": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Rectus Abdominis",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Barbell Overhead Toe Balance Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Overhead Toe Balance Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Dead Squat Clean": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Dead Squat Clean": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Kneeling Rollout": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Ring Kneeling Rollout": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Standing Rollout": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Alternating Single Arm Reach Push Up": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Rectus Abdominis",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring L Sit Dips": {
      "target-muscle": "Triceps",
      "primary-muscle": "Triceps Brachii ",
      "secondary-muscle": "Rectus Abdominis ",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Kettlebell Goblet Cyclist Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Kettlebell Bottoms Up Horn Grip Cyclist Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Bottoms Up Front Rack Cyclist Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Dead Clean to Overhead Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Dead Clean to Thruster": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "Gluteus Maximus",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Dead Snatch": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Single Arm Kettlebell Dead Snatch": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Dead Snatch": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Decline Bench Press": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "Anterior Deltoids",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Assisted Bodyweight Bulgarian Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Bodyweight Bulgarian Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Stability Ball Otis Up": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Plate Otis Up": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Otis Up": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Otis Up": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Kettlebell Horn Grip Otis Up": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Otis Up": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Bottoms Up Otis Up": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Bottoms Up Turkish Sit Up": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Turkish Sit Up": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Turkish Sit Up to Z Press": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Turkish Sit Up to Z Press": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Bottoms Up Turkish Sit Up to Z Press": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Decline Bench Press": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Flat Bench Chest Fly": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Decline Bench Chest Fly": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Alternating Rotational Overhead Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Clean to Alternating Rotational Overhead Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Rotational Thruster": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Single Arm Kettlebell Clean to Rotational Thruster": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Overhead Alternating Cossack Squat": {
      "target-muscle": "Adductors",
      "primary-muscle": "Adductor Magnus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Single Arm Kettlebell Clean to Rotational Overhead Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Single Arm Kettlebell Bottoms Up Clean to Rotational Overhead Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Clean to Alternating Rotational Overhead Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Dead Clean": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Dead Clean to Overhead Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Dead Clean to Thruster": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "Gluteus Maximus",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Dead Clean to Alternating Rotational Overhead Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Dead Clean to Alternating Rotational Thruster": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "Gluteus Maximus",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Dead Clean to Alternating Rotational Overhead Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Dead Clean to Alternating Rotational Thruster": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "Gluteus Maximus",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Ring Chin Up": {
      "target-muscle": "Biceps",
      "primary-muscle": "Biceps Brachii",
      "secondary-muscle": "Latissimus Dorsi",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Windmill": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Rectus Abdominis",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Suspension Single Leg Standing Bent Knee Contralateral Low Row": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "Biceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Suspension Single Leg Standing Bent Knee Ipsilateral Low Row": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "Biceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Suspension Single Leg Standing Bent Knee Bicep Curl": {
      "target-muscle": "Biceps",
      "primary-muscle": "Biceps Brachii",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Suspension Single Leg Bent Knee Contralateral Bicep Curl": {
      "target-muscle": "Biceps",
      "primary-muscle": "Biceps Brachii",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Suspension Single Leg Bent Knee Ipsilateral Bicep Curl": {
      "target-muscle": "Biceps",
      "primary-muscle": "Biceps Brachii",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Plate Teacup": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Anterior Deltoids",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring L Sit Chin Up": {
      "target-muscle": "Biceps",
      "primary-muscle": "Biceps Brachii",
      "secondary-muscle": "Latissimus Dorsi",
      "tertiary-muscle": "Rectus Abdominis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Ring L Sit Chin Up": {
      "target-muscle": "Biceps",
      "primary-muscle": "Biceps Brachii",
      "secondary-muscle": "Latissimus Dorsi",
      "tertiary-muscle": "Rectus Abdominis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Front Rack Bulgarian Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Back Rack Bulgarian Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Suspension Contralateral Pistol Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Front Rack Alternating Curtsy Lunge": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dragon Flag": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Dragon Flag": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Iron Cross": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "Biceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Parallette Tuck Planche Push Up": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "Rectus Abdominis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Parallette Full Planche": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Parallette Full Planche Push Up": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "Rectus Abdominis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Inverted Iron Cross": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "Biceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Maltese Push Up": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Tuck Planche": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "Biceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Tuck Planche Push Up": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "Rectus Abdominis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Full Planche": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Full Planche Push Up": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "Rectus Abdominis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Grip Full Planche Push Up": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "Rectus Abdominis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Grip Full Planche": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Bodyweight Full Planche": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Cable Quadruped Hip Abduction": {
      "target-muscle": "Abductors",
      "primary-muscle": "Gluteus Medius",
      "secondary-muscle": "Gluteus Minimus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Alternating Push Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Front Rack 90-90 Hip Shift to Alternating Overhead Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Parallette L Sit to Tuck Planche Push Up": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "Rectus Abdominis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring L Sit to Tuck Planche Push Up": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "Rectus Abdominis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Parallette Straddle Planche": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Parallette Straddle Planche Push Up": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "Rectus Abdominis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Straddle Planche": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Straddle Planche Push Up": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "Rectus Abdominis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Turkish Sit Up": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Plate Turkish Sit Up": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Seated Overhead Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Barbell Turkish Sit Up": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Crush Grip Romanian Deadlift": {
      "target-muscle": "Hamstrings",
      "primary-muscle": "Biceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Pelican Curl": {
      "target-muscle": "Biceps",
      "primary-muscle": "Biceps Brachii",
      "secondary-muscle": "Pectoralis Major",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Kettlebell Dead Bug": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Bottoms Up Copenhagen Plank": {
      "target-muscle": "Adductors",
      "primary-muscle": "Adductor Magnus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Chin Up": {
      "target-muscle": "Biceps",
      "primary-muscle": "Biceps Brachii",
      "secondary-muscle": "Latissimus Dorsi",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Two Finger Chin Up": {
      "target-muscle": "Biceps",
      "primary-muscle": "Biceps Brachii",
      "secondary-muscle": "Latissimus Dorsi",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Crush Grip Bent Over Row": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "Biceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Front Rack Walking Lunge": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Crush Grip Bicep Curl to Overhead Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Biceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Crush Grip Overhead Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Crush Grip Hollow Body Hold Flutter Kicks": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Crush Grip Floor Chest Press": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Parallette Crow Pose": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Crush Grip Z Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Kettlebell Dead Clean to Horn Grip Goblet Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Crush Grip Standing Overhead Tricep Extension": {
      "target-muscle": "Triceps",
      "primary-muscle": "Triceps Brachii ",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Front Rack Alternating Cossack Squat Hold to Overhead Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "Gluteus Maximus",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Front Rack March": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Overhead March": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Alternating Contralateral Overhead Press March": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Rectus Abdominis",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Half Kneeling Overhead Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Tall Kneeling Overhead Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Tactical Clean": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Overhead March": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Barbell Overhead March": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Overhead Adductor Slide": {
      "target-muscle": "Adductors",
      "primary-muscle": "Adductor Magnus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Front Rack Adductor Slide": {
      "target-muscle": "Adductors",
      "primary-muscle": "Adductor Magnus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Front Rack Adductor Slide": {
      "target-muscle": "Adductors",
      "primary-muscle": "Adductor Magnus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Bodyweight Adductor Slide": {
      "target-muscle": "Adductors",
      "primary-muscle": "Adductor Magnus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Parallette Plyometric Push Up": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Parallette Plyometric Clapping Push Up": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Single Arm Kettlebell Ballistic Row": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "Biceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Front Rack Pivot Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Front Rack Pivot Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Overhead Pivot Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Front Rack Pivot Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Bodyweight Row Feet Elevated": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "Biceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Bodyweight Row": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "Biceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Row": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "Biceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Bulgarian Row": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "Biceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Kettlebell Half Kneeling Rotational Swing": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Rectus Abdominis",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Push Jerk": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Clean to Push Jerk": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Slider Barbell Overhead Reverse Lunge": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Slider Single Arm Barbell Overhead Reverse Lunge": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Pseudo Planche Push Up": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Anterior Deltoids",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Parallette Pseudo Planche Push Up": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Anterior Deltoids",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Kettlebell Half Knee Hover Low to High Chop": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Rectus Abdominis",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Kettlebell Half Knee Hover Alternating Halo": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Posterior Deltoids",
      "tertiary-muscle": "Medial Deltoids",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Front Rack March": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Suitcase March": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Rotational Snatch": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Staggered Stance Romanian Deadlift": {
      "target-muscle": "Hamstrings",
      "primary-muscle": "Biceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Staggered Stance Romanian Deadlift": {
      "target-muscle": "Hamstrings",
      "primary-muscle": "Biceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Contralateral Staggered Stance Romanian Deadlift": {
      "target-muscle": "Hamstrings",
      "primary-muscle": "Biceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Hanging Knees to Elbows": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Staggered Stance Overhead Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Dead Clean to Front Rack Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Superband Assisted Nordic Hamstring Curl": {
      "target-muscle": "Hamstrings",
      "primary-muscle": "Biceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Front Rack Alternating Shin Box Hip Extension to Overhead Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Bodyweight Alternating Shin Box to Hip Extension": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Overhead Alternating Shin Box to Hip Extension": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Turkish Get Up": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "Obliques",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Kettlebell Staggered Stance Rotational Swing": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Rectus Abdominis",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Suitcase Curtsy Lunge": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Suitcase Alternating Curtsy Lunge Pass Through": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Suitcase Walking Lunge Pass Through": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Bench Press": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Overhead Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Overhead Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Suitcase Carry": {
      "target-muscle": "Forearms",
      "primary-muscle": "Brachioradialis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Suitcase Carry": {
      "target-muscle": "Forearms",
      "primary-muscle": "Brachioradialis",
      "secondary-muscle": "Obliques",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Dumbbell Suitcase Carry": {
      "target-muscle": "Forearms",
      "primary-muscle": "Brachioradialis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Glute Bridge Bench Press": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "Anterior Deltoids",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Glute Bridge Bench Press": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Single Leg Glute Bridge Bench Press": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Bodyweight Foot Elevated Cossack Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Adductor Magnus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Kettlebell Goblet Foot Elevated Cossack Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Adductor Magnus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Overhead Foot Elevated Cossack Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Adductor Magnus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Landmine Half Knee Hover Oblique Twist": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Single Arm Kettlebell Knee Hover Quadruped Pull Through": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "Obliques",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Back Rack Foot Elevated Cossack Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Adductor Magnus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Front Rack Foot Elevated Cossack Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Adductor Magnus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Cable Seated Floor V Grip Lat Pulldown": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Overhead Low Switch Cossack Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Adductor Magnus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell High Pull": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Suitcase Deficit Bulgarian Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Single Arm Kettlebell Front Rack Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Single Arm Kettlebell Thruster": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Suitcase Knee Over Toes Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Sumo Deadlift to Push Up": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "Pectoralis Major",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Single Arm Kettlebell Clean to Thruster": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Battle Rope Half Knee Hover Alternating Side Slam": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Rectus Abdominis ",
      "tertiary-muscle": "Quadriceps Femoris",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Superband Standing Adduction": {
      "target-muscle": "Adductors",
      "primary-muscle": "Adductor Magnus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Superband Lateral Adduction Steps": {
      "target-muscle": "Adductors",
      "primary-muscle": "Adductor Magnus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Bottoms Up Copenhagen Plank Side Raise": {
      "target-muscle": "Adductors",
      "primary-muscle": "Adductor Magnus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Single Leg Balance Transfer": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "Gluteus Medius",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Bosu Ball Single Arm Kettlebell Single Leg Balance Transfer": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "Gluteus Medius",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Suitcase Foot Elevated Knee Over Toes Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "Rectus Abdominis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Suitcase Knee Over Toes Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "Rectus Abdominis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Suspension Cossack Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Adductor Magnus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Battle Rope Single Leg Balance Alternating Wave": {
      "target-muscle": "Biceps",
      "primary-muscle": "Biceps Brachii",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Battle Rope Alternating Wave": {
      "target-muscle": "Biceps",
      "primary-muscle": "Biceps Brachii",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Battle Rope Half Knee Hover Alternating Wave": {
      "target-muscle": "Biceps",
      "primary-muscle": "Biceps Brachii",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Superband Assisted Dips": {
      "target-muscle": "Chest",
      "primary-muscle": "Pectoralis Major",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Cable Tall Kneeling Face Pull": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Infraspinatus",
      "tertiary-muscle": "Teres Minor",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Suspension Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Suitcase Deadlift": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "Biceps Femoris",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Suspension Cyclist Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Cable Rope Tall Kneeling Tricep Pushdown": {
      "target-muscle": "Triceps",
      "primary-muscle": "Triceps Brachii ",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Cable Rope Staggered Stance Tricep Pushdown": {
      "target-muscle": "Triceps",
      "primary-muscle": "Triceps Brachii ",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Suspension Single Arm Contralateral Skater Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Clean": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Single Arm Kettlebell Feet Elevated Plank Pull Through": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "Obliques",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Clean to Alternating Thruster": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "Gluteus Maximus",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Clean to Alternating Overhead Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Bodyweight Cyclist Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Clean to Thruster": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Clean to Alternating Thruster": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Clean to Alternating Overhead Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachii",
      "tertiary-muscle": "Gluteus Minimus",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Clean to Split Jerk": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Clean to Split Jerk": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Clean to Split Jerk": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Single Arm Kettlebell Clean to Split Jerk": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Bottoms Up Clean to Split Jerk": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Single Arm Kettlebell Bottoms Up Clean to Split Jerk": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Bottoms Up Split Jerk": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Bottoms Up Split Jerk": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Single Arm Kettlebell Bottoms Up Clean": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Bottoms Up Clean": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Slider Single Leg Hamstring Curl": {
      "target-muscle": "Hamstrings",
      "primary-muscle": "Biceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Single Arm Kettlebell Bottoms Up Clean to Thruster": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Suspension Cyclist Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Single Arm Kettlebell Bottoms Up Clean to Front Rack Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Split Squat Thruster": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Low Bar Pause Back Squat": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "Biceps Femoris",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Pause Front Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell High Bar Pause Back Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Overhead Pause Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Suitcase Alternating Reverse Lunge": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Ring Hanging Knees to Wrists": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Suspension Adductor Slide": {
      "target-muscle": "Adductors",
      "primary-muscle": "Adductor Magnus",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Single Arm Kettlebell Sumo Deadlift": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Dumbbell Goblet Cyclist Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Front Rack Adductor Slide": {
      "target-muscle": "Adductors",
      "primary-muscle": "Adductor Magnus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Back Rack Adductor Slide": {
      "target-muscle": "Adductors",
      "primary-muscle": "Adductor Magnus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Overhead Alternating Cossack Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Adductor Magnus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Overhead Alternating Reverse Lunge": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Overhead Press to Alternating Reverse Lunge": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "Gluteus Minimus",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Miniband Side Plank Hip Abduction": {
      "target-muscle": "Abductors",
      "primary-muscle": "Gluteus Medius",
      "secondary-muscle": "Gluteus Minimus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Slider Double Kettlebell Suitcase Reverse Lunge": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Slider Double Kettlebell Front Rack Reverse Lunge": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Slider Double Kettlebell Overhead Reverse Lunge": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Suitcase March": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Bottoms Up Overhead March": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Bottoms Up Front Rack March": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Parallette Close Grip Single Leg Push Up": {
      "target-muscle": "Triceps",
      "primary-muscle": "Triceps Brachii",
      "secondary-muscle": "Pectoralis Major",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Half Snatch": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Single Arm Kettlebell Half Snatch": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Half Snatch": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Half Snatch to Thruster": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Single Arm Kettlebell Half Snatch to Thruster": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Bottoms Up Overhead Cossack Squat": {
      "target-muscle": "Adductors",
      "primary-muscle": "Adductor Magnus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Kettlebell Goblet Horse Stance Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Suspension Alternating Curtsy Lunge": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Alternating Forward Lunge Snatch": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "Anterior Deltoids",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Front Rack Alternating Forward Lunge": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Front Rack Alternating Reverse Lunge": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Overhead Alternating Forward Lunge": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Macebell 360": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Rectus Abdominis",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Macebell 360": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Rectus Abdominis",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Macebell 10 to 2 ": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Rectus Abdominis",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Macebell Barbarian Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Posterior Deltoids",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Macebell Barbarian Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Posterior Deltoids",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Macebell Ballistic Curl": {
      "target-muscle": "Biceps",
      "primary-muscle": "Biceps Brachii",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Macebell Single Leg Standing Ballistic Curl": {
      "target-muscle": "Biceps",
      "primary-muscle": "Biceps Brachii",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Macebell Half Knee Hover Low to High Chop": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Rectus Abdominis",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Macebell Single Leg Standing Bent Knee 360": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Rectus Abdominis",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Indian Club Outer Heart Shaped Swing": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Indian Club Outer Heart Shaped Swing": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Macebell Front Swing to 360": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Rectus Abdominis",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Macebell Alternating Front Swing to 360": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Rectus Abdominis",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Clubbell Swing to Gamma Cast": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Rectus Abdominis",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Macebell Alternating 360": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Rectus Abdominis",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Macebell Bulgarian Split Squat to Alternating 360": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Posterior Deltoids",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Landmine Single Leg Standing Bent Knee Ipsilateral Shoulder Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Landmine Single Leg Standing Bent Knee Contralateral Shoulder Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Single Arm Landmine Single Leg Standing Bent Knee Shoulder Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Feet Elevated Renegade Row": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Feet Elevated Renegade Row Push Up": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Macebell Alternating 360 to Lateral Uppercut": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Rectus Abdominis",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Macebell Alternating 360 to Alternating Lateral Lunge Front Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Anterior Deltoids ",
      "tertiary-muscle": "Quadriceps Femoris",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Clubbell Shield Cast": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Rectus Abdominis",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Clubbell Shield Cast": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Rectus Abdominis",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Double Clubbell Shield Cast": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Rectus Abdominis",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Clubbell Inside Circle": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "Brachioradialis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Double Clubbell Inside Circles": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "Brachioradialis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Clubbell Inside Circle": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "Brachioradialis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Clubbell Alternating Inside Circle": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "Brachioradialis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Clubbell Side Shoulder Cast": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Clubbell Side Shoulder Cast to Side Flag Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Clubbell Swipe to Alternating Reverse Lunge Side Shoulder Cast to Side Flag Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Clubbell Swing to Alternating Side Shoulder Park Squat": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Clubbell Single Leg Standing Bent Knee Side Shoulder Cast to Side Flag Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Clubbell Swing to Barbarian Squat": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Clubbell Mill": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "Obliques",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Clubbell Inside Pendulum": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Clubbell Half Kneeling Shield Cast": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Rectus Abdominis",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Clubbell Half Knee Hover Shield Cast": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "Rectus Abdominis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Clubbell Single Leg Standing Bent Knee Shield Cast": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Rectus Abdominis",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Clubbell Iron Cross": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Clubbell Half Kneeling Iron Cross": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Clubbell Half Knee Hover Iron Cross": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Clubbell Single Leg Standing Bent Knee Iron Cross": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Half Snatch to Overhead Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Kettlebell Half Snatch to Front Rack Squat": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "Gluteus Minimus",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Clubbell Alternating Inside Circles": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "Brachioradialis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Clubbell Alternating Reverse Lunge Front Flag Press": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Anterior Deltoids ",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Clubbell Gamma Cast": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Rectus Abdominis",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Clubbell Half Kneeling Gamma Cast": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Rectus Abdominis",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Clubbell Half Knee Hover Gamma Cast": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "Rectus Abdominis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Clubbell Single Leg Standing Bent Knee Gamma Cast": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Rectus Abdominis",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Clubbell Pullover": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Triceps Brachaii",
      "tertiary-muscle": "Latissimus Dorsi",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Clubbell Pullover": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Triceps Brachaii",
      "tertiary-muscle": "Latissimus Dorsi",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Clubbell Pullover": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Triceps Brachaii",
      "tertiary-muscle": "Latissimus Dorsi",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Clubbell Side Swing": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Clubbell Side Swing": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Clubbell Inside Pendulum": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Clubbell Swipe": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "Biceps Femoris",
      "tertiary-muscle": "Latissimus Dorsi",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Clubbell Swipe": {
      "target-muscle": "Glutes",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "Biceps Femoris",
      "tertiary-muscle": "Latissimus Dorsi",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Clubbell Crossbody Swipe": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "Latissimus Dorsi",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Macebell Alternating 360 to Front Flag Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Anterior Deltoids ",
      "tertiary-muscle": "Rectus Abdominis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Clubbell Inside Circle to Shield Cast": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Rectus Abdominis",
      "tertiary-muscle": "Gluteus Maximus",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Clubbell Barbarian Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Posterior Deltoids",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Clubbell Inside Circle to Outside Circle": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "Brachioradialis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Clubbell Side to Side Swing": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Clubbell Barbarian Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Posterior Deltoids",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Single Arm Clubbell Inside Circle": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Rectus Abdominis",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "Brachioradialis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Clubbell Side to Side Swing": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Single Arm Clubbell Side to Side Swing": {
      "target-muscle": "Abdominals",
      "primary-muscle": "Obliques",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Clubbell Alternating Pendulum to Gamma Cast": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Obliques",
      "tertiary-muscle": "Rectus Abdominis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Clubbell Single Leg Standing Bent Knee Contralateral Shield Cast": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Rectus Abdominis",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Clubbell Side Flag Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Medial Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Clubbell Front Flag Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachaii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Clubbell Inside Circle to Front Flag Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachaii",
      "tertiary-muscle": "Obliques",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Kettlebell Bottoms Up Overhead Adductor Slide": {
      "target-muscle": "Adductors",
      "primary-muscle": "Adductor Magnus",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Clubbell Order Bulgarian Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "Brachioradialis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Barbell Hang Squat Clean": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Kettlebell Single Leg Standing Hip Flexion": {
      "target-muscle": "Hip Flexors",
      "primary-muscle": "Iliopsoas",
      "secondary-muscle": "Rectus Femoris",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Miniband Supine Alternating Hip Flexion": {
      "target-muscle": "Hip Flexors",
      "primary-muscle": "Iliopsoas",
      "secondary-muscle": "Rectus Femoris",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Indian Club Inner Heart Shaped Swing": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Indian Club Inner Heart Shaped Swing": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Double Indian Club Inner Heart Shaped Swing": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Indian Club Crescent Swing": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Obliques",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Clubbell Barbarian Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Posterior Deltoids",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Clubbell Single Leg Standing Bent Knee Ipsilateral Shield Cast": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Rectus Abdominis",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Clubbell Order Cyclist Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Clubbell Order Contralateral Bulgarian Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "Brachioradialis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Double Clubbell Side Flag Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Medial Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Clubbell Side Flag Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Medial Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Clubbell Side Shoulder Cast": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Clubbell Order Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Clubbell Order Ipsilateral Bulgarian Split Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "Brachioradialis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Clubbell Order Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Clubbell Order Squat": {
      "target-muscle": "Quadriceps",
      "primary-muscle": "Quadriceps Femoris",
      "secondary-muscle": "Gluteus Maximus",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Macebell Front Swing to 360": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "Rectus Abdominis",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Ring Dead Hang": {
      "target-muscle": "Back",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Clubbell Torch Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachaii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Clubbell Torch Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachaii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Clubbell Torch Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachaii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Double Clubbell Torch Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachaii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Clubbell Front Flag Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachaii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Clubbell Front Flag Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachaii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Alternating Double Clubbell Front Flag Press": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Anterior Deltoids",
      "secondary-muscle": "Triceps Brachaii",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Indian Club Lateral Internal and External Rotations": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Single Arm Indian Club Lateral Internal and External Rotation": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Indian Club Overhead Arm Circles": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Medial Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Double Indian Club Lateral Arm Circles": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Medial Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Resistance Band Shoulder Dislocates": {
      "target-muscle": "Shoulders",
      "primary-muscle": "Posterior Deltoids",
      "secondary-muscle": "",
      "tertiary-muscle": "",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Suspension Reverse Grip Bicep Curl": {
      "target-muscle": "Forearms",
      "primary-muscle": "Brachioradialis",
      "secondary-muscle": "Biceps Brachii",
      "tertiary-muscle": "Brachialis",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Running": {
      "target-muscle": "Cardio",
      "primary-muscle": "Tensor Fasciae Latae",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "Gastrocnemius",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Jogging": {
      "target-muscle": "Cardio",
      "primary-muscle": "Tensor Fasciae Latae",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "Gastrocnemius",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Cycling": {
      "target-muscle": "Cardio",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "Biceps Femoris",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Stationary Bike": {
      "target-muscle": "Cardio",
      "primary-muscle": "Gluteus Maximus",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "Biceps Femoris",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Rowing": {
      "target-muscle": "Cardio",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "Biceps Brachii",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Rowing Machine": {
      "target-muscle": "Cardio",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "Quadriceps Femoris",
      "tertiary-muscle": "Biceps Brachii",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Swimming": {
      "target-muscle": "Cardio",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "Pectoralis Major",
      "tertiary-muscle": "Gluteus Maximus",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Elliptical Trainer Machine": {
      "target-muscle": "Cardio",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "Pectoralis Major",
      "tertiary-muscle": "Gluteus Maximus",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
    "Cross Trainer Machine": {
      "target-muscle": "Cardio",
      "primary-muscle": "Latissimus Dorsi",
      "secondary-muscle": "Pectoralis Major",
      "tertiary-muscle": "Gluteus Maximus",
      "quaternary-muscle": "",
      "quinary-muscle": ""
    },
  };

  List<String> muscleList = <String>[
    'Triceps Brachii ',
    'Rhomboids',
    'Rectus Abdominis',
    'Latissimus Dorsi',
    'Gluteus Medius',
    'Teres Major',
    'Gluteus Minimus',
    'Anterior Deltoids',
    'Iliopsoas',
    'Infraspinatus',
    'Gluteus Maximus',
    'Biceps Femoris',
    'Brachialis',
    'Gastrocnemius',
    'Soleus',
    'Teres Minor',
    'Subscapularis ',
    'Quadriceps Femoris',
    'Upper Trapezius',
    'Adductor Magnus',
    'Rectus Abdominis ',
    'Tensor Fasciae Latae',
    'Biceps Brachii',
    'Lower Trapezius',
    'Rectus Femoris',
    'Tibialis Anterior',
    'Pectoralis Major',
    'Erector Spinae',
    'Anterior Deltoids ',
    'Medial Deltoids',
    'Brachioradialis',
    'Obliques',
    'Serratus Anterior',
    'Posterior Deltoids'
  ];


  @override
  Widget build(BuildContext context) {
    exerciseList = exerciseList;

    for (String exercise in context
        .read<WorkoutProvider>()
        .exerciseNamesList) {
      if (!exerciseList.contains(exercise)) {
        exerciseList.add(exercise);
      }
    }

    exerciseList.sort();


    List<String> categoriesList = <String>[
      'Adductors',
      'Forearms',
      'Back',
      'Hamstrings',
      'Biceps',
      'Trapezius',
      'Triceps',
      'Glutes',
      'Hip Flexors',
      'Calves',
      'Shoulders',
      'Quadriceps',
      'Abductors',
      'Chest',
      'Abdominals',
      'Cardio'
    ];

    for (String category in context
        .read<WorkoutProvider>()
        .categoriesNamesList) {
      if (!categoriesList.contains(category)) {
        categoriesList.add(category);
      }
    }

    categoriesList.sort();

    categoriesList.add('Other');

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: appPrimaryColour,
        appBar: AppBar(
          backgroundColor: appTertiaryColour,
          title: const Text(
            "Create New Exercise",
          ),
        ),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowIndicator();
            return true;
          },
          child: Stack(
            children: [
              ListView(
                shrinkWrap: true,
                children: [
                  SizedBox(
                    height: 24.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                    child: DropDownForm(
                      label: "Search Exercises *",
                      formController: exerciseController,
                      formKey: exerciseKey,
                      listOfItems: exerciseList,
                      callback: () => changeCategoryIfExists(),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20, left: 50.0, right: 50.0),
                    child: DropDownForm(
                      label: "Search Categories",
                      formController: categoriesController,
                      formKey: categoriesKey,
                      listOfItems: categoriesList,
                      validate: false,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20, left: 50.0, right: 50.0),
                    child: DropDownForm(
                      label: "Search Primary Muscles",
                      formController: primaryMuscleController,
                      formKey: primaryMuscleKey,
                      listOfItems: muscleList,
                      validate: false,
                      callback: () => setState(() {}),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20, left: 50.0, right: 50.0),
                    child: DropDownForm(
                      label: "Search Secondary Muscles",
                      formController: secondaryMuscleController,
                      formKey: secondaryMuscleKey,
                      listOfItems: muscleList,
                      validate: false,
                      callback: () => setState(() {}),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20, left: 50.0, right: 50.0),
                    child: DropDownForm(
                      label: "Search Tertiary Muscles",
                      formController: tertiaryMuscleController,
                      formKey: tertiaryMuscleKey,
                      listOfItems: muscleList,
                      validate: false,
                      callback: () => setState(() {}),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20, left: 50.0, right: 50.0),
                    child: DropDownForm(
                      label: "Search Quaternary Muscle",
                      formController: quaternaryMuscleController,
                      formKey: quaternaryMuscleKey,
                      listOfItems: muscleList,
                      validate: false,
                      callback: () => setState(() {}),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20, left: 50.0, right: 50.0),
                    child: DropDownForm(
                      label: "Search Quinary Muscle",
                      formController: quinaryMuscleController,
                      formKey: quinaryMuscleKey,
                      listOfItems: muscleList,
                      validate: false,
                      callback: () => setState(() {}),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20, left: 50.0, right: 50.0),
                    child: DropdownMenu(
                      controller: exerciseType,
                      initialSelection: 0,
                      enableSearch: false,
                      requestFocusOnTap: false,
                      width: 294.w,
                      hintText: "Select Exercise Type *",
                      textStyle: boldTextStyle,
                      menuStyle: MenuStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            appQuinaryColour),
                      ),
                      trailingIcon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
                      selectedTrailingIcon: const Icon(
                        Icons.arrow_drop_up,
                        color: Colors.white,
                      ),
                      inputDecorationTheme: const InputDecorationTheme(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: appQuarternaryColour,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: appSecondaryColour,
                            )
                        ),
                      ),
                      dropdownMenuEntries: [

                        DropdownMenuEntry(
                          value: 0,
                          label: "Weight and Reps",
                          style: ButtonStyle(
                            textStyle: MaterialStateProperty.all<TextStyle>(
                                boldTextStyle),
                            foregroundColor: MaterialStateProperty.all<Color>(
                                Colors.white),
                          ),
                        ),
                        DropdownMenuEntry(
                          value: 1,
                          label: "Distance and Time",
                          style: ButtonStyle(
                            textStyle: MaterialStateProperty.all<TextStyle>(
                                boldTextStyle),
                            foregroundColor: MaterialStateProperty.all<Color>(
                                Colors.white),
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        if (value != null) {
                          setState(() {
                            typeDropDownMenuValue = value;
                          });
                        }
                      },
                    ),
                  ),

                  /*typeDropDownMenuValue == 0*/ false ? Padding(
                    padding: const EdgeInsets.only(
                        top: 20, left: 50.0, right: 50.0),
                    child: DropdownMenu(
                      initialSelection: 0,
                      enableSearch: false,
                      requestFocusOnTap: false,
                      width: 294.w,
                      hintText: "Select Exercise Type *",
                      textStyle: boldTextStyle,
                      menuStyle: MenuStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            appQuinaryColour),
                      ),
                      trailingIcon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
                      selectedTrailingIcon: const Icon(
                        Icons.arrow_drop_up,
                        color: Colors.white,
                      ),
                      inputDecorationTheme: const InputDecorationTheme(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: appQuarternaryColour,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: appSecondaryColour,
                            )
                        ),
                      ),
                      dropdownMenuEntries: [

                        DropdownMenuEntry(
                          value: 0,
                          label: "Main",
                          style: ButtonStyle(
                            textStyle: MaterialStateProperty.all<TextStyle>(
                                boldTextStyle),
                            foregroundColor: MaterialStateProperty.all<Color>(
                                Colors.white),
                          ),
                        ),
                        DropdownMenuEntry(
                          value: 1,
                          label: "Accessory",
                          style: ButtonStyle(
                            textStyle: MaterialStateProperty.all<TextStyle>(
                                boldTextStyle),
                            foregroundColor: MaterialStateProperty.all<Color>(
                                Colors.white),
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        if (value != null) {
                          setState(() {
                            weightTypeDropDownMenuValue = value;
                          });
                        }
                      },
                    ),
                  ) : const SizedBox.shrink(),

                  AnatomyDiagram(
                    exerciseModel: ExerciseModel(
                      exerciseName: exerciseController.text,
                      exerciseTrackingData: RepsWeightStatsMeasurement(
                        measurementName: '',
                        dailyLogs: [],
                      ),
                      exerciseMaxRepsAndWeight: {},
                      category: categoriesController.text,
                      primaryMuscle: primaryMuscleController.text,
                      secondaryMuscle: secondaryMuscleController.text,
                      tertiaryMuscle: tertiaryMuscleController.text,
                      quaternaryMuscle: quaternaryMuscleController.text,
                      quinaryMuscle: quinaryMuscleController.text,
                      type: typeDropDownMenuValue,
                      exerciseTrackingType: typeDropDownMenuValue == 0
                          ? weightTypeDropDownMenuValue
                          : null,
                    ),
                  ),

                  SizedBox(
                    height: 280.h,
                  ),


                ],
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: appTertiaryColour,
                  height: 70.h,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 6,
                        child: Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(left: 12.w),
                          child: AppButton(
                            onTap: () =>
                                context.read<PageChange>()
                                    .changePageCache(ExerciseDatabaseSearch()),
                            buttonText: 'Find New Exercises',
                          ),
                        ),
                      ),
                      const Spacer(),
                      Expanded(
                        flex: 6,
                        child: Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 12.w),
                          child: AppButton(
                            onTap: () {
                              if (exerciseController.text.isNotEmpty &&
                                  !context.read<WorkoutProvider>()
                                      .checkForExerciseName(
                                      exerciseController.text)) {
                                context.read<WorkoutProvider>().AddNewWorkout(
                                    ExerciseModel(
                                      exerciseName: exerciseController.text,
                                      exerciseTrackingData: RepsWeightStatsMeasurement(
                                        measurementName: '',
                                        dailyLogs: [],
                                      ),
                                      exerciseMaxRepsAndWeight: {},
                                      category: categoriesController.text,
                                      primaryMuscle: primaryMuscleController
                                          .text,
                                      secondaryMuscle: secondaryMuscleController
                                          .text,
                                      tertiaryMuscle: tertiaryMuscleController
                                          .text,
                                      quaternaryMuscle: quaternaryMuscleController
                                          .text,
                                      quinaryMuscle: quinaryMuscleController
                                          .text,
                                      type: typeDropDownMenuValue,
                                      exerciseTrackingType: typeDropDownMenuValue ==
                                          0
                                          ? weightTypeDropDownMenuValue
                                          : null,
                                    )
                                );
                                context.read<PageChange>().backPage();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text("Updating Exercise"),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    margin: EdgeInsets.only(
                                      bottom: MediaQuery
                                          .of(context)
                                          .size
                                          .height * 0.6695,
                                      right: 20,
                                      left: 20,
                                    ),
                                    dismissDirection: DismissDirection.none,
                                    duration: const Duration(
                                        milliseconds: 1500),
                                  ),
                                );

                                updateExercise(
                                    ExerciseModel(
                                      exerciseName: exerciseController.text,
                                      exerciseTrackingData: RepsWeightStatsMeasurement(
                                        measurementName: '',
                                        dailyLogs: [],
                                      ),
                                      exerciseMaxRepsAndWeight: {},
                                      category: categoriesController.text,
                                      primaryMuscle: primaryMuscleController
                                          .text,
                                      secondaryMuscle: secondaryMuscleController
                                          .text,
                                      tertiaryMuscle: tertiaryMuscleController
                                          .text,
                                      quaternaryMuscle: quaternaryMuscleController
                                          .text,
                                      quinaryMuscle: quinaryMuscleController
                                          .text,
                                      exerciseTrackingType: typeDropDownMenuValue ==
                                          0
                                          ? weightTypeDropDownMenuValue
                                          : null,
                                    )
                                );

                                context.read<WorkoutProvider>()
                                    .RemoveWorkoutCache(
                                    exerciseController.text);

                                context.read<PageChange>().backPage();
                              }
                            },
                            buttonText: 'Save Exercise',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}
