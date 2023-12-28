import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_market_app/screens/credientals/forget_password_screen.dart';
import 'package:e_market_app/screens/credientals/signup_screen.dart';
import 'package:e_market_app/screens/home/home_screen.dart';
import 'package:e_market_app/widgets/account_selection.dart';
import 'package:e_market_app/widgets/custom_button.dart';
import 'package:e_market_app/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
  bool _isLoading = false; // Add this variable to track loading state
  GoogleSignIn googleSignIn = GoogleSignIn();

  Future<void> _loginCredentials() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          _isLoading = true; // Set loading state to true when logging in
        });

        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: _emailC.text, password: _passwordC.text);

        if (userCredential.user != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .get();

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
            return const HomeScreen();
          }));
        }
      } on FirebaseAuthException catch (e) {
        Fluttertoast.showToast(msg: e.message ?? 'An error occurred');
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
      }
    }
  }

  ///signign with google
  Future<UserCredential?> _handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        return await FirebaseAuth.instance.signInWithCredential(credential);
      }
    } catch (error) {
      print(error);
    }
    return null;
  }

  Future<void> _handleGoogleSignOut() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      Navigator.push(context, MaterialPageRoute(builder: (_) {
        return LogInScreen();
      }));
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
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
                            'WELCOME TO\nE-Commerce App',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          CircleAvatar(
                            radius: 100,
                            child: Image.asset(
                              'assets/images/e_commerce_logo.png',
                            ),
                          ),
                          CustomTextField(
                            textEditingController: _emailC,
                            prefixIcon: Icons.email_outlined,
                            hintText: 'Enter Email',
                            validator: (v) {
                              if (v!.isEmpty) {
                                return 'Email should not be empty';
                              } else if (!RegExp(
                                      r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                                  .hasMatch(v)) {
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
                                return 'Password should not be empty';
                              } else if (v.length < 6) {
                                return 'Password must be at least 6 characters';
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
                          _isLoading
                              ? const CircularProgressIndicator()
                              : CustomButton(
                                  title: 'LOGIN',
                                  onPressed: _isLoading
                                      ? null
                                      : () {
                                          _loginCredentials();
                                        },
                                ),

                          ///google auth button
                          // GoogleAuthButton(
                          //   onPressed: () async {
                          //     print('signin');
                          //     await _handleGoogleSignIn();
                          //   },
                          // ),

                          Align(
                            alignment: Alignment.bottomRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) {
                                    return const ForgetPasswordScreen();
                                  }),
                                );
                              },
                              child: const Text('Forgot Password?'),
                            ),
                          ),
                          AccountSelection(
                            title: "Don't have an Account?",
                            buttonTitle: 'CREATE ACCOUNT',
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) {
                                  return const SignUpScreen();
                                }),
                              );
                            },
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
