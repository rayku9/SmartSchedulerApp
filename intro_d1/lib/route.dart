// Importing required packages and screens
import 'package:intro_d1/calendarScreen.dart';  // Calendar screen
import 'homeScreen.dart';  // Home screen
import 'package:flutter/material.dart';  // Core Flutter widgets and material design components

// The RoutePage widget is primarily a container for a BottomNavigationBar, which lets the
// user toggle between the HomePage and CalendarPage using the bottom navigation bar.

// A StatefulWidget class named 'RoutePage', to allow interaction and state changes
class RoutePage extends StatefulWidget {
  const RoutePage({Key? key}) : super(key: key);  // Constructor accepting optional 'key'

  @override
  _RoutePageState createState() => _RoutePageState();  // Creates the mutable state for this widget
}

// Corresponding state class for 'RoutePage'
class _RoutePageState extends State<RoutePage> {
  // A variable to keep track of the currently selected tab
  int _selectedIndex = 0;

  // Define a static TextStyle to be used later
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  // A static list to hold the different widgets/screens corresponding to the bottom navigation bar options
  static List<Widget>? _widgetOptions;

  // initState is a lifecycle method that's called when this widget is inserted into the tree
  @override
  void initState() {
    super.initState();
    // Initializing the list with two screens - Home and Calendar
    _widgetOptions = [
      const HomePage(),
      const CalendarPage(),
    ];
  }

  // A method to update the currently selected tab index
  void _onItemTapped(int index) {
    // Using 'setState' to trigger a rebuild of the widget with the new index value
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Commented out appBar code. Uncomment to use an app bar with the specified title.
      // appBar: AppBar(
      //   title: const Text('BottomNavigationBar Sample'),
      // ),
      // The body of the scaffold displays the widget from the _widgetOptions list that corresponds to the currently selected tab
      body: Center(
        child: _widgetOptions!.elementAt(_selectedIndex),
      ),
      // A bottom navigation bar with two items - Home and Calendar
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),  // Icon for the Home tab
            label: 'Home',  // Label for the Home tab
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),  // Icon for the Calendar tab
            label: 'Calendar',  // Label for the Calendar tab
          ),
        ],
        // The index of the currently selected tab
        currentIndex: _selectedIndex,
        // Color for the selected tab
        selectedItemColor: Color.fromRGBO(23, 107, 135, 1.0),
        // Callback method when a tab is tapped
        onTap: _onItemTapped,
      ),
    );
  }
}