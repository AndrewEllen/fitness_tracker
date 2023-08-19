# Conventions

[LO2.6.1.1]

- [Coding Guideline](#coding-guideline)
  - [Variable Names](#variable-names)
  - [Indentation](#indentation)
  - [Constants And Exports Files](#constants-and-exports-files)
  - [File Names](#file-names)
  - [File Locations](#file-locations)
  - [Navigation Between App Pages](#navigation-between-app-pages)
  - [Commenting Guidelines](#commenting-guidelines)
- [Git Guidelines](#git-guidelines)
  - [Branches](#branches)
  - [Pull Requests](#pull-requests)

## Coding Guideline

- ### Variable Names
  - Use camelCase naming convention when defining variables (eg. ).
    - The Exception to this is when defining a Function, Class or Widget. Always use capitalized letters for each word in this case (eg. HomeScreen(), FindMax() etc).
  - Use an underscore at the beginning of a booleans name when defining the variable.
  - Use an underscore at the beginning of a variables name when defining the variable in a provider class.
  - Use an underscore at the beggining of a variables name if it is inside a build() Widget just before the return statement.
  - Avoid using an underscore when defining a variable anywhere else.
  - Use meaningful, self describing variable names in all cases.
    - Avoid using shortened words for variable names as it makes the code harder to read and understand for other developers. (eg. routNmeCtrlr should be routineNameController).

- ### Indentation
  - Use a tab size of two spaces when coding.
  - Using "Reformat Code With 'dart format'" in Android studio may change some spacing to 4 spaces or some Widgets may insist on 4 spaces, don't worry about these.

- ### Constants And Exports Files
  - When making a variable/value that will be used multiple times such as the apps primary colour make it inside the constants file.
  - When making a page please put it inside the exports file as an export (eg. export 'pages/home.dart';).

- ### File Names
  - When naming a file make sure to use meaningful names without shortened words.
  - Use underscores instead of spaces in the names.
  - When naming a page file use the section of the app the page is for at the start of the name. This will make it easier to find the page you're after when lookiing for them. (eg. create_exercises.dart should be workout_create_exercises.dart).

- ### File Locations
  - Files should be in the appropriate folders (eg. a Widget inside the Widgets folder, a Screen inside the Screens folder etc).

- ### Dependencies
  - Any dependency package for the app should be placed inside the pubspec.yaml under the "dependencies:" header.
  - Similarly any Assets should be under the "assets:" header and Fonts under the "fonts:" header.

- ### Navigation Between App Pages
  - Avoid using Navigator to switch page.
    - As this app is a Single-Page Application using Navigator will cause the navigation bar to dissapear.
  - Instead use "context.read<PageChange>().changePage(InsertPageWidgetHere)".

- ### Commenting Guidelines
  - When Commenting something that needs done in future please use "//todo" before the commented task. This will highlight it in yellow in Android Studio.

## Git Guidelines

- ### Branches
  - When Creating a branch please name it after the story point id you're working on (eg. FIT-11).
  - Remember to do a pull before starting any work and before pushing your work.
  - Avoid editing files that are not needed for the current Jira task while on your Branch.

- ### Pull Requests
  - When reviewing a pull request make sure to read over the changed code and verify the variable names follow the guidelines and that the code works.