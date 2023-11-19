// Import necessary packages.
import 'package:intro_d1/countDownTimerScreen.dart';
import 'package:intro_d1/generateScheduleScreen.dart';
import 'package:flutter/material.dart';
import 'firebase/db.dart';

///
/// In summary, the script is used for handling the display and generation of
/// user schedule information within a Flutter application, providing an interactive
/// interface for viewing and manipulating scheduling data, and navigating to other
/// relevant pages (like a countdown timer page).
///

// Define a `StatefulWidget` named `CalendarPage`.
class CalendarPage extends StatefulWidget {
  // Constructor for `CalendarPage` class with a named parameter `key`.
  const CalendarPage({super.key});

  // Override the `createState` method to return an instance of `_CalendarPageState`.
  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

// Define a `State` class named `_CalendarPageState` for `CalendarPage`.
class _CalendarPageState extends State<CalendarPage> {
  // Declare a boolean variable `loading` and initialize it to `true`.
  // This variable keeps track of the loading state of user data.
  bool loading = true;

  // Declare a string variable `schedule` and initialize it as an empty string.
  // This variable holds the schedule information.
  String schedule = '';

  // Override the `initState` method which is called when this object is inserted into the tree.
  @override
  initState() {
    super
        .initState(); // Always call `super.initState()` at the beginning of this method.
    getLogs(); // Call `getLogs` method to fetch user data.
  }

  // Define an asynchronous method `getLogs` to fetch user data.
  getLogs() async {
    // `getUserInfo` is called and then the `value` is used to update `loading` and `schedule` state.
    getUserInfo().then((value) {
      // Use `setState` to rebuild the widget with new values.
      setState(() {
        loading = false; // Set `loading` to `false` after fetching the data.
        // If `value` is not `null`, update `schedule` with the schedule from `value`.
        if (value != null) {
          schedule = value!['schedule'];
        }
      });
    });
  }

  // Override the `build` method to describe the part of the user interface represented by this widget.
  @override
  Widget build(BuildContext context) {
    // Get the screen `height` and `width`.
    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery
        .of(context)
        .size
        .width;

    // Return a `Scaffold` which provides a top app bar, a body, and floating action buttons.
    return Scaffold(
      // The top app bar `AppBar` is created here with certain properties set.
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(27, 56, 100, 1.0),
        toolbarHeight: 100,
        flexibleSpace: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Center a `Container` that holds an image asset as its child.
            Center(
              child: Container(
                height: 85,
                width: 110,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/logo.png'),
                      fit: BoxFit.fitHeight),
                ),
              ),
            )
          ],
        ),
      ),
      // The body of the `Scaffold`.
      body: Center(
        // Use a ternary operator to check the `loading` state.
        child: loading
        // If `loading` is `true`, display a `CircularProgressIndicator`.
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [const CircularProgressIndicator()],
          ),
        )
        // If `loading` is `false`, display the `schedule` in a `ListView`.
            : Container(
          color: const Color.fromRGBO(232, 239, 236, 0.5019607843137255),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(
              top: 32,
              left: 32,
              right: 32,
            ),
            children: [
              // Display the text 'Schedule'.
              const Text(
                'Schedule',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              // Add some space.
              const SizedBox(height: 32),
              // Display the `schedule`.
              Text(schedule)
            ],
          ),
        ),
      ),
      // Define two `FloatingActionButton`s that allow generating schedule and navigating to a countdown timer.
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'Generate',
            onPressed: () {
              // Show a date and time picker when this button is pressed.
              _showDateTimePicker(context);
            },
            icon: const Icon(Icons.schedule),
            label: const Text('Generate\nSchedule',
                style: TextStyle(fontSize: 10)),
            backgroundColor: const Color.fromRGBO(27, 56, 100, 1.0),
          ),
          const SizedBox(
            height: 20,
          ),
          FloatingActionButton.extended(
            onPressed: () {
              // Navigate to `CountdownTimerPage` when this button is pressed.
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CountdownTimerPage()));
            },
            icon: const Icon(Icons.timer),
            heroTag: 'timer',
            label: const Text(
              'Just do it',
              style: TextStyle(fontSize: 10),
            ),
            backgroundColor: const Color.fromRGBO(27, 56, 100, 1.0),
          ),
        ],
      ),
    );
  }

// Define an asynchronous method to display a date and time picker dialog.
  void _showDateTimePicker(BuildContext context) async {
    // Initialize the current date and time.
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();

    // Display a dialog asynchronously.
    await showDialog(
      context: context,
      builder: (context) {
        // Create an AlertDialog.
        return AlertDialog(
          title: const Text('Select Date and Time'),
          // Use a StatefulBuilder to allow for local state changes within the dialog.
          content: StatefulBuilder(
            builder: (context, setState) {
              // Use a Column to stack content vertically.
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Create a ListTile for date selection.
                  ListTile(
                    title: const Text('Date'),
                    subtitle: Text(
                      '${selectedDate.year}-${selectedDate.month}-${selectedDate
                          .day}',
                    ),
                    onTap: () async {
                      // Show the date picker when tapped.
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2022),
                        lastDate: DateTime(2025),
                      );
                      // If a new date is picked, update the state.
                      if (pickedDate != null && pickedDate != selectedDate) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                  ),
                  // Create a ListTile for time selection.
                  ListTile(
                    title: const Text('Time'),
                    subtitle: Text('${selectedTime.format(context)}'),
                    onTap: () async {
                      // Show the time picker when tapped.
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                      );
                      // If a new time is picked, update the state.
                      if (pickedTime != null && pickedTime != selectedTime) {
                        setState(() {
                          selectedTime = pickedTime;
                        });
                      }
                    },
                  ),
                ],
              );
            },
          ),
          // Define action buttons for the dialog.
          actions: [
            // A 'Cancel' button to close the dialog without selecting.
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            // An 'OK' button to process the selected date and time.
            TextButton(
              onPressed: () {
                // Print the selected date and time.
                print('Selected Date: $selectedDate');
                print('Selected Time: ${selectedTime.format(context)}');
                // Close the dialog.
                Navigator.of(context).pop();
                // Navigate to another page using the selected date and time.
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            GenerateSchedulePage(
                                startDate:
                                '${selectedDate.year}-${selectedDate
                                    .month}-${selectedDate.day}',
                                startTime: selectedTime.format(context))))
                    .then((value) => getLogs());
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
