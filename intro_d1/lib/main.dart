// Importing the required packages for the app's functionality
import 'package:intro_d1/countDownTimerScreen.dart';  // Screen for countdown timer functionality
import 'package:intro_d1/splashscreen.dart';  // Screen for the app's splash screen
import 'package:flutter/material.dart';  // Core Flutter framework widgets and styling
import 'package:flutter_dotenv/flutter_dotenv.dart';  // Package for loading environment variables from a file
import 'package:firebase_core/firebase_core.dart';  // Core Firebase package for initializing the app with Firebase

// Asynchronous main function to ensure necessary asynchronous operations are done before app starts
Future<void> main() async {
  // Load environment variables from a file named "assets/.env"
  await dotenv.load(fileName: "assets/.env");

  // Ensuring that plugin services are initialized (required for Firebase)
  WidgetsFlutterBinding.ensureInitialized();

  // Initializing Firebase with the settings in the application
  await Firebase.initializeApp();

  // Run the main MyApp widget (which is the root of your app)
  runApp(const MyApp());
}

// Main app widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});  // Constructor for MyApp

  // Main widget rendering method
  @override
  Widget build(BuildContext context) {
    // MaterialApp provides a number of widgets required for Material design apps like navigation, theming etc.
    return MaterialApp(
      title: 'Echo',  // The title of the application, used in places like the task switcher
      theme: ThemeData(
        primarySwatch: Colors.blue,  // Primary color palette for the app
      ),
      home: const SplashScreen(),  // The default first screen of the app, here it's set to SplashScreen
    );
  }
}
