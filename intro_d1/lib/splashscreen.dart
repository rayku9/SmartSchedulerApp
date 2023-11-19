// Import the Flutter Material Design library, which provides various Material Design widgets and utilities.
import 'package:flutter/material.dart';

// Import the loginScreen.dart file to access the LoginPage widget.
import 'loginScreen.dart';

// Define a stateful widget named SplashScreen.
class SplashScreen extends StatefulWidget {
  // Constructor for the SplashScreen widget. The `key` argument is optional.
  const SplashScreen({Key? key}) : super(key: key);

  // Create a state object for the SplashScreen widget.
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

// Define the state object for the SplashScreen widget.
class _SplashScreenState extends State<SplashScreen> {
  // This method runs when this widget is created.
  @override
  void initState() {
    super.initState();
    init();
  }

  // Define an asynchronous method named `init`.
  Future<void> init() async {
    // Introduce a delay of 2 seconds.
    await Future.delayed(const Duration(seconds: 2))
        .then((value) {
      // Remove the current screen from the navigation stack.
      Navigator.pop(context);
      // Navigate to the LoginPage after the delay.
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
    });
  }

  // Override the setState method to prevent updating the widget state if it's not mounted (e.g., removed from the widget tree).
  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  // Define the widget tree to be rendered.
  @override
  Widget build(BuildContext context) {
    // Provide basic OS-level features for the widget tree.
    return SafeArea(
      // Scaffold provides a basic structure for Material Design visual layout.
      child: Scaffold(
        // Set the background color of the scaffold.
        backgroundColor: const Color.fromRGBO(27, 56, 100, 1.0),
        // Define the body of the scaffold.
        body: Stack(
          // Center the children of the stack.
          alignment: Alignment.center,
          children: [
            // Provide padding to its child widget.
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Create a space between the widgets in the column.
                  const Spacer(),
                  // A container to hold the logo image.
                  Container(
                    height: 180,
                    width: 180,
                    decoration: const BoxDecoration(
                      // Display the logo image inside the container.
                      image: DecorationImage(
                        image: AssetImage('assets/logo.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Another space between the widgets in the column.
                  const Spacer(),
                  // A column widget to display the version details.
                  Column(
                    children: const [
                      // Display the text "Version".
                      Text(
                        'Version',
                        style: TextStyle(color: Colors.white),
                      ),
                      // Display the actual version number.
                      Text(
                        '1.0.0',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
              ),
            ),
            // A container to define a height constraint.
            Container(
              height: 630,
            )
          ],
        ),
      ),
    );
  }
}
