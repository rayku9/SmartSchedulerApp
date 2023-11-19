// Importing required packages and screens.
import 'route.dart';
import 'package:flutter/material.dart';  // Core Flutter widgets and material design components.
import 'firebase/authentication.dart';  // Firebase authentication helper.

// A StatelessWidget for Signup screen.
class Signup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Setting up the app bar.
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(27, 56, 100, 1.0),
        shape: const RoundedRectangleBorder(
          // Defining the rounded bottom corners.
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50.0),
            bottomRight: Radius.circular(50.0),
          ),
        ),
        toolbarHeight: 150,
        flexibleSpace: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Centered logo.
            Center(
              child: Container(
                height: 85,
                width: 110,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/logo.png'), fit: BoxFit.cover),
                ),
              ),
            )
          ],
        ),
      ),
      // Setting up the body with scrollable content.
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            SizedBox(height: 50),
            // Displaying the 'SmartScheduler' text.
            const Text('SmartScheduler',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
            // Embedding the SignupForm widget with padding.
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SignupForm(),
            ),
            // Providing option to navigate to Login screen.
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: <Widget>[
                  Text('Already here  ?',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  GestureDetector(
                    onTap: () {
                      // Navigating back on tap.
                      Navigator.pop(context);
                    },
                    child: Text(' Get Logged in Now!',
                        style: TextStyle(fontSize: 20, color: Colors.blue)),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// A StatefulWidget for the signup form.
class SignupForm extends StatefulWidget {
  SignupForm({Key? key}) : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();  // Key for the form.

  String? email;  // Placeholder for email.
  String? password;  // Placeholder for password.

  bool _obscureText = false;  // To toggle password visibility.
  bool agree = false;  // To check if terms are agreed.

  final pass = new TextEditingController();  // Controller for the password field.

  @override
  Widget build(BuildContext context) {
    var border = OutlineInputBorder(  // Custom border design.
      borderRadius: BorderRadius.all(
        const Radius.circular(100.0),
      ),
    );

    var space = SizedBox(height: 10);  // A constant space of height 10.
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          // Email input field.
          TextFormField(
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.email_outlined),
                labelText: 'Email',
                border: border),
            validator: (value) {  // Validation for email.
              if (value!.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            onSaved: (val) {  // Saving the email value.
              email = val;
            },
            keyboardType: TextInputType.emailAddress,
          ),

          space,  // Spacing.

          // Password input field.
          TextFormField(
            controller: pass,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: Icon(Icons.lock_outline),
              border: border,
              suffixIcon: GestureDetector(  // Toggle for password visibility.
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),
              ),
            ),
            onSaved: (val) {  // Saving the password value.
              password = val;
            },
            obscureText: !_obscureText,  // Control for password visibility.
            validator: (value) {  // Validation for password.
              if (value!.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          space,  // Spacing.

          // Confirm password field.
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              prefixIcon: Icon(Icons.lock_outline),
              border: border,
            ),
            obscureText: true,
            validator: (value) {  // Validation for confirming password.
              if (value != pass.text) {
                return 'password not match';
              }
              return null;
            },
          ),
          space,  // Spacing.

          // Checkbox for agreeing to terms.
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Checkbox(
                  onChanged: (_) {
                    setState(() {
                      agree = !agree;
                    });
                  },
                  value: agree,
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                    'By creating account, I agree to Terms & Conditions and Privacy Policy.'),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),

          // Signup button.
          SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Block for Firebase authentication.
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  AuthenticationHelper()  // Firebase authentication.
                      .signUp(email: email!, password: password!)
                      .then((result) {
                    if (result == null) {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => RoutePage()));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          result,
                          style: TextStyle(fontSize: 16),
                        ),
                      ));
                    }
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(27, 56, 100, 1.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(24.0)))),
              child: Text('Sign Up'),
            ),
          ),
        ],
      ),
    );
  }
}
