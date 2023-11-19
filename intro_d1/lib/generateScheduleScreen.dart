// Importing necessary packages for the application
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';  // Importing ChatGPT SDK for interaction with OpenAI's GPT model.
import 'package:flutter/material.dart';            // Importing Flutter's main widget library.
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Package to use environment variables stored in a .env file.

// Importing functionalities related to Firebase database operations.
import 'firebase/db.dart';

// StatefulWidget because the state/content of this page can change over time.
class GenerateSchedulePage extends StatefulWidget {
  // Taking the start date and start time as input parameters for this widget.
  final String startDate;
  final String startTime;

  // Constructor for the class, setting the values of startDate and startTime.
  const GenerateSchedulePage({
    super.key,
    required this.startDate,
    required this.startTime,
  });

  // Overriding the createState method to return a new instance of the associated state class.
  @override
  State<StatefulWidget> createState() {
    return _GenerateSchedulePageState();
  }
}

// The state class associated with GenerateSchedulePage. This contains the logic and mutable state.
class _GenerateSchedulePageState extends State<GenerateSchedulePage> {
  // Creating an instance of the OpenAI SDK.
  late final OpenAI _openAI;
  // A boolean to check whether data is still loading or not.
  bool _isLoading = true;

  // Placeholder to hold the suggestions for the schedule from ChatGPT.
  String suggestions = '';

  // When the widget is initialized, this method is called.
  @override
  void initState() {
    super.initState(); // Call to the parent class' initState.

    // Initializing the OpenAI SDK.
    _openAI = OpenAI.instance.build(
      token: dotenv.env['OPENAI_API_KEY'],  // Fetching the API key from the .env file.
      baseOption: HttpSetup(
        receiveTimeout: const Duration(seconds: 30), // Set a timeout for the API response.
      ),
    );

    // Send an initial message to ChatGPT to request schedule suggestions.
    _handleInitialMessage();
  }

  // Asynchronous method to send a message to ChatGPT and get schedule suggestions.
  Future<void> _handleInitialMessage() async {
    // Fetching user's tasks (or info) from the Firebase database.
    getUserInfo().then((value) async {
      // Constructing the message prompt for ChatGPT.
      String prompt =
      """I need help creating a week schedule. Here are the tasks that I want to schedule: $value.
      The schedule starts ${widget.startDate} and the time starts at ${widget.startTime},
      Create a schedule that contains the date for me based on these tasks. Please pay attention to the
      due date and do not add the task to the schedule when the due date passes""";

      // Setting up the request to be sent to ChatGPT.
      final request = ChatCompleteText(
        messages: [
          Messages(
              role: Role.user, content: "content",name: "get_current_weather")
        ],
        maxToken: 1500,
        model: GptTurbo0631Model(),
      );

      // Making the request to ChatGPT.
      final response = await _openAI.onChatCompletion(request: request);

      // Once we get the response, update the UI.
      setState(() {
        //suggestions = response!.choices.first.message.content.trim().replaceAll('"', '');
        response!.choices.first.message!.content.trim().replaceAll('"', '');
        _isLoading = false; // Since we got our data, set loading to false.
      });
    });
  }

  // Method to save the fetched schedule to the Firebase database.
  void saveSchedule() {
    // Show the user a loading dialog.
    buildLoading();

    // Edit the user's information in the database.
    editUserInfo({'schedule': suggestions}).then((value) {
      // Once the data is saved, close the dialog and show a confirmation message.
      Navigator.of(context).pop();
      snapBarBuilder('Schedule was saved');
    });
  }

  // Method to show a loading dialog to the user.
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

  // Method to display a snackbar message.
  snapBarBuilder(String message) {
    final snackBar = SnackBar(content: Text(message));

    // Showing the snackbar message.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // The main method where the UI of the widget is built.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Setting up the app bar.
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop(); // Action to return to the previous screen.
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Generate Schedule',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromRGBO(27, 56, 100, 1.0),
        elevation: 0,
      ),
      // The main body of the widget.
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: !_isLoading
            ? ListView(children: [SizedBox(height: 10), Text(suggestions)]) // If not loading, show the suggestions.
            : Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            child: const CircularProgressIndicator(), // Else, show a loading spinner.
          ),
        ),
      ),
      // A floating action button to save the schedule.
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(116, 155, 194, 1),
        child: const Icon(Icons.save),
        onPressed: saveSchedule,
      ),
    );
  }
}
