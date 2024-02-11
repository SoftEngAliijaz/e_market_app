import 'package:e_market_app/admin/dashboard/admin_dashboard_screen.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart' as cloud_firestore;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:e_market_app/constants/constants.dart' as k;
import 'package:e_market_app/security_utils/security_utils.dart' as security;
import 'package:e_market_app/user_side/home/home_screen.dart';
import 'package:e_market_app/widgets/account_selection.dart';
import 'package:e_market_app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' as image_picker;
import 'dart:io';

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
  bool _isObscureText1 = true;
  bool _isObscureText2 = true;
  bool _isObscureForAdmin = true;
  bool _isLoading = false;
  String? _selectedUserType; // Add this variable to track user type
  File? _image;

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
          !security.SecurityUtils.isAdminCodeValid(_adminCodeController.text)) {
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
        firebase_auth.UserCredential userCredential = await firebase_auth
            .FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: _emailC.text,
          password: _passwordC.text,
        );

        // Additional logic for user sign-up
        String? photoUrl;
        if (_image != null) {
          photoUrl = await _uploadImage();
        }

        await cloud_firestore.FirebaseFirestore.instance
            .collection(_selectedUserType == 'admin' ? 'admins' : 'users')
            .doc(userCredential.user!.uid)
            .set({
          'uid': userCredential.user!.uid,
          'displayName': _nameC.text,
          'email': _emailC.text,
          'photoUrl': photoUrl,
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
            ? Navigator.push(context, MaterialPageRoute(builder: (_) {
                return const HomeScreen();
              }))
            : Navigator.push(context, MaterialPageRoute(builder: (_) {
                return const AdminDashBoard();
              }));

        ///FirebaseAuthException
      } on firebase_auth.FirebaseAuthException catch (e) {
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

  Future<String?> _uploadImage() async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('user_profile_pictures')
        .child('${_emailC.text}_profile_picture.jpg');
    firebase_storage.UploadTask uploadTask = ref.putFile(_image!);
    await uploadTask.whenComplete(() => null);
    return ref.getDownloadURL();
  }

  Future<void> _getImage() async {
    final image_picker.ImagePicker _picker = image_picker.ImagePicker();
    final image_picker.XFile? image =
        await _picker.pickImage(source: image_picker.ImageSource.gallery);
    setState(() {
      _image = File(image!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            child: Card(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Welcome to E-Market\nPlease Create Your Account',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Expanded(child: k.AppUtils.buildLogo(70)),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          ///select image
                          _buildProfilePicture(),

                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                children: [
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
                                    obscureText: _isObscureText1,
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
                                          _isObscureText1 = !_isObscureText1;
                                        });
                                      },
                                      icon: Icon(
                                        _isObscureText1
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                      ),
                                    ),
                                  ),
                                  CustomTextField(
                                    textEditingController: _rePassC,
                                    prefixIcon: Icons.password_outlined,
                                    obscureText: _isObscureText2,
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
                                          _isObscureText2 = !_isObscureText2;
                                        });
                                      },
                                      icon: Icon(
                                        _isObscureText2
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
                                            _selectedUserType =
                                                value.toString();
                                          });
                                        },
                                      ),
                                      const Text('User'),
                                      Radio(
                                        value: 'admin',
                                        groupValue: _selectedUserType,
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedUserType =
                                                value.toString();
                                          });
                                        },
                                      ),
                                      const Text('Admin'),
                                    ],
                                  ),
                                  // Admin code text field
                                  if (_selectedUserType == 'admin')
                                    CustomTextField(
                                      textEditingController:
                                          _adminCodeController,
                                      prefixIcon: Icons.lock_outline,
                                      hintText: 'Enter Admin Code',
                                      obscureText: _isObscureForAdmin,
                                      validator: (v) {
                                        if (v!.isEmpty) {
                                          return 'Field Should Not be Empty';
                                        }
                                        return null;
                                      },
                                      suffixWidget: IconButton(
                                        icon: Icon(_isObscureForAdmin
                                            ? Icons.visibility
                                            : Icons.visibility_off),
                                        onPressed: () {
                                          setState(() {
                                            _isObscureForAdmin =
                                                !_isObscureForAdmin;
                                          });
                                        },
                                      ),
                                    ),
                                  ElevatedButton(
                                    onPressed: _isLoading
                                        ? null
                                        : () {
                                            _signUpCredentials();
                                          },
                                    child: Text(_isLoading
                                        ? 'SIGNING UP...'
                                        : 'SIGN UP'),
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
    );
  }

  SizedBox _buildProfilePicture() {
    return SizedBox(
      child: Card(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            child: Column(
              children: [
                ListTile(
                  leading: Text(
                    '😀',
                    style: TextStyle(fontSize: 15.0),
                  ),
                  title: Center(child: Text('Select Profile Picture')),
                  trailing: Text(
                    '😀',
                    style: TextStyle(fontSize: 15.0),
                  ),
                ),
                GestureDetector(
                  onTap: _getImage,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: CircleAvatar(
                      radius: 100,
                      backgroundColor: Theme.of(context).primaryColor,
                      backgroundImage:
                          _image != null ? FileImage(_image!) : null,
                      child: _image == null
                          ? Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
