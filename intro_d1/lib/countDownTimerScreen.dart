// Import necessary packages
import 'package:audioplayers/audioplayers.dart'; // For audio playback
import 'package:flutter/cupertino.dart'; // For Cupertino widgets
import 'package:flutter/material.dart'; // For Material widgets
import 'dart:async'; // For Timer and asynchronous functions

// Create a StatefulWidget because we'll be changing the state of the timer
class CountdownTimerPage extends StatefulWidget {
  const CountdownTimerPage({super.key}); // Constructor with optional key argument

  @override
  _CountdownTimerPageState createState() => _CountdownTimerPageState(); // Create the mutable state for this widget
}

// Define the mutable state
class _CountdownTimerPageState extends State<CountdownTimerPage> {
  Timer? _timer; // The Timer object to manage the countdown
  int _duration = 3600; // Initialize timer duration to 1 hour (3600 seconds)
  int _initSeconds = 3600; // Store initial seconds for reset function
  final AudioPlayer _audioPlayer = AudioPlayer(); // Audio player for sound

  // Clean up resources when the widget is removed
  @override
  void dispose() {
    _timer?.cancel(); // Cancel any running timers
    _audioPlayer.dispose(); // Dispose of the audio player
    super.dispose(); // Call parent class dispose method
  }

  // Function to start the timer
  void _startTimer() {
    if (_timer != null) {
      _timer!.cancel(); // Cancel any existing timers
    }
    // Create a new timer that ticks every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_duration > 0) { // Check if the timer has to continue
        setState(() {
          _duration--; // Decrement the duration by 1 second
        });
      } else { // When timer reaches zero
        _timer!.cancel(); // Cancel the timer
        await _audioPlayer.play(AssetSource('timerRing.wav')); // Play sound
      }
    });
  }

  // Function to stop the timer
  void _stopTimer() {
    if (_timer != null) {
      _timer!.cancel(); // Cancel any running timers
    }
  }

  // Function to reset the timer
  void _resetTimer() {
    if (_timer != null) {
      _timer!.cancel(); // Cancel any running timers
    }
    setState(() {
      _duration = _initSeconds; // Reset duration to initial seconds
    });
  }

  // Function to format time display
  String _formatTime(int seconds) {
    int hours = (seconds / 3600).floor(); // Calculate hours
    int minutes = ((seconds % 3600) / 60).floor(); // Calculate minutes
    int remainingSeconds = seconds % 60; // Calculate remaining seconds
    return '$hours:${minutes.toString().padLeft(2, '0')}:'
        '${remainingSeconds.toString().padLeft(2, '0')}'; // Format as hh:mm:ss
  }

  // Function to calculate the progress for CircularProgress
  double _calculateProgress() {
    return 1 - (_duration / _initSeconds); // Calculate remaining time as a fraction of total time
  }

  // Function to show a Cupertino timer picker
  void _showTimer(Widget child) {
    // Display a popup with the Cupertino timer picker
    showCupertinoModalPopup<void>(
      context: context, // Build context for locating the widget in the tree
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child, // Child is the Cupertino timer picker
        ),
      ),
    );
  }

  // Cupertino timer picker as a widget
  Widget _setTimer() {
    int hours = (_duration / 3600).floor(); // Calculate hours
    int minutes = ((_duration % 3600) / 60).floor(); // Calculate minutes
    Duration duration = Duration(hours: hours, minutes: minutes); // Create Duration object

    return CupertinoTimerPicker(
      mode: CupertinoTimerPickerMode.hm, // Show hours and minutes only
      initialTimerDuration: duration, // Set the initial duration
      onTimerDurationChanged: (Duration newDuration) {
        // Called when the user changes the timer duration
        setState(() {
          _duration = newDuration.inSeconds; // Update duration
          _initSeconds = newDuration.inSeconds; // Update initial seconds
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // The main UI build function
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Timer'), // App bar title
          centerTitle: true, // Center the title
          backgroundColor: const Color.fromRGBO(27, 56, 100, 1.0), // Background color of AppBar
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center children vertically
            children: [
              Stack(
                // Stack widget to overlay progress circle and timer text
                alignment: Alignment.center, // Center align children
                children: [
                  SizedBox(
                    // SizedBox to constrain the CircularProgressIndicator
                    height: 150,
                    width: 150,
                    child: CircularProgressIndicator(
                        value: _calculateProgress(), // Calculate the progress
                        strokeWidth: 10, // Width of the progress circle
                        color: Colors.red), // Color of the progress circle
                  ),
                  Text(
                    _formatTime(_duration), // Format time as hh:mm:ss
                    style: const TextStyle(
                      fontSize: 30, // Font size
                      fontWeight: FontWeight.bold, // Bold font
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20), // A spacer of height 20
              Row(
                // Row to place buttons horizontally
                mainAxisAlignment: MainAxisAlignment.center, // Center buttons horizontally
                children: [
                  ElevatedButton(
                    // Button to set timer
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                        const Color.fromRGBO(27, 56, 100, 1.0)), // Background color
                    onPressed: () => _showTimer(_setTimer()), // Show timer picker when pressed
                    child: const Text('Set'), // Label of the button
                  ),
                  const SizedBox(width: 20), // A spacer of width 20
                  ElevatedButton(
                    // Button to start timer
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                        const Color.fromRGBO(27, 56, 100, 1.0)), // Background color
                    onPressed: _startTimer, // Start timer when pressed
                    child: const Text('Start'), // Label of the button
                  ),
                  const SizedBox(width: 20), // A spacer of width 20
                  ElevatedButton(
                    // Button to stop timer
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                        const Color.fromRGBO(27, 56, 100, 1.0)), // Background color
                    onPressed: _stopTimer, // Stop timer when pressed
                    child: const Text('Stop'), // Label of the button
                  ),
                  const SizedBox(width: 20), // A spacer of width 20
                  ElevatedButton(
                    // Button to reset timer
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                        const Color.fromRGBO(27, 56, 100, 1.0)), // Background color
                    onPressed: _resetTimer, // Reset timer when pressed
                    child: const Text('Reset'), // Label of the button
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
