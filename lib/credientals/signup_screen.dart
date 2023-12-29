import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_market_app/admin/dashboard/admin_dashboard_screen.dart';
import 'package:e_market_app/constants/constants.dart';
import 'package:e_market_app/security_utils/security_utils.dart';
import 'package:e_market_app/user_side/home/home_screen.dart';
import 'package:e_market_app/widgets/account_selection.dart';
import 'package:e_market_app/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameC = TextEditingController();
  final TextEditingController _emailC = TextEditingController();
  final TextEditingController _passwordC = TextEditingController();
  final TextEditingController _rePassC = TextEditingController();
  final TextEditingController _adminCodeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isObscureText = true;
  bool _isLoading = false;
  String? _selectedUserType; // Add this variable to track user type

  // Sign-up method
  _signUpCredentials() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordC.text != _rePassC.text) {
        // Passwords do not match
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Passwords do not match!"),
          ),
        );
        return;
      }

      if (_selectedUserType == 'admin' &&
          !SecurityUtils.isAdminCodeValid(_adminCodeController.text)) {
        // Admin code is not valid
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Invalid admin code!"),
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        // Use Firebase Authentication for sign-up
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailC.text,
          password: _passwordC.text,
        );

        // Additional logic for user sign-up
        await FirebaseFirestore.instance
            .collection(_selectedUserType == 'admin'
                ? 'admins'
                : 'users') // Use 'admins' collection for admins and 'users' collection for regular users
            .doc(userCredential.user!.uid)
            .set({
          'uid': userCredential.user!.uid,
          'displayName': _nameC.text,
          'email': _emailC.text,
          'photoUrl': userCredential.user!.photoURL,
          'userType': _selectedUserType,
          'isAdmin': _selectedUserType == 'admin',
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Sign-up successful!"),
          ),
        );

        ///setting route for user and admin after signup
        ///directly to their desired screens
        _selectedUserType == 'user'
            ? navigateTo(context, HomeScreen())
            : navigateTo(context, const AdminDashBoard());

        ///FirebaseAuthException
      } on FirebaseAuthException catch (e) {
        // Handle sign-up errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${e.message}"),
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
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
                    child: SingleChildScrollView(
                      child: Container(
                        height: size.height * 1.0,
                        width: size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text(
                              'WELCOME TO\nE-Commerce App\nCreate Your Account',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            CircleAvatar(
                              radius: 100,
                              backgroundImage: AssetImage(
                                  'assets/images/e_commerce_logo.png'),
                            ),
                            CustomTextField(
                              textEditingController: _nameC,
                              prefixIcon: Icons.person_outline,
                              hintText: 'Enter Name',
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return 'Field Should Not be Empty';
                                }
                                return null;
                              },
                            ),
                            CustomTextField(
                              textEditingController: _emailC,
                              prefixIcon: Icons.email_outlined,
                              hintText: 'Enter Email',
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return 'Field Should Not be Empty';
                                } else if (!RegExp(
                                  r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$',
                                ).hasMatch(v)) {
                                  return 'Enter a valid email address';
                                }
                                return null;
                              },
                            ),
                            CustomTextField(
                              textEditingController: _passwordC,
                              prefixIcon: Icons.password_outlined,
                              obscureText: _isObscureText,
                              hintText: 'Enter Password',
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return 'Field Should Not be Empty';
                                } else if (v.length < 5) {
                                  return 'Invalid Length';
                                }
                                return null;
                              },
                              suffixWidget: IconButton(
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
                            CustomTextField(
                              textEditingController: _rePassC,
                              prefixIcon: Icons.password_outlined,
                              obscureText: _isObscureText,
                              hintText: 'Re-Enter Password',
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return 'Field Should Not be Empty';
                                } else if (v.length < 5) {
                                  return 'Invalid Length';
                                }
                                return null;
                              },
                              suffixWidget: IconButton(
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
                            // Radio buttons for user type selection
                            Row(
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
                            ),
                            // Admin code text field
                            if (_selectedUserType == 'admin')
                              CustomTextField(
                                textEditingController: _adminCodeController,
                                prefixIcon: Icons.lock_outline,
                                hintText: 'Enter Admin Code',
                                validator: (v) {
                                  if (v!.isEmpty) {
                                    return 'Field Should Not be Empty';
                                  }
                                  return null;
                                },
                              ),
                            ElevatedButton(
                              child: Text(
                                  _isLoading ? 'SIGNING UP...' : 'SIGN UP'),
                              onPressed: _isLoading
                                  ? null
                                  : () {
                                      _signUpCredentials();
                                    },
                            ),
                            AccountSelection(
                              title: 'Already have an account?',
                              buttonTitle: 'LOGIN',
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
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
