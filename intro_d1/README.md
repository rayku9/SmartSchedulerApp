# intro_d1

A new Flutter project.

## Getting Started
lib folder has all the Dart files, which you need to use very often

pubspec.yaml is the app configuration file, which manages the version, dependencies, and asset files

android folder contains all the generated files for Android, and ocassionally you need to touch it

ios folder contains all the generated files for iOS, and ocassionally you need to touch it
You spend most of the development time with 1 and 2. You don't need to change most of the other files.
Green arrow - Regular Run: this run the app for the first time - it takes more time and it starts from the beginning again

Lightning icon - Hot Load: this is the fastest way to re-run the app to see the changes. It is almost instant, but sometimes it cannot load all the changes such as the additional dependencies or configurations

Stop button - This is to stop the app first so that you can run it again by clicking the green arrow. It takes most time if you stop and re-run the app, but it gives you a clean version that shows the complete changes.

Four Major concepts
Import - This should be a simple concept for you. It serves the same function as Python or Java import. It brings the external libraries or dependencies.
Main method: Just like Java's main method, Dart also uses a main method to serve the starting point of the program. Each Fluter application only has 1 main method to start with.
All it does is to run this app with the class called MyApp.

For now, please remember that we need to always create a pair of classes for each single screen you want to build for your mobile app:
Page
PageState
The Page class does not do much except receiving the title, and creating the State:

https://api.flutter.dev/flutter/widgets/Icon-class.html
https://docs.flutter.dev/cookbook/navigation/navigation-basics

A wireframe is a visualization of the user interface of an app or website, which lets you plan out how your project will look before you start coding it.
Figma: https://www.figma.com/
Figma is a cloud-based design tool that allows multiple users to collaborate in real-time. It's primarily used for interface design and prototyping. With Figma, designers can create, review, and test web and mobile interfaces in a collaborative environment. Its vector tools are capable of illustrative design, making it a versatile tool for a broad range of design tasks.
Balsamiq: https://balsamiq.com/
Balsamiq is a rapid wireframing tool that helps designers, product managers, and developers visualize their ideas more clearly and quickly. It's designed to reproduce the experience of sketching on a whiteboard, but on a digital platform. With a library of drag-and-drop elements, Balsamiq is especially useful for creating low-fidelity mockups and getting stakeholder feedback in the early stages of design.
MarvelApp (MarvelApp): https://marvelapp.com/
MarvelApp is a comprehensive design and prototyping tool that allows designers to create interactive prototypes without any coding. It's not only for wireframing and prototyping but also for user testing and handoff. With MarvelApp, designers can transform their static designs into clickable prototypes and get feedback from stakeholders or conduct user testing sessions.
Proto.io (Proto Io): https://proto.io/
Proto.io is a web-based platform for creating fully interactive mobile app prototypes. It provides a wide array of functionalities, including drag-and-drop placements, user interactions, screen transitions, and touch gestures. Proto.io is used by designers to quickly create and share interactive prototypes, helping to gather feedback, iterate on designs, and bring their ideas to life.

Widgets: https://api.flutter.dev/flutter/widgets/widgets-library.html#classes
Restaurant App Design: https://www.figma.com/file/ZtACMm6nycCVSsTvRMmIpt/LunchFind-Demo?type=design&node-id=0-1&mode=design
Almost all UI design follows the same basic set of principles, so we may use web design and app design references interchangeably. However, while web design uses tags as its basic building block, Flutter uses something called a widget.
because widgets are so simple, they can be nested (putting one widget inside of another) to create very complicated UIs.

Margin refers to the amount of space between widgets that are next to each other
Padding refers to the space between a widget and its child (a widget inside of it). We can assign a margin/padding to the left, right, top, or bottom sides, or any combination of the four.

Scaffold
A scaffold is the default UI layout/configuration of Material Design used by Flutter. All other widgets should go inside this widget. It has far too many properties to cover, but we'll mention the ones that you should definitely know about. You can read the documentation for more info: https://api.flutter.dev/flutter/material/Scaffold-class.html

appBar: The main bar that sits at the top of your screen. We covered it at the beginning of this section.

backgroundColor: The main color of the app body

body: Holds the main content that sits at the center of the screen. This is where most of your information and interactivity should go.

bottomNavigationBar: Similar to the appBar, but with fewer features and is positioned at the bottom of the screen.

drawer: A special panel that you can open by swiping left or right on the screen.

floatingActionButton: A small button that sits above the rest of the app content. It's usually used for really important actions or to increase ease of use.

The app bar sits at the top of your phone screen and can hold a toolbar and other widgets. App bars are usually used to hold widgets that should stay the same across several screens or stay in place while scrolling. They are usually fixed-height, and have several main properties:

Leading: A widget that's displayed to the left of the title. This is commonly used for logos.
Title: The main widget displayed in the app bar. It's common to set this to a Text widget that describes the purpose of the screen.
Actions: A list of widgets that is displayed to the right of the title. This is commonly used for navigation buttons similar to the task bar or dock on your computer.
Flexible Space: A widget that can be moved around to any place within the app bar. You have to set its position with an instance of the flexibleSpaceBar class.
Bottom: This is a single widget that is positioned at the very bottom of the app bar. It's generally used to hold page tabs (if applicable). You must place it in an instance of the PreferredSize class to change the size.
Main Axis Alignment: Alignment in the direction that the widget grows. For Columns, this would be up and down (vertical) alignment.