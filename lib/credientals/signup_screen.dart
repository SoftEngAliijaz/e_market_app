import 'package:e_market_app/admin/dashboard/admin_dashboard_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:e_market_app/constants/constants.dart';
import 'package:e_market_app/security_utils/security_utils.dart';
import 'package:e_market_app/user_side/home/home_screen.dart';
import 'package:e_market_app/widgets/account_selection.dart';
import 'package:e_market_app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();
  final TextEditingController _adminCodeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isObscurePassword = true;
  bool _isObscureRePassword = true;
  bool _isObscureAdminCode = true;
  bool _isLoading = false;
  String? _selectedUserType;
  File? _image;

  _signUpCredentials() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _rePasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Passwords do not match!"),
          ),
        );
        return;
      }

      if (_selectedUserType == 'admin' &&
          !SecurityUtils.isAdminCodeValid(_adminCodeController.text)) {
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
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        String? photoUrl;
        if (_image != null) {
          photoUrl = await _uploadImage();
        }

        await FirebaseFirestore.instance
            .collection(_selectedUserType == 'admin' ? 'admins' : 'users')
            .doc(userCredential.user!.uid)
            .set({
          'uid': userCredential.user!.uid,
          'displayName': _nameController.text,
          'email': _emailController.text,
          'photoUrl': photoUrl,
          'userType': _selectedUserType,
          'isAdmin': _selectedUserType == 'admin',
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Sign-up successful!"),
          ),
        );

        _selectedUserType == 'user'
            ? Navigator.push(context, MaterialPageRoute(builder: (_) {
                return const HomeScreen();
              }))
            : Navigator.push(context, MaterialPageRoute(builder: (_) {
                return const AdminDashBoard();
              }));
      } on FirebaseAuthException catch (e) {
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
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('user_profile_pictures')
        .child('${_emailController.text}_profile_picture.jpg');
    UploadTask uploadTask = ref.putFile(_image!);
    await uploadTask.whenComplete(() => null);
    return ref.getDownloadURL();
  }

  Future<void> _getImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
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
                                  Expanded(child: AppUtils.buildLogo(70)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        _buildProfilePicture(),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              children: [
                                CustomTextField(
                                  textEditingController: _nameController,
                                  prefixIcon: Icons.person_outline,
                                  hintText: 'Enter Name',
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Field Should Not be Empty';
                                    }
                                    return null;
                                  },
                                ),
                                CustomTextField(
                                  textEditingController: _emailController,
                                  prefixIcon: Icons.email_outlined,
                                  hintText: 'Enter Email',
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Field Should Not be Empty';
                                    } else if (!RegExp(
                                      r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$',
                                    ).hasMatch(value)) {
                                      return 'Enter a valid email address';
                                    }
                                    return null;
                                  },
                                ),
                                CustomTextField(
                                  textEditingController: _passwordController,
                                  prefixIcon: Icons.password_outlined,
                                  obscureText: _isObscurePassword,
                                  hintText: 'Enter Password',
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Field Should Not be Empty';
                                    } else if (value.length < 5) {
                                      return 'Password should be at least 5 characters';
                                    }
                                    return null;
                                  },
                                  suffixWidget: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _isObscurePassword =
                                            !_isObscurePassword;
                                      });
                                    },
                                    icon: Icon(
                                      _isObscurePassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                    ),
                                  ),
                                ),
                                CustomTextField(
                                  textEditingController: _rePasswordController,
                                  prefixIcon: Icons.password_outlined,
                                  obscureText: _isObscureRePassword,
                                  hintText: 'Re-Enter Password',
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Field Should Not be Empty';
                                    } else if (value.length < 5) {
                                      return 'Password should be at least 5 characters';
                                    } else if (value !=
                                        _passwordController.text) {
                                      return 'Passwords do not match';
                                    }
                                    return null;
                                  },
                                  suffixWidget: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _isObscureRePassword =
                                            !_isObscureRePassword;
                                      });
                                    },
                                    icon: Icon(
                                      _isObscureRePassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                    ),
                                  ),
                                ),
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
                                if (_selectedUserType == 'admin')
                                  CustomTextField(
                                    textEditingController: _adminCodeController,
                                    prefixIcon: Icons.lock_outline,
                                    hintText: 'Enter Admin Code',
                                    obscureText: _isObscureAdminCode,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Field Should Not be Empty';
                                      }
                                      return null;
                                    },
                                    suffixWidget: IconButton(
                                      icon: Icon(_isObscureAdminCode
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                      onPressed: () {
                                        setState(() {
                                          _isObscureAdminCode =
                                              !_isObscureAdminCode;
                                        });
                                      },
                                    ),
                                  ),
                                ElevatedButton(
                                  onPressed:
                                      _isLoading ? null : _signUpCredentials,
                                  child: Text(
                                      _isLoading ? 'SIGNING UP...' : 'SIGN UP'),
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
