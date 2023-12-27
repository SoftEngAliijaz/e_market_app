import 'package:flutter/material.dart';
import 'package:e_market_app/widgets/custom_text_field.dart';

class LogInWithPhoneNumber extends StatefulWidget {
  @override
  State<LogInWithPhoneNumber> createState() => _LogInWithPhoneNumberState();
}

class _LogInWithPhoneNumberState extends State<LogInWithPhoneNumber> {
  // Creating a global key for the form to uniquely identify and manage it
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // Creating a TextEditingController to manage the input field's text
  TextEditingController inputController = TextEditingController();

  // Building the UI for the LogInWithPhoneNumber widget
  @override
  Widget build(BuildContext context) {
    // Getting the size of the device screen
    final Size size = MediaQuery.of(context).size;

    // Building the main scaffold for the screen
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: size.height,
        width: size.width,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            // Associating the global key with the form
            key: formKey,
            child: Column(
              // Aligning child widgets in a vertical column with even spacing
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Displaying a circular avatar with a background image
                CircleAvatar(
                  radius: 100,
                  backgroundImage:
                      AssetImage('assets/images/e_commerce_logo.png'),
                ),
                // Displaying the text 'SHOPBIZ' with a specified font size
                Text(
                  'SHOPBIZ',
                  style: TextStyle(fontSize: 30),
                ),
                // Using a custom text field widget with specific properties
                CustomTextField(
                  textEditingController: inputController,
                  prefixIcon: Icons.phone_android_outlined,
                  hintText: 'Phone +92-3021232331',
                ),
                // Creating a material button with specific properties
                MaterialButton(
                  minWidth: double.infinity,
                  color: Colors.blue,
                  onPressed: () {
                    // Checking if the input field is not empty
                    if (inputController.text.isNotEmpty) {
                      // Constructing the phone number with a country code
                      final phone = '+92' + inputController.text;
                      // Invoking the loginWithPhone method from AuthServices
                      // AuthServices().loginWithPhone(context, phone);
                    }
                  },
                  // Displaying the button text with specific styling
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'LOGIN',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
