import 'package:e_market_app/constants/constants.dart' as k;
import 'package:e_market_app/credientals/login_screen.dart';
import 'package:e_market_app/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart' as toast;

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> resetPassword(BuildContext context, String email) async {
    try {
      setState(() {
        _isLoading = true;
      });
      await firebase_auth.FirebaseAuth.instance
          .sendPasswordResetEmail(email: email);
      toast.Fluttertoast.showToast(
          msg: 'Password reset email sent successfully.');

      Navigator.push(context, MaterialPageRoute(builder: (_) {
        return LogInScreen();
      }));
    } catch (e) {
      toast.Fluttertoast.showToast(msg: e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading == false
          ? Center(
              child: k.AppUtils.customProgressIndicator(),
            )
          : SafeArea(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          'Forget Password',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        ///buildLogo
                        k.AppUtils.buildLogo(100),

                        ///fields
                        CustomTextField(
                          textEditingController: emailController,
                          prefixIcon: Icons.email_outlined,
                          hintText: 'Enter Email',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                        _isLoading
                            ? k.AppUtils.customProgressIndicator()
                            : ElevatedButton(
                                child: Text(_isLoading == true
                                    ? 'Sending Request...'
                                    : 'Send Request'),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    String email = emailController.text.trim();
                                    resetPassword(context, email);
                                  }
                                },
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
