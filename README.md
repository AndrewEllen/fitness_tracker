<p align="center">
  <img src="https://github.com/AndrewEllen/fitness_tracker/blob/master/src/assets/logo/applogo.png?raw=true" width="100" alt="project-logo">
</p>
<p align="center">
    <h1 align="center">FIT</h1>
</p>
<p align="center">
    <em>A Workout And Diet Tracker App</em>
</p>
<p align="center">
	<img src="https://img.shields.io/github/license/AndrewEllen/fitness_tracker?style=default&logo=opensourceinitiative&logoColor=white&color=0080ff" alt="license">
	<img src="https://img.shields.io/github/last-commit/AndrewEllen/fitness_tracker?style=default&logo=git&logoColor=white&color=0080ff" alt="last-commit">
	<img src="https://img.shields.io/github/languages/top/AndrewEllen/fitness_tracker?style=default&color=0080ff" alt="repo-top-language">
	<img src="https://img.shields.io/github/languages/count/AndrewEllen/fitness_tracker?style=default&color=0080ff" alt="repo-language-count">
<p>
<p align="center">
		<em>Developed with the software and tools below.</em>
</p>
<p align="center">
	<img src="https://img.shields.io/badge/Swift-F05138.svg?style=flat&logo=Swift&logoColor=white" alt="Swift">
	<img src="https://img.shields.io/badge/YAML-CB171E.svg?style=flat&logo=YAML&logoColor=white" alt="YAML">
	<img src="https://img.shields.io/badge/C-A8B9CC.svg?style=flat&logo=C&logoColor=black" alt="C">
	<img src="https://img.shields.io/badge/Kotlin-7F52FF.svg?style=flat&logo=Kotlin&logoColor=white" alt="Kotlin">
	<img src="https://img.shields.io/badge/Org-77AA99.svg?style=flat&logo=Org&logoColor=white" alt="Org">
	<br>
	<img src="https://img.shields.io/badge/Android-3DDC84.svg?style=flat&logo=Android&logoColor=white" alt="Android">
	<img src="https://img.shields.io/badge/Gradle-02303A.svg?style=flat&logo=Gradle&logoColor=white" alt="Gradle">
	<img src="https://img.shields.io/badge/Dart-0175C2.svg?style=flat&logo=Dart&logoColor=white" alt="Dart">
	<img src="https://img.shields.io/badge/JetBrains-000000.svg?style=flat&logo=JetBrains&logoColor=white" alt="JetBrains">
	<img src="https://img.shields.io/badge/JSON-000000.svg?style=flat&logo=JSON&logoColor=white" alt="JSON">
</p>

<br><!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary><br>

