# FIT

## How to build the FIT app yourself. (Android)

This project is designed and tested for Android 13 although it should support any device from Android 5 onwards.


### Step 1 - Install Flutter

To install Flutter you can follow the [Flutter Install Instructions](https://docs.flutter.dev/get-started/install) from the flutter dev website.

Ensure that you have properly installed and set up Android Studio and Flutter. This may require a PC restart once installed.

This project is being developed on Windows 10 using Android Studio, although the OS and IDE don't necessarily need to be the same.


### Step 2 - Clone the repo

To clone the repository you can either Clone it or download it although it is best practice to clone it.

- Clone the repo

  Use "git clone git@github.com:AndrewEllen/fitness_tracker.git <path>" in the command line to clone the repository. Path specifies what folder to clone into.

  If you don't have git installed you can find the download for it [here](https://git-scm.com/downloads)


- Download the repo

  Navigate to the repository root [here](https://github.com/AndrewEllen/fitness_tracker). Click the green "Code" button and select "Download Zip" at the bottom of the dropdown.

  Once you have done this don't forget to extract the zip file.


### Step 3 Open the project folder in android studio

- Launch android studio.

- Select "file" at the top left of the window.

- Select "open" from the dropdown.

- Select the fitness_tracker folder, this folder should contain the src and builds folders inside of it.

- Select "OK" to open the project folder.


### Step 4 Run Pub Get

Now that you have the project open you will need to run the pub get command. Navigating to "pubspec.yaml" inside of the "src" folder should give a prompt for the option on the top of the editor window.

If this is not the case then open the IDE's terminal and run "flutter pub get"


### Step 5 Follow the instructions for setting up Firebase

Note: You will need to set up a firebase project [here](https://firebase.google.com/). This project uses Firestore Database, Firebase Auth and Crashlytics currently.

Follow the instruction [here](https://firebase.google.com/docs/flutter/setup?platform=android) to setup firebase with flutter.


### Step 6 Set up Database Rules

Open up the Cloud Firestore console and navigate to Rules.

Copy the rules from [DBRULES.md](DBRULES.md) and replace the default rules from firebase and save.


### Step 7 Build the app

Assuming all has gone to plan the app should now be functional.

- On Android studio click the "build" button at the top of the window.

- Click "Flutter"

- Click "Build APK"


### Step 8 Copy the APK to your device

Navigate to "src/build/app/outputs/flutter-apk/" to find the "app-release.apk".

Copy the APK to your android device either through a USB connection or another way such as saving it to google drive and downloading it on the device.

Run the APK to install.
