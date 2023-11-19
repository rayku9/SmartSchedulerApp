// Import necessary Flutter packages
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// Import Firebase functionality for database operations
import 'firebase/db.dart';

// Define a new widget called AddTaskPage
class AddTaskPage extends StatefulWidget {
  // Constructor for AddTaskPage, taking an optional key argument
  const AddTaskPage({Key? key}) : super(key: key);

  // Create and return the mutable state for this widget
  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

// Define the mutable state for AddTaskPage
class _AddTaskPageState extends State<AddTaskPage> {
  // Define controllers for various text fields to capture user input
  final _typeController = TextEditingController();
  final _taskNameController = TextEditingController();
  final _dueDateController = TextEditingController();
  final _frequencyController = TextEditingController();
  final _timePerDateController = TextEditingController();
  // Define a boolean to control the visibility of the calendar widget
  bool _showCalendar = false;

  // Initialize the widget
  @override
  void initState() {
    super.initState();
    // Nothing special is done in this method for now
  }

  // Define a method to update the user's task information in Firebase
  updateInfo() {
    // Unfocus any active text field to hide the keyboard
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    // Create a map (dictionary) with all the task details
    Map<String, dynamic> taskInfo = {
      'type': _typeController.text.trim(),
      'due_date': _dueDateController.text.trim(),
      'task_name': _taskNameController.text.trim(),
      'frequency': _frequencyController.text.trim(),
      'time_per_day': _timePerDateController.text.trim()
    };

    // Display a loading spinner
    buildLoading();
    // Update Firebase with the new task info, then show a confirmation message
    editUserInfo({_taskNameController.text.trim(): taskInfo}).then((value) {
      Navigator.of(context).pop();
      snapBarBuilder('Task added');
    });
  }

  // Define a method to show a loading spinner
  buildLoading() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          );
        });
  }

  // Define a method to show a confirmation message (SnackBar) at the bottom of the screen
  snapBarBuilder(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Define the visual elements and layout of the widget
  @override
  Widget build(BuildContext context) {
    // Retrieve the screen width and height for layout calculations
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // Define and return the main scaffold (basic visual layout) of the widget
    return Scaffold(
      // Define the top bar (AppBar) of the widget
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromRGBO(27, 56, 100, 1.0),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50.0),
              bottomRight: Radius.circular(50.0),
            ),
          ),
          toolbarHeight: 100,
          // Define the contents inside the AppBar
          flexibleSpace: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  height: 85,
                  width: 110,
                  // Display a logo inside the AppBar
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
        // Define the main content of the widget
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Display a title for the page
                const Text(
                  "Add Task",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(100, 204, 197, 1.0)),
                ),
                // Display a separator line below the title
                Container(
                  height: 3,
                  color: const Color.fromRGBO(80, 80, 74, 1.0),
                ),
                // Input field for the task name
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: 'Name',
                        hintText: "Name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                    controller: _taskNameController,
                  ),
                ),
                // Input field and calendar button for task due date
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: TextField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              labelText: 'Due Date',
                              hintText: "Due Date",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          controller: _dueDateController,
                        ),
                      ),
                      // Button to toggle the visibility of the calendar widget
                      Expanded(
                          child: IconButton(
                            icon: Icon(Icons.calendar_month),
                            onPressed: () {
                              setState(() {
                                _showCalendar = !_showCalendar;
                              });
                            },
                          ))
                    ],
                  ),
                ),
                // If _showCalendar is true, display the calendar widget
                _showCalendar
                    ? SizedBox(
                  height: 100,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: DateTime.now(),
                    onDateTimeChanged: (DateTime newDateTime) {
                      _dueDateController.text =
                          newDateTime.toString().substring(0, 10);
                    },
                  ),
                )
                    : SizedBox(),
                // Input field for the task type
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        label: const Text('Type'),
                        hintText: 'Type',
                        counterText: '',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                    controller: _typeController,
                  ),
                ),
                // Input field for the task frequency
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        label: const Text('Frequency'),
                        hintText: 'Frequency',
                        counterText: '',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                    controller: _frequencyController,
                  ),
                ),
                // Input field for time spent per day on the task
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        label: const Text('Time per day'),
                        hintText: 'Time per day',
                        counterText: '',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                    controller: _timePerDateController,
                  ),
                ),
                // Button to add the task (and trigger the updateInfo method)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: ElevatedButton(
                      onPressed: updateInfo,
                      child: Text('Add Task'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                          const Color.fromRGBO(27, 56, 100, 1.0))),
                )
              ],
            ),
          ),
        ));
  }
}