- [📍 Overview](#-overview)
- [🧩 Features](#-features)
- [🗂️ Repository Structure](#️-repository-structure)
- [📦 Modules](#-modules)
- [🚀 Getting Started](#-getting-started)
  - [⚙️ Installation](#️-installation)
  - [🤖 Usage](#-usage)
  - [🧪 Tests](#-tests)
- [🛠 Project Roadmap](#-project-roadmap)
- [🤝 Contributing](#-contributing)
- [🎗 License](#-license)
</details>
<hr>

## 📍 Overview

FIT is a comprehensive workout and diet tracker designed to enhance user efficiency and ease of use. Our app offers a robust suite of tools tailored to support your fitness journey, whether your goal is weight maintenance, weight loss, or weight gain.

**Key Features:**

- Goal Selection: Choose between weight maintenance, weight loss, or weight gain to tailor your experience.
- Food Database and Recipe Management: Easily search for foods, create and share recipes, and utilize barcode scanning and tabular OCR for quick nutrition label data entry.
- Real-Time Grocery List: Maintain an updated grocery list that syncs across your household for seamless meal planning.
- Workout Tracking: Monitor your fitness progress with detailed workout statistics, including max reps, fastest times, and overall workout summaries. Weekly tracking helps you stay consistent with your routine.
- Calorie Calculation: Automatically calculate calories burned from daily steps, cardio, and resistance exercises to keep your diet tracking accurate.
- Body Metrics Tracking: Track your progress with detailed body measurements and weight records. Stay motivated with daily streaks showcasing your dedication.
- FIT is your all-in-one solution for achieving your fitness goals, providing a user-friendly interface to streamline both diet and workout tracking.


**Motivation:**

The creation of FIT stems from my frustration with paywalled diet trackers. Many existing diet trackers fall short in critical areas, such as recipe creation, and often restrict features unless users subscribe to expensive monthly plans. Additionally, I found that most workout trackers either didn’t track the metrics I cared about or weren’t integrated with diet tracking, making it difficult to manage my nutrition and fitness simultaneously.

FIT is my solution to these issues. It seamlessly combines workout tracking and diet tracking into a single, user-friendly, and accurate mobile app. This integration allows users to stay on top of their fitness goals with ease. FIT is not just a personal project; it’s been tested and proven useful by my friends and family alike, who have successfully lost weight and gained muscle using the app. My goal is to provide everyone with the tools they need to achieve their fitness goals without unnecessary barriers.

---

## 🧩 Features

|    |   Feature         | Description |
|----|-------------------|---------------------------------------------------------------|
| ⚙️  | **Architecture**  | The project is a Flutter application that utilizes Firebase services for user authentication, database management, and analytics. It integrates Flutter UI components into the Android and iOS environments, ensuring a seamless user experience. Kotlin is used for Android development. |
| 🔩 | **Code Quality**  | The codebase follows good coding practices with linting enabled for Flutter apps. The structure adheres to recommended guidelines, ensuring readability and maintainability. The use of Providers for state management enhances code organization and clarity. |
| 📄 | **Documentation** | The project features moderately detailed documentation with explanations of key files, data models, provider classes, and UI components. However, additional documentation on architecture and design decisions would further enhance understanding and onboarding for new contributors. |
| 🔌 | **Integrations**  | Key integrations include Firebase for authentication, database management, and analytics. The project also leverages Kotlin for Android development, enhancing platform-specific functionalities and performance. Additional integrations with chart libraries and APIs support the fitness tracking app's features. |
| 🧩 | **Modularity**    | The codebase demonstrates modularity through structured folders for diet, stats, groceries, workout, and general functionalities. Reusable widgets enhance code reusability and maintainability. Separation of concerns is evident in the division of data providers and UI components. |
| ⚡️  | **Performance**   | The app's efficiency is supported through Firebase's real-time data updates and cloud services, enhancing speed and responsiveness. Utilizing Kotlin for Android development and Flutter's UI components contributes to optimized performance across platforms. Improvements in asynchronous data handling could further enhance performance. |
| 🛡️ | **Security**      | Security measures revolve around Firebase Authentication for user sign-in, sign-up, and data management. The Firestore database ensures secure data storage and retrieval. Password visibility toggling enhances user privacy and protection. |
| 📦 | **Dependencies**  | Key dependencies include Jetbrains, Gradle, Kotlin, Dart, and various Flutter packages for UI components, state management, and data handling. External libraries like charting, Firebase, and barcode scanning enrich the app's functionality. Managing dependencies efficiently is crucial for maintaining compatibility and performance. |

---

## 🗂️ Repository Structure

```sh
└── fitness_tracker/
    ├── DBRULES.md
    ├── README.md
    ├── documents
    │   ├── coding_convensions.md
    │   └── design
    │       ├── FIT.pdf
    │       ├── FIT.xd
    │       └── MindMap.pdf
    └── src
        ├── .gitignore
        ├── .metadata
        ├── analysis_options.yaml
        ├── android
        │   ├── .gitignore
        │   ├── app
        │   │   ├── build.gradle
        │   │   └── src
        │   │       ├── debug
        │   │       ├── main
        │   │       └── profile
        │   ├── build.gradle
        │   ├── gradle
        │   │   └── wrapper
        │   │       └── gradle-wrapper.properties
        │   ├── gradle.properties
        │   └── settings.gradle
        ├── assets
        │   ├── FITBackgroundVideo.png
        │   ├── campfirelogo.ttf
        │   └── logo
        │       ├── applogo.png
        │       └── applogonobg.png
        ├── ios
        │   ├── .gitignore
        │   ├── Flutter
        │   │   ├── AppFrameworkInfo.plist
        │   │   ├── Debug.xcconfig
        │   │   └── Release.xcconfig
        │   ├── Runner
        │   │   ├── AppDelegate.swift
        │   │   ├── Assets.xcassets
        │   │   │   ├── AppIcon.appiconset
        │   │   │   └── LaunchImage.imageset
        │   │   ├── Base.lproj
        │   │   │   ├── LaunchScreen.storyboard
        │   │   │   └── Main.storyboard
        │   │   ├── Info.plist
        │   │   └── Runner-Bridging-Header.h
        │   ├── Runner.xcodeproj
        │   │   ├── project.pbxproj
        │   │   ├── project.xcworkspace
        │   │   │   ├── contents.xcworkspacedata
        │   │   │   └── xcshareddata
        │   │   └── xcshareddata
        │   │       └── xcschemes
        │   └── Runner.xcworkspace
        │       ├── contents.xcworkspacedata
        │       └── xcshareddata
        │           ├── IDEWorkspaceChecks.plist
        │           └── WorkspaceSettings.xcsettings
        ├── lib
        │   ├── constants.dart
        │   ├── exports.dart
        │   ├── helpers
        │   │   ├── diet
        │   │   │   ├── analyse_barcode.dart
        │   │   │   ├── extract_image_byte_data.dart
        │   │   │   ├── nutrition_tracker.dart
        │   │   │   └── tableScanEntryList.dart
        │   │   ├── general
        │   │   │   ├── custom_icons.dart
        │   │   │   ├── firebase_auth_service.dart
        │   │   │   ├── list_extensions.dart
        │   │   │   ├── numerical_range_formatter_extension.dart
        │   │   │   └── string_extensions.dart
        │   │   └── home
        │   │       ├── email_validator.dart
        │   │       └── phone_validator.dart
        │   ├── main.dart
        │   ├── models
        │   │   ├── diet
        │   │   │   ├── exercise_calories_list_item.dart
        │   │   │   ├── food_data_list_item.dart
        │   │   │   ├── food_item.dart
        │   │   │   ├── user__foods_model.dart
        │   │   │   ├── user_nutrition_model.dart
        │   │   │   └── user_recipes_model.dart
        │   │   ├── groceries
        │   │   │   └── grocery_item.dart
        │   │   ├── stats
        │   │   │   ├── stats_model.dart
        │   │   │   └── user_data_model.dart
        │   │   └── workout
        │   │       ├── distance_time_measurement.dart
        │   │       ├── exercise_database_model.dart
        │   │       ├── exercise_list_checkbox.dart
        │   │       ├── exercise_list_model.dart
        │   │       ├── exercise_model.dart
        │   │       ├── rep_stats_measurement.dart
        │   │       ├── reps_weight_stats_model.dart
        │   │       ├── routines_model.dart
        │   │       ├── time_measurement.dart
        │   │       ├── workout_log_exercise_data.dart
        │   │       ├── workout_log_model.dart
        │   │       └── workout_overall_stats_model.dart
        │   ├── openfoodfacts_options.dart
        │   ├── pages
        │   │   ├── diet
        │   │   │   ├── diet_barcode_scanner.dart
        │   │   │   ├── diet_diet_home.dart
        │   │   │   ├── diet_food_display_page.dart
        │   │   │   ├── diet_food_search_page.dart
        │   │   │   ├── diet_new_food_page.dart
        │   │   │   ├── diet_recipe_creator.dart
        │   │   │   ├── diet_recipe_food_search.dart
        │   │   │   └── food_nutrition_list_edit.dart
        │   │   ├── diet_new
        │   │   │   ├── diet_home.dart
        │   │   │   └── diet_nutrition_table_extraction.dart
        │   │   ├── general
        │   │   │   ├── auth_choose_login_signup.dart
        │   │   │   ├── auth_signin.dart
        │   │   │   ├── auth_signup.dart
        │   │   │   ├── main_page.dart
        │   │   │   └── splashscreen.dart
        │   │   ├── general_new
        │   │   │   ├── auth_landing_page.dart
        │   │   │   ├── calculate_calories_page.dart
        │   │   │   ├── user_login_page.dart
        │   │   │   ├── user_registration_confirmation_email.dart
        │   │   │   ├── user_registration_confirmation_page.dart
        │   │   │   ├── user_registration_email_signup.dart
        │   │   │   ├── user_setup_calories_page.dart
        │   │   │   └── user_signup.dart
        │   │   ├── groceries
        │   │   │   └── groceries_home.dart
        │   │   ├── home
        │   │   │   └── home.dart
        │   │   ├── info
        │   │   │   └── info_information_home.dart
        │   │   ├── stats
        │   │   │   ├── stats_measurements_home.dart
        │   │   │   └── stats_tracking_page.dart
        │   │   └── workout_new
        │   │       ├── exercise_database_search.dart
        │   │       ├── exercise_selection_page.dart
        │   │       ├── new_exercise_page.dart
        │   │       ├── workout_exercise_anatomy_page.dart
        │   │       ├── workout_exercise_graphs_page.dart
        │   │       ├── workout_exercise_page.dart
        │   │       ├── workout_home.dart
        │   │       ├── workout_log_page.dart
        │   │       ├── workout_logs_home.dart
        │   │       ├── workout_routine_page.dart
        │   │       └── workout_selected_log_page.dart
        │   ├── providers
        │   │   ├── diet
        │   │   │   └── user_nutrition_data.dart
        │   │   ├── general
        │   │   │   ├── database_get.dart
        │   │   │   ├── database_write.dart
        │   │   │   ├── general_data_provider.dart
        │   │   │   └── page_change_provider.dart
        │   │   ├── grocery
        │   │   │   └── groceries_provider.dart
        │   │   ├── stats
        │   │   │   ├── user_data.dart
        │   │   │   └── user_measurements.dart
        │   │   └── workout
        │   │       └── workoutProvider.dart
        │   └── widgets
        │       ├── android_widget
        │       │   └── calories_widget.dart
        │       ├── diet
        │       │   ├── diet_category_add_bar.dart
        │       │   ├── diet_category_add_bar_exercise.dart
        │       │   ├── diet_category_box.dart
        │       │   ├── diet_exercise_box.dart
        │       │   ├── diet_home_macro_nutrition_display.dart
        │       │   ├── diet_list_header_box.dart
        │       │   ├── exercise_list_item_box.dart
        │       │   ├── food_history_list_item_box.dart
        │       │   ├── food_list_item_box.dart
        │       │   ├── food_list_search_display_box.dart
        │       │   ├── food_nutrition_list_formfield.dart
        │       │   ├── food_nutrition_list_text.dart
        │       │   └── nutrition_progress_bar.dart
        │       ├── diet_new
        │       │   ├── diet_home_bottom_button.dart
        │       │   ├── diet_home_calories_circle.dart
        │       │   ├── diet_home_daily_nutrition_display.dart
        │       │   ├── diet_home_date_picker.dart
        │       │   ├── diet_home_exercise_bottom_button.dart
        │       │   ├── diet_home_exercise_display.dart
        │       │   ├── diet_home_extra_nutrition_bars.dart
        │       │   ├── diet_home_food_display.dart
        │       │   ├── diet_home_nutrition_bar_long.dart
        │       │   ├── diet_home_nutrition_bar_short.dart
        │       │   ├── diet_home_nutrition_bars.dart
        │       │   ├── diet_water_box.dart
        │       │   ├── exercise_list_item_box_new.dart
        │       │   └── food_list_item_box_new.dart
        │       ├── general
        │       │   ├── app_container_header.dart
        │       │   ├── app_default_button.dart
        │       │   ├── app_dropdown_form.dart
        │       │   ├── faded_widget.dart
        │       │   ├── horizontal_bar_chart.dart
        │       │   ├── incremental_counter.dart
        │       │   ├── screen_width_button.dart
        │       │   ├── screen_width_container.dart
        │       │   └── screen_width_expanding_container.dart
        │       ├── groceries
        │       │   ├── grocery_list.dart
        │       │   └── grocery_list_box.dart
        │       ├── stats
        │       │   ├── stats_add_data.dart
        │       │   ├── stats_container_widget.dart
        │       │   ├── stats_edit_data.dart
        │       │   └── stats_line_chart.dart
        │       └── workout_new
        │           ├── anatomy_diagram.dart
        │           ├── daily_tracker_circle.dart
        │           ├── database_search_box.dart
        │           ├── exercise_selection_box.dart
        │           ├── home_page_routines_list.dart
        │           ├── muscle_anatomy_diagram_painter.dart
        │           ├── routine_box.dart
        │           ├── routine_page_exercise_box.dart
        │           ├── routine_page_exercise_list.dart
        │           ├── workout_bottom_button.dart
        │           ├── workout_daily_tracker.dart
        │           ├── workout_dropdown_box.dart
        │           ├── workout_home_log_box.dart
        │           ├── workout_home_stats.dart
        │           ├── workout_home_stats_dropdown.dart
        │           ├── workout_line_chart.dart
        │           ├── workout_log_box.dart
        │           ├── workout_log_page_list.dart
        │           └── workout_log_top_stats_box.dart
        ├── pubspec.lock
        └── pubspec.yaml
```

---

## 📦 Modules

<details closed><summary>src</summary>

| File                                                                                                          | Summary                                                                                                                                                                                                                                                           |
| ---                                                                                                           | ---                                                                                                                                                                                                                                                               |
| [.metadata](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\.metadata)                         | Tracks Flutter project properties for capabilities and upgrades, informing Flutter tool. Version control required. App project with specified revision and channel.                                                                                               |
| [analysis_options.yaml](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\analysis_options.yaml) | Configures static analysis for Dart code, ensuring error checking, warnings, and linting. Activates recommended lints for Flutter apps while allowing customization. Encourages adherence to good coding practices and provides flexibility for rule adjustments. |
| [pubspec.yaml](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\pubspec.yaml)                   | Defines dependencies, assets, and fonts for the fitness tracker Flutter application. Manages packages including Firebase, chart libraries, and authentication. Specifies custom icons and fonts for iOS and Android app versions.                                 |

</details>

<details closed><summary>src.android</summary>

| File                                                                                                      | Summary                                                                                                                                                                                                                                         |
| ---                                                                                                       | ---                                                                                                                                                                                                                                             |
| [build.gradle](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\android\build.gradle)       | Manages Android project configuration, dependencies, and directory structure. Facilitates clean project builds and integrates Kotlin support. Configures project-level repository settings for accessing Google and Maven Central repositories. |
| [settings.gradle](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\android\settings.gradle) | Configures the Flutter Android project settings by including app, loading local properties, and applying necessary settings from the Flutter framework's gradle file.                                                                           |

</details>

<details closed><summary>src.android.app</summary>

| File                                                                                                    | Summary                                                                                                                                                                                                      |
| ---                                                                                                     | ---                                                                                                                                                                                                          |
| [build.gradle](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\android\app\build.gradle) | Configures Android project settings for the fitness tracker app. Loads Flutter properties, sets up versioning, and defines the application ID. Handles Kotlin dependencies and Android build configurations. |

</details>

<details closed><summary>src.android.app.src.main.kotlin.com.example.fitness_tracker</summary>

| File                                                                                                                                                      | Summary                                                                                                                                                     |
| ---                                                                                                                                                       | ---                                                                                                                                                         |
| [MainActivity.kt](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\android\app\src\main\kotlin\com\example\fitness_tracker\MainActivity.kt) | Implements Flutters main activity for the fitness tracker app. Integrates Flutters UI elements into the Android environment, ensuring seamless interaction. |

</details>

<details closed><summary>src.ios.Flutter</summary>

| File                                                                                                                        | Summary                                                                                                                                                                                                                                |
| ---                                                                                                                         | ---                                                                                                                                                                                                                                    |
| [AppFrameworkInfo.plist](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\ios\Flutter\AppFrameworkInfo.plist) | Defines iOS app metadata in the Flutter project, setting bundle versions and identifiers for the Fitness Tracker. It orchestrates the app framework details crucial for iOS deployment and execution within the projects architecture. |
| [Debug.xcconfig](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\ios\Flutter\Debug.xcconfig)                 | Imports configurations from Generated.xcconfig to enable debugging in the iOS platform within the fitness_tracker repository structure.                                                                                                |
| [Release.xcconfig](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\ios\Flutter\Release.xcconfig)             | Integrates generated configuration settings into the iOS build process by including Generated.xcconfig within the Release.xcconfig file.                                                                                               |

</details>

<details closed><summary>src.ios.Runner</summary>

| File                                                                                                                           | Summary                                                                                                                                                                                                  |
| ---                                                                                                                            | ---                                                                                                                                                                                                      |
| [AppDelegate.swift](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\ios\Runner\AppDelegate.swift)               | Registers Flutter plugins in the iOS apps main entry point, ensuring proper setup and integration within the Fitness Tracker applications architecture.                                                  |
| [Info.plist](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\ios\Runner\Info.plist)                             | Defines crucial iOS app configuration settings, including app name, version, and supported orientations. Vital for proper app initialization and user interface behavior.                                |
| [Runner-Bridging-Header.h](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\ios\Runner\Runner-Bridging-Header.h) | Integrates and registers Flutter plugins in the iOS environment through the Runner-Bridging-Header.h, enabling seamless communication between Flutter and native code in the fitness_tracker repository. |

</details>

<details closed><summary>src.ios.Runner.Assets.xcassets.AppIcon.appiconset</summary>

| File                                                                                                                                        | Summary                                                                                                                                         |
| ---                                                                                                                                         | ---                                                                                                                                             |
| [Contents.json](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\ios\Runner\Assets.xcassets\AppIcon.appiconset\Contents.json) | Defines iOS app icon details for various screen sizes and resolutions, facilitating visual branding consistency and optimizing user experience. |

</details>

<details closed><summary>src.ios.Runner.Assets.xcassets.LaunchImage.imageset</summary>

| File                                                                                                                                          | Summary                                                                                                                                                                                                                                                |
| ---                                                                                                                                           | ---                                                                                                                                                                                                                                                    |
| [Contents.json](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\ios\Runner\Assets.xcassets\LaunchImage.imageset\Contents.json) | Specifies launch image assets for various screen resolutions in iOS app development. Enhances user experience by displaying appropriate images during app launch. Centralizes image specifications to ensure compatibility with different iOS devices. |

</details>

<details closed><summary>src.ios.Runner.Base.lproj</summary>

| File                                                                                                                                    | Summary                                                                                                                                 |
| ---                                                                                                                                     | ---                                                                                                                                     |
| [LaunchScreen.storyboard](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\ios\Runner\Base.lproj\LaunchScreen.storyboard) | Defines iOS launch screen layout with a centered image view.                                                                            |
| [Main.storyboard](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\ios\Runner\Base.lproj\Main.storyboard)                 | Defines the initial view controller layout for the Flutter module in the iOS platform, specifying a custom FlutterViewController class. |

</details>

<details closed><summary>src.ios.Runner.xcodeproj</summary>

| File                                                                                                                   | Summary                                                                                                                                                                                                        |
| ---                                                                                                                    | ---                                                                                                                                                                                                            |
| [project.pbxproj](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\ios\Runner.xcodeproj\project.pbxproj) | Defines Xcode project settings and file references for the Flutter Runner target, managing build configurations, resources, and script execution. Organizes key elements for building the fitness tracker app. |

</details>

<details closed><summary>src.ios.Runner.xcodeproj.project.xcworkspace</summary>

| File                                                                                                                                                         | Summary                                                                                   |
| ---                                                                                                                                                          | ---                                                                                       |
| [contents.xcworkspacedata](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\ios\Runner.xcodeproj\project.xcworkspace\contents.xcworkspacedata) | Defines workspace configuration in the iOS project, ensuring seamless project management. |

</details>

<details closed><summary>src.ios.Runner.xcodeproj.project.xcworkspace.xcshareddata</summary>

| File                                                                                                                                                                              | Summary                                                                                                                                                                                                                     |
| ---                                                                                                                                                                               | ---                                                                                                                                                                                                                         |
| [IDEWorkspaceChecks.plist](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\ios\Runner.xcodeproj\project.xcworkspace\xcshareddata\IDEWorkspaceChecks.plist)         | Specifies IDE settings in the iOS Xcode project workspace to enable Mac 32-bit computing warnings. This essential configuration ensures code compatibility and enhances performance monitoring for the fitness tracker app. |
| [WorkspaceSettings.xcsettings](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\ios\Runner.xcodeproj\project.xcworkspace\xcshareddata\WorkspaceSettings.xcsettings) | Optimizes Xcode project settings in the fitness_tracker repo, disabling previews to enhance iOS development workflow.                                                                                                       |

</details>

<details closed><summary>src.ios.Runner.xcodeproj.xcshareddata.xcschemes</summary>

| File                                                                                                                                          | Summary                                                                                                                                                                                                                                          |
| ---                                                                                                                                           | ---                                                                                                                                                                                                                                              |
| [Runner.xcscheme](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\ios\Runner.xcodeproj\xcshareddata\xcschemes\Runner.xcscheme) | Defines build, test, launch, profile, analyze, and archive actions for the iOS Runner app, setting configurations for debugging, launching, and archiving. Organizes how the app will be built, tested, and analyzed within Xcodes architecture. |

</details>

<details closed><summary>src.ios.Runner.xcworkspace</summary>

| File                                                                                                                                       | Summary                                                                                                                                                                                                          |
| ---                                                                                                                                        | ---                                                                                                                                                                                                              |
| [contents.xcworkspacedata](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\ios\Runner.xcworkspace\contents.xcworkspacedata) | Defines iOS project structure and links to `Runner.xcodeproj` in `Runner.xcworkspace`. Enables Xcode to manage dependencies and configurations effectively within the fitness tracker apps broader architecture. |

</details>

<details closed><summary>src.ios.Runner.xcworkspace.xcshareddata</summary>

| File                                                                                                                                                            | Summary                                                                                                                                                                                                                   |
| ---                                                                                                                                                             | ---                                                                                                                                                                                                                       |
| [IDEWorkspaceChecks.plist](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\ios\Runner.xcworkspace\xcshareddata\IDEWorkspaceChecks.plist)         | Implements Mac 32-bit warning within iOS Runner workspace, enforcing compliance with Apples IDE standards for fitness tracker app architecture.                                                                           |
| [WorkspaceSettings.xcsettings](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\ios\Runner.xcworkspace\xcshareddata\WorkspaceSettings.xcsettings) | Enables disabling preview functionality in iOS workspace for the fitness tracker app. Maintains workspace settings in the repository structure to support collaborative development and streamline project configuration. |

</details>

<details closed><summary>src.lib</summary>

| File                                                                                                                        | Summary                                                                                                                                                                                                                                                   |
| ---                                                                                                                         | ---                                                                                                                                                                                                                                                       |
| [constants.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\constants.dart)                         | Defines primary, secondary, and tertiary color constants for the apps design, along with text styles and a box decoration. Enhances UI consistency and readability in the fitness tracker app by Flutter.                                                 |
| [exports.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\exports.dart)                             | Exports critical UI components and data providers for the fitness tracker app. Facilitates seamless integration of material design icons, main, diet, stats, and info pages, and key user data services.                                                  |
| [main.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\main.dart)                                   | Implements app initialization, user authentication, error handling, and analytics setup. Utilizes Firebase services, state management with Providers, and Flutter UI components for a fitness tracking app. Maintain app styling and screen adaptability. |
| [openfoodfacts_options.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\openfoodfacts_options.dart) | Set global Open Food Facts API settings for Stay FIT project in the UK with English language.                                                                                                                                                             |

</details>

<details closed><summary>src.lib.helpers.diet</summary>

| File                                                                                                                                         | Summary                                                                                                                                                                                                                                                                               |
| ---                                                                                                                                          | ---                                                                                                                                                                                                                                                                                   |
| [analyse_barcode.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\helpers\diet\analyse_barcode.dart)                 | Enables barcode analysis for diet data using Google ML Kit Barcode Scanning in the fitness tracker app. Parses barcode value from images, supporting various formats.                                                                                                                 |
| [extract_image_byte_data.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\helpers\diet\extract_image_byte_data.dart) | Extracts byte data from image assets to create a file, crucial for manipulating diet images in the fitness tracker app.                                                                                                                                                               |
| [nutrition_tracker.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\helpers\diet\nutrition_tracker.dart)             | Enhances nutrition data retrieval for food items by converting and processing raw data from multiple sources. Implemented functions differentiate between Firebase and Open Food Facts APIs to generate comprehensive food item objects for efficient use in the fitness tracker app. |
| [tableScanEntryList.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\helpers\diet\tableScanEntryList.dart)           | Defines various lists for categorizing nutrients, vitamins, and minerals in a diet tracking app, aiding data organization and retrieval. Streamlines food composition analysis within the fitness tracker ecosystem.                                                                  |

</details>

<details closed><summary>src.lib.helpers.general</summary>

| File                                                                                                                                                                    | Summary                                                                                                                                                                                                   |
| ---                                                                                                                                                                     | ---                                                                                                                                                                                                       |
| [custom_icons.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\helpers\general\custom_icons.dart)                                               | Defines custom icons for a Flutter app, aiding visual representation consistency. It integrates font assets into the app, enhancing UI design through easily accessible and aesthetically pleasing icons. |
| [firebase_auth_service.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\helpers\general\firebase_auth_service.dart)                             | Sign-in, sign-up, and sign-out. Utilizes Firebase Auth API for seamless user management in the fitness_tracker repository.                                                                                |
| [list_extensions.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\helpers\general\list_extensions.dart)                                         | Enhances lists to automatically serialize and deserialize JSON data, streamlining data manipulation and storage within the fitness_tracker repository's architecture.                                     |
| [numerical_range_formatter_extension.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\helpers\general\numerical_range_formatter_extension.dart) | Enhances Flutter TextInput with min-max validation, ensuring proper numerical ranges.                                                                                                                     |
| [string_extensions.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\helpers\general\string_extensions.dart)                                     | Enhances strings with functions for similarity, capitalization, trigrams, and Levenshtein distance calculations. Provides extensions for list operations and filtering items not in a specified list.     |

</details>

<details closed><summary>src.lib.helpers.home</summary>

| File                                                                                                                         | Summary                                                                                                                                                                                 |
| ---                                                                                                                          | ---                                                                                                                                                                                     |
| [email_validator.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\helpers\home\email_validator.dart) | Validates email addresses to ensure correct format in a Flutter app. Extends functionality for email validation. Contributed as a helpful extension to enhance user input verification. |
| [phone_validator.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\helpers\home\phone_validator.dart) | Validates phone numbers based on a predefined format. Resides in the helpers folder.                                                                                                    |

</details>

<details closed><summary>src.lib.models.diet</summary>

| File                                                                                                                                                | Summary                                                                                                                                                                                                                                                       |
| ---                                                                                                                                                 | ---                                                                                                                                                                                                                                                           |
| [exercise_calories_list_item.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\models\diet\exercise_calories_list_item.dart) | Defines a model for exercise items with name, category, calories, and optional fields. Maps data to a structured format.                                                                                                                                      |
| [food_data_list_item.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\models\diet\food_data_list_item.dart)                 | Defines a model for storing specific food data in a users diet. Designed to capture daily consumption details for retrospective analysis. Aims to facilitate efficient retrieval of required macros from the database when utilized.                          |
| [food_item.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\models\diet\food_item.dart)                                     | Defines a data model for food items with detailed nutritional attributes. Facilitates mapping food item properties to a key-value structure for efficient storage and retrieval within the fitness tracker application.                                       |
| [user_nutrition_model.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\models\diet\user_nutrition_model.dart)               | Transforms user nutrition data into a structured map for storage. Models users daily nutrition intake, including meals, exercises, and water consumption. Organizes data for efficient retrieval in the fitness tracker system.                               |
| [user_recipes_model.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\models\diet\user_recipes_model.dart)                   | Models user recipes data structure with barcode and food lists. Utilizes conversion method to map food items. Key component for managing dietary information within the fitness tracker app architecture.                                                     |
| [user__foods_model.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\models\diet\user__foods_model.dart)                     | Defines UserNutritionFoodModel schema for storing food-related data, offering methods to convert data to a map. This model centralizes and structures user-input food details, enhancing data management and retrieval within the fitness_tracker repository. |

</details>

<details closed><summary>src.lib.models.groceries</summary>

| File                                                                                                                       | Summary                                                                                                                                                                                   |
| ---                                                                                                                        | ---                                                                                                                                                                                       |
| [grocery_item.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\models\groceries\grocery_item.dart) | Models grocery items with essential attributes for the fitness tracker apps database. Maps item details for storage and retrieval, enabling effective management of users food inventory. |

</details>

<details closed><summary>src.lib.models.stats</summary>

| File                                                                                                                         | Summary                                                                                                                                                                                          |
| ---                                                                                                                          | ---                                                                                                                                                                                              |
| [stats_model.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\models\stats\stats_model.dart)         | Defines a StatsMeasurement class with data mapping for the fitness tracker app. Allows for creating, cloning, and converting measurement data. Key features include ID, name, values, and dates. |
| [user_data_model.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\models\stats\user_data_model.dart) | Defines a data model representing user fitness statistics. It encapsulates essential user data for tracking fitness progress within the fitness tracker application.                             |

</details>

<details closed><summary>src.lib.models.workout</summary>

| File                                                                                                                                                   | Summary                                                                                                                                                                                                                                          |
| ---                                                                                                                                                    | ---                                                                                                                                                                                                                                              |
| [distance_time_measurement.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\models\workout\distance_time_measurement.dart)     | Defines a data model for distance-time statistics measurements in the fitness tracker app. Allows conversion to a map for storage and retrieval purposes. Crucial for tracking workout progress effectively within the apps architecture.        |
| [exercise_database_model.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\models\workout\exercise_database_model.dart)         | Attributes such as difficulty level, body region, and muscle groups targeted are captured. Aligning data structure with app functionality for accurate exercise tracking and categorization.                                                     |
| [exercise_list_checkbox.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\models\workout\exercise_list_checkbox.dart)           | Defines a model for exercise list checkboxes. Captures exercise name and checked status. An essential component for managing workout data within the fitness tracker application.                                                                |
| [exercise_list_model.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\models\workout\exercise_list_model.dart)                 | Defines ExerciseListModel with key workout details toMap for database operations; captures exercise name, date, category, and tracking specifications.                                                                                           |
| [exercise_model.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\models\workout\exercise_model.dart)                           | Defines ExerciseModel with properties for a workouts exercise details. Converts data to a map for storage. Links to RepsWeightStatsModel for tracking exercise stats within the fitness tracker app.                                             |
| [reps_weight_stats_model.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\models\workout\reps_weight_stats_model.dart)         | Defines RepsWeightStatsMeasurement model with measurementName and dailyLogs for workout tracking in fitness_trackers src/lib.                                                                                                                    |
| [rep_stats_measurement.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\models\workout\rep_stats_measurement.dart)             | Defines a data model for workout rep statistics, mapping measurements and repetitions.                                                                                                                                                           |
| [routines_model.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\models\workout\routines_model.dart)                           | Defines a model for workout routines with unique ID, date, name, and associated exercises. Enables conversion to a map format.                                                                                                                   |
| [time_measurement.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\models\workout\time_measurement.dart)                       | Defines data structure for tracking workout time measurements, facilitating storage and retrieval of measurement name and time in seconds, key to the fitness trackers functionality.                                                            |
| [workout_log_exercise_data.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\models\workout\workout_log_exercise_data.dart)     | Maps workout data to database schema, capturing exercise details for the fitness tracker app. Models the structure for exercise entries, including measurements, routines, intensity, reps, weight, and timestamps.                              |
| [workout_log_model.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\models\workout\workout_log_model.dart)                     | Defines a `WorkoutLogModel` for the fitness tracker app. Manages workout data structure, including start/end times, exercise details, and routine names. Aids in organizing and storing exercise logs efficiently within the apps data model.    |
| [workout_overall_stats_model.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\models\workout\workout_overall_stats_model.dart) | Defines a model for workout overall statistics with various data fields. Maps the model data to a format compatible with Firestore. Crucial for storing and retrieving workout analytics within the fitness tracker applications data structure. |

</details>

<details closed><summary>src.lib.pages.diet</summary>

| File                                                                                                                                         | Summary                                                                                                                                                                                                                                                                                                         |
| ---                                                                                                                                          | ---                                                                                                                                                                                                                                                                                                             |
| [diet_barcode_scanner.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\pages\diet\diet_barcode_scanner.dart)         | Implements a barcode scanning feature with a torch toggle in a Flutter app. Handles barcode detection, displays overlay graphics, and scans for product information. Allows users to scan barcodes, view results, and navigate to relevant pages based on scanned data.                                         |
| [diet_diet_home.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\pages\diet\diet_diet_home.dart)                     | Constructs a legacy version of the diet home page UI, displaying nutrition data and meal categories with interactive features for user interaction.                                                                                                                                                             |
| [diet_food_display_page.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\pages\diet\diet_food_display_page.dart)     | Implements interactive food display and editing functionalities linked to user nutrition inputs. Manages adding, editing, and saving food items for recipes and diaries within the fitness tracking system. Facilitates user interaction with detailed nutrition facts and serving size adjustments seamlessly. |
| [diet_food_search_page.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\pages\diet\diet_food_search_page.dart)       | Implements search functionality for food items using different sources.-Displays search results, food history, and custom food items.-Offers options to add new food items or recipes.-Includes features for searching, filtering, and displaying food items based on user preferences.                         |
| [diet_new_food_page.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\pages\diet\diet_new_food_page.dart)             | Manages editing and saving nutrition data for a new food item, with dynamic form fields and data validation. Supports barcode scanning and custom food saving. Integrates with database write providers and includes a user-friendly interface for data input and display.                                      |
| [diet_recipe_creator.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\pages\diet\diet_recipe_creator.dart)           | Implements a dynamic UI for creating and editing diet recipes in a fitness tracker app. Manages recipe ingredients, servings, and nutrition data. Supports adding, deleting, and editing recipe items. Enables users to save and view detailed recipe information within the apps diet management feature.      |
| [diet_recipe_food_search.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\pages\diet\diet_recipe_food_search.dart)   | Enables searching for, adding, and displaying food items in a diet app. Implements real-time search, barcode scanning, and custom food handling. Utilizes Firebase Firestore and integrates Internet connectivity checks. Supports dynamic UI updates based on search results.                                  |
| [food_nutrition_list_edit.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\pages\diet\food_nutrition_list_edit.dart) | Manages editing and saving food nutrition data for a fitness tracker app.-Automatically populates UI fields, enabling data entry and scanning functionality.-Facilitates calculations and updating of nutrition data.-Supports seamless navigation between screens with a user-friendly interface.              |

</details>

<details closed><summary>src.lib.pages.diet_new</summary>

| File                                                                                                                                                           | Summary                                                                                                                                                                                                                                                                                       |
| ---                                                                                                                                                            | ---                                                                                                                                                                                                                                                                                           |
| [diet_home.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\pages\diet_new\diet_home.dart)                                             | Orchestrates fetching and displaying daily nutrition data dynamically. Utilizes Firebase Analytics for user interactions. Drives a fluid UI experience with sliding gestures. Employs Provider for state management and displays nutrition and exercise data components.                      |
| [diet_nutrition_table_extraction.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\pages\diet_new\diet_nutrition_table_extraction.dart) | Implements nutrition table extraction functionality through OCR image processing. Parses text data to extract nutrition information for food items, enriching user profiles. Integrates key features like image cropping, compression, and tabular recognition for efficient data extraction. |

</details>

<details closed><summary>src.lib.pages.general</summary>

| File                                                                                                                                            | Summary                                                                                                                                                                                                                                                                                 |
| ---                                                                                                                                             | ---                                                                                                                                                                                                                                                                                     |
| [auth_choose_login_signup.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\pages\general\auth_choose_login_signup.dart) | Defines UI for user to choose between login or sign-up; displays FIT logo and buttons for each action. Ensures seamless navigation between authentication screens. Contributes to the apps user flow and branding consistency within the fitness tracker repository.                    |
| [auth_signin.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\pages\general\auth_signin.dart)                           | Creates a dynamic authentication screen for the fitness app, facilitating user login with email and password. Utilizes Firebase for authentication. Maintains user input validation and password visibility toggling. Employs Flutter widgets for intuitive UI elements and navigation. |
| [auth_signup.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\pages\general\auth_signup.dart)                           | Implements user sign-up screen UI with email and password validation. Supports toggling password visibility and account creation. Utilizes Firebase service for sign-up functionality.                                                                                                  |
| [main_page.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\pages\general\main_page.dart)                               | Implements dynamic navigation with bottom bar, user verification checks, and page caching. Manages navigation states for workout, diet, home, and metrics screens. Features smooth transitions and user-friendly interface.                                                             |
| [splashscreen.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\pages\general\splashscreen.dart)                         | Implements data fetching and processing for various user statistics and nutrition details, as well as setting up the initial app state and rendering a stylish splash screen showcasing the app logo.                                                                                   |

</details>

<details closed><summary>src.lib.pages.general_new</summary>

| File                                                                                                                                                                        | Summary                                                                                                                                                                                                                                                                                                         |
| ---                                                                                                                                                                         | ---                                                                                                                                                                                                                                                                                                             |
| [auth_landing_page.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\pages\general_new\auth_landing_page.dart)                                       | Implements a landing page with authentication features. Handles user sign-in via Google and email/phone, offering a visually appealing UI with video background and avatar. Allows seamless navigation to sign-up pages.                                                                                        |
| [calculate_calories_page.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\pages\general_new\calculate_calories_page.dart)                           | Calculates and updates users daily caloric intake based on input data. Utilizes FormFields and DropdownButtons for user input. Dynamically adjusts calorie calculation based on activity level, weight goal, and biological sex. Includes a video background and Firebase integration for user data management. |
| [user_login_page.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\pages\general_new\user_login_page.dart)                                           | Implements user authentication and login functionality using Flutter. It supports email and phone number login, with SMS verification. The interface provides interactive form fields for input validation and a video background. The user can log in securely and reset passwords if needed.                  |
| [user_registration_confirmation_email.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\pages\general_new\user_registration_confirmation_email.dart) | <code>► INSERT-TEXT-HERE</code>                                                                                                                                                                                                                                                                                 |
| [user_registration_confirmation_page.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\pages\general_new\user_registration_confirmation_page.dart)   | Defines a user registration confirmation process, allowing phone number validation and SMS code verification for account setup. Implements UI elements like text fields, buttons, and video display to facilitate user interactions.                                                                            |
| [user_registration_email_signup.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\pages\general_new\user_registration_email_signup.dart)             | Creates a user registration page for email sign-up in a Flutter app. Displays a form with email input, validation, and navigation to confirmation screen. Features image display, button actions, and a link to sign up with a mobile number.                                                                   |
| [user_setup_calories_page.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\pages\general_new\user_setup_calories_page.dart)                         | Implements user setup for calorie tracking, utilizing user data for calculations. Displays a video background with form inputs for height, weight, age, and activity details. Updates data models, calculates calories, and stores user settings before navigating to the main app page.                        |
| [user_signup.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\pages\general_new\user_signup.dart)                                                   | Empowers user signup with email verification and registration confirmation. Features email, username, and password input fields with real-time validation. Utilizes Firebase Auth for user authentication. Integrates video background and avatar glow for enhanced visual experience.                          |

</details>

<details closed><summary>src.lib.pages.groceries</summary>

| File                                                                                                                          | Summary                                                                                                                                                                                                                                                                    |
| ---                                                                                                                           | ---                                                                                                                                                                                                                                                                        |
| [groceries_home.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\pages\groceries\groceries_home.dart) | Empowers user interactions to manage groceries within the fitness tracker app. Displays categorized grocery items, enables item addition, and offers scanning capabilities. Facilitates toggling between various storage locations and supports searching within the list. |

</details>

<details closed><summary>src.lib.pages.home</summary>

| File                                                                                                 | Summary                                                                                                                                                                                                                                                                |
| ---                                                                                                  | ---                                                                                                                                                                                                                                                                    |
| [home.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\pages\home\home.dart) | Implements dynamic UI elements for the home page, including interactive animations and user-specific data display. Integrates Firebase services for user authentication and analytics. Facilitates user sign-out functionality and navigation to update calorie goals. |

</details>

<details closed><summary>src.lib.pages.info</summary>

| File                                                                                                                                   | Summary                                                                                                                                                                        |
| ---                                                                                                                                    | ---                                                                                                                                                                            |
| [info_information_home.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\pages\info\info_information_home.dart) | Defines InformationHomePage widget with appPrimaryColour background and Info text styled in white, forming the core UI for the information section in the fitness tracker app. |

</details>

<details closed><summary>src.lib.pages.stats</summary>

| File                                                                                                                                        | Summary                                                                                                                                                                                                                    |
| ---                                                                                                                                         | ---                                                                                                                                                                                                                        |
| [stats_measurements_home.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\pages\stats\stats_measurements_home.dart) | Enables adding new body measurements with validation in an alert dialog. Displays existing measurements in a scrollable list. Uses Firebase Analytics to track user actions. Maintains a clean UI with consistent styling. |
| [stats_tracking_page.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\pages\stats\stats_tracking_page.dart)         | Manages users measurement tracking, including real-time updates and interactive UI components, ensuring data integrity and seamless user experience.                                                                       |

</details>

<details closed><summary>src.lib.pages.workout_new</summary>

| File                                                                                                                                                          | Summary                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| ---                                                                                                                                                           | ---                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| [exercise_database_search.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\pages\workout_new\exercise_database_search.dart)           | Implements dynamic exercise search using Firestore data, categorizing by muscle, difficulty, and classification. Enables users to filter, search, and load exercises with pagination.                                                                                                                                                                                                                                                                                                                                                                                     |
| [exercise_selection_page.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\pages\workout_new\exercise_selection_page.dart)             | Manages exercise selection, search, and creation within workout routines.-Displays exercises as checkboxes, searching, and adding new exercises.-Allows adding selected exercises to the routine.-Utilizes Firebase services for exercise data retrieval.                                                                                                                                                                                                                                                                                                                 |
| [new_exercise_page.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\pages\workout_new\new_exercise_page.dart)                         | This code file, new_exercise_page.dart, in the fitness_tracker repositorys src/lib/pages/workout_new directory, enhances the user experience by allowing users to add new exercises to their workout routines. It leverages the dropdown_button2 package for an intuitive exercise selection process and interfaces with the ExerciseModel to efficiently manage exercise data within the application. The file plays a crucial role in expanding the functionality of the workout tracking feature, contributing to a comprehensive fitness tracking solution for users. |
| [workout_exercise_anatomy_page.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\pages\workout_new\workout_exercise_anatomy_page.dart) | Displays anatomy diagram for a workout exercise. Uses Flutter and ScreenUtil for responsive design. Leverages ExerciseModel to render visual representation.                                                                                                                                                                                                                                                                                                                                                                                                              |
| [workout_exercise_graphs_page.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\pages\workout_new\workout_exercise_graphs_page.dart)   | Visualize workout data with interactive bar graphs based on exercise type. Log analytics events. Efficiently handle empty data state with a user-friendly message. Connect to Firebase for analytics.                                                                                                                                                                                                                                                                                                                                                                     |
| [workout_exercise_page.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\pages\workout_new\workout_exercise_page.dart)                 | Manages workout logging and data visualization.-Provides interactive interface for tracking exercises.-Dynamically updates exercise logs and metrics.-Enables users to create and save workout logs.-Offers detailed graphs for exercise analysis.                                                                                                                                                                                                                                                                                                                        |
| [workout_home.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\pages\workout_new\workout_home.dart)                                   | Enables creating, tracking, and managing workout routines with interactive UI components. The code integrates Firebase Analytics and provider services while offering routine creation, exercise search, and workout history functionalities.                                                                                                                                                                                                                                                                                                                             |
| [workout_logs_home.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\pages\workout_new\workout_logs_home.dart)                         | Showcases workout log display and load functionality. Utilizes Firebase Analytics and Provider. Renders AppBar with title, WorkoutLogPageList, and Load More button. Enhances user experience by disallowing overscroll indicators.                                                                                                                                                                                                                                                                                                                                       |
| [workout_log_page.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\pages\workout_new\workout_log_page.dart)                           | Manages workout data and statistics presentation.-Retrieves workout volume and routine details.-Dynamically handles internet connection states.-Displays current workout log details with a timer.-Updates UI with exercise data and timestamps.                                                                                                                                                                                                                                                                                                                          |
| [workout_routine_page.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\pages\workout_new\workout_routine_page.dart)                   | Implements interactive workout routine page with dynamic floating action buttons.-Facilitates adding exercises, searching routines, viewing past/current workouts.-Enhances user experience by enabling seamless navigation through routine management within the fitness tracking app.                                                                                                                                                                                                                                                                                   |
| [workout_selected_log_page.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\pages\workout_new\workout_selected_log_page.dart)         | Generates workout statistics display, fetches data with internet check, calculates total volume, and formats workout time. Renders routine details, exercises, and line charts for the selected workout log.                                                                                                                                                                                                                                                                                                                                                              |

</details>

<details closed><summary>src.lib.providers.diet</summary>

| File                                                                                                                                   | Summary                                                                                                                                                                                                                                                                                                                                                                                                            |
| ---                                                                                                                                    | ---                                                                                                                                                                                                                                                                                                                                                                                                                |
| [user_nutrition_data.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\providers\diet\user_nutrition_data.dart) | User_nutrition_data.dart`This file in the `fitness_tracker` repositorys `providers\diet` directory manages user nutrition data for the application. It imports essential packages and extends functionality through custom models and helpers. The code facilitates tracking and managing user-specific nutrition information within the diet module, supporting comprehensive user health and fitness monitoring. |

</details>

<details closed><summary>src.lib.providers.general</summary>

| File                                                                                                                                          | Summary                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| ---                                                                                                                                           | ---                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| [database_get.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\providers\general\database_get.dart)                   | The `database_get.dart` file in the `src\lib\providers\general` directory of the fitness_tracker repository is responsible for fetching and managing user data related to nutrition, exercise, recipes, groceries, and stats stored in the Firebase backend. It interacts with Firebase authentication, nutrition tracking, exercise calorie records, user recipes, grocery items, and user data models to provide a comprehensive view of the users health and fitness information within the application. |
| [database_write.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\providers\general\database_write.dart)               | Updates various user and workout data in Firestore collections, including meal, nutrition, exercise, and routine details. Handles data insertions, updates, and deletions based on user interactions and input. Maintains synchronization between the app and Firestore backend for fitness tracking functionalities.                                                                                                                                                                                       |
| [general_data_provider.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\providers\general\general_data_provider.dart) | Manages and updates daily streak data for a fitness app in the general data provider. Tracks streaks and updates the last date and count accordingly. Integrates with a database writer for data persistence.                                                                                                                                                                                                                                                                                               |
| [page_change_provider.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\providers\general\page_change_provider.dart)   | Manages page transitions and caching in the app. Controls navigation state, transition effects, data loading statuses, and analytics events. Handles dynamic page caching for smoother user experience.                                                                                                                                                                                                                                                                                                     |

</details>

<details closed><summary>src.lib.providers.grocery</summary>

| File                                                                                                                                    | Summary                                                                                                                                                                                                                                               |
| ---                                                                                                                                     | ---                                                                                                                                                                                                                                                   |
| [groceries_provider.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\providers\grocery\groceries_provider.dart) | Manages grocery lists, including creating, updating, and deleting items. Syncs data with Firebase Firestore, enabling real-time updates. Supports categorizing items into cupboard, fridge, freezer, or needed. Influences the grocery UI experience. |

</details>

<details closed><summary>src.lib.providers.stats</summary>

| File                                                                                                                                | Summary                                                                                                                                                                                                             |
| ---                                                                                                                                 | ---                                                                                                                                                                                                                 |
| [user_data.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\providers\stats\user_data.dart)                 | Manages user biometric data updates, triggering notifications & database writes. Maintains user height, weight, age, activity level, weight goal, biological sex, and consumed calories for a fitness tracking app. |
| [user_measurements.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\providers\stats\user_measurements.dart) | Manages user stats measurements in the fitness tracker, providing functions to update, add, delete, and sort measurements. Enhances user experience and data organization within the application.                   |

</details>

<details closed><summary>src.lib.providers.workout</summary>

| File                                                                                                                              | Summary                                                                                                                                                                                                                                           |
| ---                                                                                                                               | ---                                                                                                                                                                                                                                               |
| [workoutProvider.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\providers\workout\workoutProvider.dart) | Manages workout data, tracks stats, logs exercises, and routines for the fitness tracker app. Handles workout start/end, tracks daily streaks, exercise categories, and overall workout statistics. Keeps records and updates logs intelligently. |

</details>

<details closed><summary>src.lib.widgets.android_widget</summary>

| File                                                                                                                                   | Summary                                                                                                                                                                                                                                                                      |
| ---                                                                                                                                    | ---                                                                                                                                                                                                                                                                          |
| [calories_widget.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\android_widget\calories_widget.dart) | Implements a custom Calories Widget for the fitness tracker application.-Integrates with Android platform UI components.-Enhances user experience by displaying and managing calorie-related data.-Contributes to the overall functionality of the fitness tracking feature. |

</details>

<details closed><summary>src.lib.widgets.diet</summary>

| File                                                                                                                                                             | Summary                                                                                                                                                                                                                                                   |
| ---                                                                                                                                                              | ---                                                                                                                                                                                                                                                       |
| [diet_category_add_bar.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\diet\diet_category_add_bar.dart)                         | Implements a widget for adding food to a diet category. Utilizes buttons for food search and barcode scanning, facilitating seamless user interaction within the fitness tracker app.                                                                     |
| [diet_category_add_bar_exercise.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\diet\diet_category_add_bar_exercise.dart)       | Enables adding exercises with names and calories burned to nutrition diary. Presents user-friendly dialogs for input validation and submission. Supports seamless integration with user nutrition data provider.                                          |
| [diet_category_box.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\diet\diet_category_box.dart)                                 | Implements a dynamic diet category box allowing users to edit food entries and add new ones. The widget is designed to display a list of food items with interactive functionalities like editing, deleting, and canceling.                               |
| [diet_exercise_box.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\diet\diet_exercise_box.dart)                                 | Displays a diet exercise box with dynamic content for a specified category. Utilizes a scrolling list of exercises and provides options for adding exercises. Interacts with user nutrition data for seamless integration within the fitness tracker app. |
| [diet_home_macro_nutrition_display.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\diet\diet_home_macro_nutrition_display.dart) | Enhances diet tracking with interactive nutrition display widgets. Dynamically updates user data visuals such as calories, macros, and minerals. Utilizes a clean UI design approach for seamless user engagement in the fitness tracker app ecosystem.   |
| [diet_list_header_box.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\diet\diet_list_header_box.dart)                           | Defines a dynamic header box for diet lists in the Flutter app, facilitating smooth scroll animations. Key features include adjustable title size, custom colors, and controlled horizontal scrolling.                                                    |
| [exercise_list_item_box.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\diet\exercise_list_item_box.dart)                       | Generates a scroll behavior to showcase exercise list items with interactive icons. Displays calories, exercise names, and icons with tap functionality. Designed for the fitness tracker apps user interface in the Flutter framework.                   |
| [food_history_list_item_box.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\diet\food_history_list_item_box.dart)               | Renders a customizable food history entry UI box.-Features scroll animations on widget initialization.-Allows interaction via icons with callbacks.-Supports dynamic content and dynamic icon display based on input data.                                |
| [food_list_item_box.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\diet\food_list_item_box.dart)                               | Implements a dynamic, interactive food list display with scrolling and tap actions for a nutrition tracking app. Displays food item details and calorie information with customizable icons.                                                              |
| [food_list_search_display_box.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\diet\food_list_search_display_box.dart)           | Implements a dynamic display box for food items in a Flutter app. Automatically scrolls to show additional content and features customizable icons and styling based on the food items data.                                                              |
| [food_nutrition_list_formfield.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\diet\food_nutrition_list_formfield.dart)         | Enables custom food nutrition input within diet forms, updating user data dynamically. Supports numeric entries with customized units. Styled for seamless user experience, enhancing the diet tracking feature in the fitness tracker app.               |
| [food_nutrition_list_text.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\diet\food_nutrition_list_text.dart)                   | Calculates and displays nutritional values based on serving size for a food item. Utilizes Flutter widgets to present information in a visually appealing manner.                                                                                         |
| [nutrition_progress_bar.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\diet\nutrition_progress_bar.dart)                       | Calculates progress distance and color for a nutrition progress bar. Displays title, current progress, goal, and units. Adjusts color based on progress and excludes color change if specified. Animates progress indicator.                              |

</details>

<details closed><summary>src.lib.widgets.diet_new</summary>

| File                                                                                                                                                                 | Summary                                                                                                                                                                                                                                                                                                |
| ---                                                                                                                                                                  | ---                                                                                                                                                                                                                                                                                                    |
| [diet_home_bottom_button.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\diet_new\diet_home_bottom_button.dart)                     | Enables navigation to food search page on button tap, enhancing user experience with styled UI components. Integrates with provider for page state management in the Flutter fitness tracker app.                                                                                                      |
| [diet_home_calories_circle.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\diet_new\diet_home_calories_circle.dart)                 | Implements a dynamic calorie circle UI component, displaying consumed vs. remaining calories. Enables toggling calorie display with animation. Utilizes Firebase Analytics for event tracking.                                                                                                         |
| [diet_home_daily_nutrition_display.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\diet_new\diet_home_daily_nutrition_display.dart) | Showcases daily nutrition display UI with a customizable layout. Integrates date picker, calorie circle, and nutrition bars to visualize user data. Supports seamless interaction with user nutrition data provider.                                                                                   |
| [diet_home_date_picker.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\diet_new\diet_home_date_picker.dart)                         | Enables selecting and loading nutrition data by date, enhancing user experience and engagement. Implements Firebase Analytics for event tracking, displays a user-friendly calendar for date selection, and efficiently retrieves data from cache or server based on internet connection availability. |
| [diet_home_exercise_bottom_button.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\diet_new\diet_home_exercise_bottom_button.dart)   | Enables users to add new exercises with names and calories burned, enhancing user nutrition diary functionality. Integrates input validation and user-friendly interface for seamless data entry in the diet tracking feature of the fitness tracker application.                                      |
| [diet_home_exercise_display.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\diet_new\diet_home_exercise_display.dart)               | Implements dynamic editing and display of exercises in the Diet section, allowing users to modify exercise details and track burned calories. Utilizes Flutter widgets to create a user-friendly interface with interactive components.                                                                |
| [diet_home_extra_nutrition_bars.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\diet_new\diet_home_extra_nutrition_bars.dart)       | Illustrates expandable nutrition bars for diet tracking. Renders detailed nutrient data with animated show/hide functionality. Syncs real-time data using Firebase Analytics. Enhances user experience in a Flutter app.                                                                               |
| [diet_home_food_display.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\diet_new\diet_home_food_display.dart)                       | Implements dynamic editing and display features for food items in the diet section. Calculates nutrition values, enables deletion, and offers editing options. Displays food items with total calories and allows barcode scanning for adding new items.                                               |
| [diet_home_nutrition_bars.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\diet_new\diet_home_nutrition_bars.dart)                   | Generates diet home nutrition bars display based on user data for proteins, fats, and carbs. Utilizes Provider for state management and Flutter ScreenUtil for responsive design. Part of fitness tracker apps UI components.                                                                          |
| [diet_home_nutrition_bar_long.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\diet_new\diet_home_nutrition_bar_long.dart)           | Illustrates a dynamic nutrition bar widget in the Flutter app for tracking fitness goals. Presents progress towards goal visually, adapting indicator color and size based on user settings. Enhances user experience and engagement with animated visuals.                                            |
| [diet_home_nutrition_bar_short.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\diet_new\diet_home_nutrition_bar_short.dart)         | Displays a compact nutrition bar widget with label, progress, and goal for a Flutter app. Dynamically adjusts the bars length based on progress relative to the goal, enhancing the apps user interface.                                                                                               |
| [diet_water_box.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\diet_new\diet_water_box.dart)                                       | Generates** a widget for displaying water intake information, including title, current intake amount, and a rating bar for user interaction. Implements Firebase Analytics for tracking updates.                                                                                                       |
| [exercise_list_item_box_new.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\diet_new\exercise_list_item_box_new.dart)               | Implements a dynamic exercise list item UI for a fitness tracker app. Automatically scrolls horizontally, providing exercise details and calorie count. Enhances user experience by allowing interactive tapping on the item.                                                                          |
| [food_list_item_box_new.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\diet_new\food_list_item_box_new.dart)                       | Enhances diet tracking UI with interactive scrolling, dynamic content display, and calorie calculations. Optimizes user experience by auto-scrolling to ensure full food item visibility.                                                                                                              |

</details>

<details closed><summary>src.lib.widgets.general</summary>

| File                                                                                                                                                              | Summary                                                                                                                                                                                                                                            |
| ---                                                                                                                                                               | ---                                                                                                                                                                                                                                                |
| [app_container_header.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\general\app_container_header.dart)                         | Defines a reusable Flutter widget for displaying app headers. Manages header layout and styling based on title size. Encapsulates design details to ensure consistency across the fitness tracker app UI.                                          |
| [app_default_button.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\general\app_default_button.dart)                             | Creates a customizable button component for the fitness tracker app, integrating Firebase Analytics. Supports dynamic colors, text, and tap actions. Ensures a polished user interface through font styling and shadow effects.                    |
| [app_dropdown_form.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\general\app_dropdown_form.dart)                               | Enables dynamic search functionality for dropdown items based on user input. Automatically sorts and displays matching items. Integrated with Firebase Analytics for user interaction tracking.                                                    |
| [faded_widget.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\general\faded_widget.dart)                                         | Implements a versatile FadedWidget for Flutter UIs using gradient shaders to create fading effects on all edges. This widget enhances visual appeal and adds a modern touch to the UI components within the fitness tracker app.                   |
| [horizontal_bar_chart.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\general\horizontal_bar_chart.dart)                         | Visualizes data with a dynamic horizontal bar chart based on real and filtered values. Calculates scaling and outlier thresholds for accurate representation. Includes customizable labels and values for fitness tracking insights.               |
| [incremental_counter.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\general\incremental_counter.dart)                           | Implements an interactive Incremental Counter widget for the fitness tracker app. Enables users to increment and decrement values with customizable buttons, integrated with Firebase Analytics for tracking.                                      |
| [screen_width_button.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\general\screen_width_button.dart)                           | Enables creating a responsive full-width button with stylized text for Flutter apps. Integrates with diet and nutrition features, utilizing Provider for state management and Flutter Screen Util for consistent UI across various screen sizes.   |
| [screen_width_container.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\general\screen_width_container.dart)                     | Enables responsive UI design in Flutter app. Adjusts container width based on screen size. Supports custom margins. Scaffolded within the widgets and general folders. Complements the parent repository's architecture for modular UI components. |
| [screen_width_expanding_container.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\general\screen_width_expanding_container.dart) | Enables dynamic expansion of content width on screens. Utilizes responsive design for consistent layout. Maintains specified minimum height while adapting to various screen sizes. Incorporates customizable margins for flexible styling.        |

</details>

<details closed><summary>src.lib.widgets.groceries</summary>

| File                                                                                                                                | Summary                                                                                                                                                                                                                                    |
| ---                                                                                                                                 | ---                                                                                                                                                                                                                                        |
| [grocery_list.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\groceries\grocery_list.dart)         | Implements dynamic filtered grocery lists with live database updates for different storage areas. Each list filters and displays relevant items based on search criteria.                                                                  |
| [grocery_list_box.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\groceries\grocery_list_box.dart) | Enhances grocery management by enabling effortless editing and categorization.-Allows seamless item additions, updates, and deletions, bringing flexibility to the grocery list.-Employs color-coded labels for clear item categorization. |

</details>

<details closed><summary>src.lib.widgets.stats</summary>

| File                                                                                                                                        | Summary                                                                                                                                                                                                                                                                                        |
| ---                                                                                                                                         | ---                                                                                                                                                                                                                                                                                            |
| [stats_add_data.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\stats\stats_add_data.dart)                 | Enables adding stats measurements with date selection and value input validation. Utilizes Flutter widgets for user interaction and Provider for state management. Supports saving measurements to the database.                                                                               |
| [stats_container_widget.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\stats\stats_container_widget.dart) | Generates** a detailed statistics display interface with interactive charts and measurements, integrated with navigation controls for users to explore individual data entries easily. This component enhances user engagement and data visualization within the fitness tracking application. |
| [stats_edit_data.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\stats\stats_edit_data.dart)               | Manages editing and deleting user stats measurements.-Displays stat date and value for editing.-Validates and updates stat value.-Confirms deletion with date information.-Integrated with database write functions and state management.                                                      |
| [stats_line_chart.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\stats\stats_line_chart.dart)             | Visualizes users fitness data as an interactive line chart.-Dynamically adjusts axis values and styling.                                                                                                                                                                                       |

</details>

<details closed><summary>src.lib.widgets.workout_new</summary>

| File                                                                                                                                                              | Summary                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| ---                                                                                                                                                               | ---                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| [anatomy_diagram.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\workout_new\anatomy_diagram.dart)                               | Visualizes muscle anatomy for selected exercises using color-coded diagrams. Determines muscle display and color based on exercise model or database info. Enhances workout visualizations by highlighting target muscle groups dynamically.                                                                                                                                                                                                                                   |
| [daily_tracker_circle.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\workout_new\daily_tracker_circle.dart)                     | Illustrates dynamic workout completion circles with colors based on daily progress. Enforces visual consistency and interactivity in the fitness tracker app.                                                                                                                                                                                                                                                                                                                  |
| [database_search_box.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\workout_new\database_search_box.dart)                       | Implements interactive workout search box with muscle highlighting, collapsible panels for videos, and dynamic sizing. Integrates Firebase Analytics, Youtube Player, and URL launching functionalities within a fitness tracker app.                                                                                                                                                                                                                                          |
| [exercise_selection_box.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\workout_new\exercise_selection_box.dart)                 | Implements a customizable Exercise Selection Box widget for the fitness tracker app. Enhances user experience by enabling dynamic exercise selection with visual feedback.                                                                                                                                                                                                                                                                                                     |
| [home_page_routines_list.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\workout_new\home_page_routines_list.dart)               | Enables rendering and displaying workout routines list in the home page using Provider package and custom widgets. Stimulates interaction and navigation to detailed routine information, fostering a seamless user experience within the Fitness Tracker app architecture.                                                                                                                                                                                                    |
| [muscle_anatomy_diagram_painter.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\workout_new\muscle_anatomy_diagram_painter.dart) | This code file in the fitness_tracker repository is a critical component responsible for managing user authentication and authorization within the fitness tracking application. It provides essential functionality for users to securely log in, verify their identity, and access personalized fitness data. By ensuring robust security measures and user privacy, this code promotes a seamless and trustworthy user experience within the fitness application ecosystem. |
| [routine_box.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\workout_new\routine_box.dart)                                       | Implements routine display and interaction for the fitness tracker app. Calculates days passed since the routine date, and enables users to view, expand, and delete routines. Supports smooth UI interactions with animations.                                                                                                                                                                                                                                                |
| [routine_page_exercise_box.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\workout_new\routine_page_exercise_box.dart)           | Implements a widget for displaying workout routine details, handling user interactions, and providing options to view and delete exercises. Enhances user engagement and functionality within the fitness tracker app.                                                                                                                                                                                                                                                         |
| [routine_page_exercise_list.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\workout_new\routine_page_exercise_list.dart)         | Enables reordering exercises in a workout routine list. Displays exercises with drag-and-drop functionality. Supports dividing exercises between main and accessory categories for a streamlined user experience.                                                                                                                                                                                                                                                              |
| [workout_bottom_button.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\workout_new\workout_bottom_button.dart)                   | Implements a reusable Flutter button for workout actions. Renders with customizable text, size, color, and tap behavior. Encapsulates design consistency and user interaction patterns within the fitness tracker app architecture.                                                                                                                                                                                                                                            |
| [workout_daily_tracker.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\workout_new\workout_daily_tracker.dart)                   | Displays weekly workout progress visually with circles for each day. Utilizes data from the workout provider to track completed exercises. Promotes a user-friendly interface for monitoring fitness routines in the Fitness Tracker app.                                                                                                                                                                                                                                      |
| [workout_dropdown_box.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\workout_new\workout_dropdown_box.dart)                     | Enables interactive workout selection with a customizable dropdown box. Facilitates dynamic search, item selection, and visual customization to enhance the user experience.                                                                                                                                                                                                                                                                                                   |
| [workout_home_log_box.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\workout_new\workout_home_log_box.dart)                     | Enables interactive display of workout logs with routine details and dates. Facilitates easy navigation to detailed workout logs through user interaction. Enhances user experience and engagement with workout tracking functionality.                                                                                                                                                                                                                                        |
| [workout_home_stats.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\workout_new\workout_home_stats.dart)                         | Generates workout statistics display using provided data from the WorkoutProvider, enhancing the user interface with key metrics for overall, monthly, and yearly workout performance.                                                                                                                                                                                                                                                                                         |
| [workout_home_stats_dropdown.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\workout_new\workout_home_stats_dropdown.dart)       | Creates a dynamic workout stats dropdown with expand/collapse functionality.-Utilizes Firebase Analytics for event tracking.-Enhances user experience and engagement.                                                                                                                                                                                                                                                                                                          |
| [workout_line_chart.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\workout_new\workout_line_chart.dart)                         | Generates interactive workout line charts based on user data. Visualizes workout progress, optimizing display for efficient data representation.                                                                                                                                                                                                                                                                                                                               |
| [workout_log_box.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\workout_new\workout_log_box.dart)                               | Illustrates a dynamic workout log box with expandable details. Displays exercise data and enables log deletion. Enhances user interaction for tracking fitness progress within the fitness tracker app.                                                                                                                                                                                                                                                                        |
| [workout_log_page_list.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\workout_new\workout_log_page_list.dart)                   | Enables rendering workout log entries dynamically using ListView builder within the WorkoutLogPageList widget. Integrates seamlessly with WorkoutProvider to fetch and display workout logs efficiently.                                                                                                                                                                                                                                                                       |
| [workout_log_top_stats_box.dart](https://github.com/AndrewEllen/fitness_tracker/blob/master/src\lib\widgets\workout_new\workout_log_top_stats_box.dart)           | Creates a customizable top stats box for workout logs, displaying data elegantly in a Flutter app. Handles styling and layout for key workout statistics.                                                                                                                                                                                                                                                                                                                      |

</details>

---

## 🚀 Getting Started

**System Requirements:**

* **Dart**: `version 3.4.0`
* **Flutter**: `version 3.21.0`
* **Android Studio**: `Android Studio Bumblebee 2021.1.1 or later. Or another compatible IDE`

### ⚙️ Installation

<h4>From <code>source</code></h4>

> 1. Clone the fitness_tracker repository:
>
> ```console
> $ git clone https://github.com/AndrewEllen/fitness_tracker
> ```
>
> 2. Change to the project directory:
> ```console
> $ cd fitness_tracker
> ```
>
> 3. Install the dependencies:
> ```console
> $ pub get
> ```
>
> 4. Setup Flutter and Android Studio:
> ```console
> Follow the instructions for an Android app at https://docs.flutter.dev/get-started/install
> ```
>
> 5. Setup a firebase project and FlutterFire:
> ```console
> Follow the instructions at https://firebase.google.com/docs/flutter/setup?platform=android
> ```
>
> 6. Setup Cloud Firestore, Authentication, Crashlytics and Analytics:
> ```console
> Follow the instructions on the firebase console to complete setup. This will require some google cloud console configuration involving SHA keys.
> ```
>
> 7. Setup the Cloud Firestore rules by copy pasting the following:
> ```console
> rules_version = '2';
>   service cloud.firestore {
>   match /databases/{database}/documents {
>      match /predefined-data/predefined-categories {
>         allow get: if request.auth != null;
>      }
>      match /predefined-data/predefined-exercises {
>         allow get: if request.auth != null;
>      }
>      match /predefined-data/predefined-routines {
>         allow get: if request.auth != null;
>      }
>      match /exercise-database/{document=**} {
>         allow read, get: if request.auth != null;
>      }
>      match /predefined-data/predefined-training-plans {
>         allow get: if request.auth != null;
>      }
>      match /user-data/{user}/{document=**} {
>         allow read, update, delete: if request.auth != null && request.auth.uid == user;
>         allow create: if request.auth != null;
>      }
>      match /food-data/{barcode=**} {
>         allow read, update: if request.auth != null;
>         allow create: if request.auth != null;
>      }
>      match /recipe-data/{barcode=**} {
>         allow read, update: if request.auth != null;
>         allow create: if request.auth != null;
>      }
>      match /grocery-lists/{document=**} {
>         allow read, update, delete: if request.auth != null;
>         allow create: if request.auth != null;
>      }
>   }
>   }
> ```
>
> 8. Create and add your OCR API key:
> ```console
> Sign up to https://ocr.space/OCRAPI
> Create the file "OCRapiKey.dart" inside of src/lib
> Add this line to the file
   const OCRAPIKEY = "APIKEY";
> Where APIKEY is the API key you just created
> ```
>
> 9. Build the APK:
> ```console
> In Android studio run build android apk
> or
> In the IDE console run 
   flutter build apk
> ```
>
> 10. Install the app:
> ```console
> Copy the APK onto your device and install it.
> ```
### 🤖 Usage

<h4>From <code>source</code></h4>

> Run fitness_tracker using the command below:
> ```console
> $ dart main.dart
> ```

### 🧪 Tests

> Run the test suite using the command below:
> ```console
> $ dart test
> ```

---

## 🛠 Project Roadmap

- [X] `► Implement exercise searching with informational videos`
- [X] `► Implement automatic calorie calculations for workouts`
- [X] `► Implement break down of muscles used in an exercise with a diagram`
- [ ] `► Improve workout tracking by adding reps and time tracking without the need for weight and distance.`
- [ ] `► Implement muscle group tracking on workouts.`
- [ ] `► Implement training plans and training plan sharing.`

---

## 🐞 Known Bugs

- Sometimes the Barcode scanner won't detect a barcode
> To fix this press the back button and then reopen the scanner while pointing the camera at the barcode.

---

## 🤝 Contributing

Contributions are welcome! Here are several ways you can contribute:

- **[Report Issues](https://github.com/AndrewEllen/fitness_tracker/issues)**: Submit bugs found or log feature requests for the `fitness_tracker` project.
- **[Submit Pull Requests](https://github.com/AndrewEllen/fitness_tracker/blob/main/CONTRIBUTING.md)**: Review open PRs, and submit your own PRs.
- **[Join the Discussions](https://github.com/AndrewEllen/fitness_tracker/discussions)**: Share your insights, provide feedback, or ask questions.

<details closed>
<summary>Contributing Guidelines</summary>

1. **Fork the Repository**: Start by forking the project repository to your github account.
2. **Clone Locally**: Clone the forked repository to your local machine using a git client.
   ```sh
   git clone https://github.com/AndrewEllen/fitness_tracker
   ```
3. **Create a New Branch**: Always work on a new branch, giving it a descriptive name.
   ```sh
   git checkout -b new-feature-x
   ```
4. **Make Your Changes**: Develop and test your changes locally.
5. **Commit Your Changes**: Commit with a clear message describing your updates.
   ```sh
   git commit -m 'Implemented new feature x.'
   ```
6. **Push to github**: Push the changes to your forked repository.
   ```sh
   git push origin new-feature-x
   ```
7. **Submit a Pull Request**: Create a PR against the original project repository. Clearly describe the changes and their motivations.
8. **Review**: Once your PR is reviewed and approved, it will be merged into the main branch. Congratulations on your contribution!
</details>

<details closed>
<summary>Contributor Graph</summary>
<br>
<p align="center">
   <a href="https://github.com{/AndrewEllen/fitness_tracker/}graphs/contributors">
      <img src="https://contrib.rocks/image?repo=AndrewEllen/fitness_tracker">
   </a>
</p>
</details>

---

## 🎗 License

All rights reserved, 2024.

You are free to use this project for private use only.

---

[**Return**](#-overview)

---
