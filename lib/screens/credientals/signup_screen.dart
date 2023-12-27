import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shopbiz_app/models/auth_model/user_model.dart';
import 'package:shopbiz_app/screens/credientals/login_screen.dart';
import 'package:shopbiz_app/widgets/account_selection.dart';
import 'package:shopbiz_app/widgets/custom_button.dart';
import 'package:shopbiz_app/widgets/custom_text_field.dart';

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
  bool _isObscureText = true; // Use one variable for obscuring text
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false; // Add this variable to track loading state

  Future<void> _signUpCredentials() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordC.text != _rePassC.text) {
        Fluttertoast.showToast(msg: "Passwords do not match!");
        return;
      }

      try {
        setState(() {
          _isLoading = true; // Set loading state to true when signing up
        });

        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _emailC.text, password: _passwordC.text);

        if (userCredential.user != null) {
          UserModel userModel = UserModel(
            uid: FirebaseAuth.instance.currentUser!.uid,
            email: _emailC.text,
            displayName: _nameC.text,
          );
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userModel.uid)
              .set(userModel.toMap());
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
            return const LogInScreen();
          }));
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          Fluttertoast.showToast(
              msg: 'Email is already in use. Please sign in.');
        } else {
          Fluttertoast.showToast(msg: 'Error: ${e.message}');
        }
      } catch (e) {
        Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
      } finally {
        setState(() {
          _isLoading =
              false; // Set loading state to false when signup is complete
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
                        height: size.height * 0.99,
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
                              child: Image.asset(
                                'assets/images/e_commerce_logo.png',
                              ),
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
                            CustomButton(
                              title: _isLoading ? 'SIGNING UP...' : 'SIGN UP',
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
