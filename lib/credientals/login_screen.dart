import 'package:e_market_app/credientals/signup_screen.dart';
import 'package:e_market_app/user_side/home/home_screen.dart';
import 'package:e_market_app/widgets/account_selection.dart';
import 'package:e_market_app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart' as toast;
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:e_market_app/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isObscureText = true;
  bool _isLoading = false;
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Form(
          key: _formKey,
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppUtils.buildLogo(100),
                sizedbox(),
                CustomTextField(
                  textEditingController: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  hintText: 'Email',
                  prefixIcon: Icons.email_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                sizedbox(),

                CustomTextField(
                  textEditingController: _passwordController,
                  obscureText: _isObscureText,
                  hintText: 'Password',
                  prefixIcon: Icons.lock_outline,
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                sizedbox(),

                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value!;
                        });
                      },
                    ),
                    Text('Remember Me'),
                  ],
                ),

                ///login button
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  child:
                      _isLoading ? CircularProgressIndicator() : Text('Login'),
                ),

                ///_forgotPassword
                TextButton(
                  onPressed: _forgotPassword,
                  child: Text('Forgot Password?'),
                ),

                sizedbox(),

                ///AccountSelection
                AccountSelection(
                  title: 'Don\'t have Account',
                  buttonTitle: 'SignUp',
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return SignUpScreen();
                    }));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// login method
  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await firebase_auth.FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        if (_rememberMe) {
          // Saved email to local storage
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('userEmail', _emailController.text);
        }

        // Navigate to home screen
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => HomeScreen()));
      } catch (error) {
        toast.Fluttertoast.showToast(msg: error.toString());
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _forgotPassword() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Forgot Password'),
          content: TextFormField(
            decoration: InputDecoration(labelText: 'Enter your email'),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                String email = _emailController.text;
                try {
                  await firebase_auth.FirebaseAuth.instance
                      .sendPasswordResetEmail(email: email);
                  toast.Fluttertoast.showToast(
                      msg: 'Password reset email sent to $email');
                } catch (error) {
                  toast.Fluttertoast.showToast(msg: error.toString());
                }
                Navigator.of(context).pop();
              },
              child: Text('Reset Password'),
            ),
          ],
        );
      },
    );
  }
}
