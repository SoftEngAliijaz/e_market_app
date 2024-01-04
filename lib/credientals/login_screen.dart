// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_market_app/admin/dashboard/admin_dashboard_screen.dart';
import 'package:e_market_app/credientals/signup_screen.dart';
import 'package:e_market_app/models/user_model/user_model.dart';
import 'package:e_market_app/user_side/home/home_screen.dart';
import 'package:e_market_app/widgets/account_selection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController _emailC = TextEditingController();
  final TextEditingController _passwordC = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isObscureText = true;
  bool _isLoading = false;
  String _selectedUserType = 'user'; // Add this variable to track user type

  // Log-in method
  Future<void> _loginCredentials() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          _isLoading = true;
        });

        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: _emailC.text, password: _passwordC.text);

        if (userCredential.user != null) {
          DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
              .collection(_selectedUserType == 'admin' ? 'admins' : 'users')
              .doc(userCredential.user!.uid)
              .get();

          if (userSnapshot.exists) {
            UserModel userModel = UserModel.fromMap(
              userSnapshot.data() as Map<String, dynamic>,
            );

            if (userModel.isAdmin! || _selectedUserType == 'admin') {
              /// Navigate to admin dashboard
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return AdminDashBoard();
              }));
            } else {
              /// Navigate to home screen
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return HomeScreen();
              }));
            }
          } else {
            Fluttertoast.showToast(msg: 'User data does not exist');
          }
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage = e.message ?? 'An error occurred';
        // Handle specific login errors
        if (e.code == 'user-not-found') {
          errorMessage = 'No user found for that email';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Wrong password provided';
        }
        Fluttertoast.showToast(msg: errorMessage);
      } catch (e) {
        print("error: ${e.toString()}");
        Fluttertoast.showToast(msg: e.toString());
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Radio button group for user type selection
  Widget _buildUserTypeSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Radio(
          value: 'user',
          groupValue: _selectedUserType,
          onChanged: (value) {
            setState(() {
              _selectedUserType = value.toString();
            });
          },
        ),
        const Text('User'),
        Radio(
          value: 'admin',
          groupValue: _selectedUserType,
          onChanged: (value) {
            setState(() {
              _selectedUserType = value.toString();
            });
          },
        ),
        const Text('Admin'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                    key: _formKey,
                    child: Container(
                      height: size.height * 1.0,
                      width: size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            'WELCOME To\nE-Market App',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          CircleAvatar(
                            radius: 100,
                            backgroundImage:
                                AssetImage('assets/images/e_commerce_logo.png'),
                          ),
                          TextFormField(
                            controller: _emailC,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email_outlined),
                              hintText: 'Enter Email',
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Email should not be empty';
                              } else if (!RegExp(
                                      r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                                  .hasMatch(value)) {
                                return 'Enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _passwordC,
                            obscureText: _isObscureText,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.password_outlined),
                              hintText: 'Enter Password',
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isObscureText = !_isObscureText;
                                  });
                                },
                                icon: Icon(
                                  _isObscureText
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Password should not be empty';
                              } else if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                          AccountSelection(
                            title: 'Do not have account?',
                            buttonTitle: 'SIGNUP',
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                return SignUpScreen();
                              }));
                            },
                          ),
                          _buildUserTypeSelection(),
                          ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : () {
                                    _loginCredentials();
                                  },
                            child: Text('LOGIN'),
                          ),
                        ],
                      ),
                    ),
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
