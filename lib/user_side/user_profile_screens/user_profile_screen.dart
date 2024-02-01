import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_market_app/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _pickedImage;
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data != null) {
            var user = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildProfileImage(user),
                  _buildNameField(),
                  _buildProfileCard(
                      Icons.person_outline, user['displayName'].toString()),
                  _buildProfileCard(
                      Icons.email_outlined, user['email'].toString()),
                  _buildSaveButton(user.id),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No user data found.'));
          }
        },
      ),
    );
  }

  Widget _buildProfileImage(DocumentSnapshot user) {
    return SizedBox(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: CircleAvatar(
            radius: 100,
            backgroundColor: Colors.grey,
            child: InkWell(
              onTap: () {
                showModalBottomSheetSuggestions(context);
              },
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: _pickedImage != null
                    ? CircleAvatar(
                        radius: 100,
                        backgroundImage: FileImage(_pickedImage!),
                      )
                    : user['photoUrl'] != null
                        ? CircleAvatar(
                            radius: 100,
                            backgroundImage: NetworkImage(user['photoURL']),
                          )
                        : const Icon(Icons.person, size: 100.0),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _nameController,
        decoration: InputDecoration(
          labelText: 'Name',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildProfileCard(IconData icon, String text) {
    return Column(
      children: [
        sizedbox(),
        AppUtils.userProfileCard(icon, text),
      ],
    );
  }

  Widget _buildSaveButton(String userId) {
    return Column(
      children: [
        sizedbox(),
        MaterialButton(
          color: Theme.of(context).primaryColor,
          child: const Text(
            'SAVE',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            _updateProfile(userId);
          },
        ),
      ],
    );
  }

  void showModalBottomSheetSuggestions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Pick From Camera'),
                onTap: () => _pickFromCamera(),
              ),
              ListTile(
                leading: const Icon(Icons.image_search_outlined),
                title: const Text('Pick From Gallery'),
                onTap: () => _pickFromGallery(),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickFromCamera() async {
    Navigator.pop(context);
    try {
      final XFile? selectedImage =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (selectedImage != null) {
        setState(() {
          _pickedImage = File(selectedImage.path);
        });
        Fluttertoast.showToast(msg: 'Image Selected');
      } else {
        Fluttertoast.showToast(msg: 'Image Not Selected');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> _pickFromGallery() async {
    Navigator.pop(context);
    try {
      final XFile? selectedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (selectedImage != null) {
        setState(() {
          _pickedImage = File(selectedImage.path);
        });
        Fluttertoast.showToast(msg: 'Image Selected');
      } else {
        Fluttertoast.showToast(msg: 'Image Not Selected');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<String?> uploadImageAndGetDownloadURL(File imageFile) async {
    try {
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('user_id.jpg');
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  void _updateProfile(String userId) async {
    String newName = _nameController.text.trim();

    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;

      if (newName.isNotEmpty) {
        await FirebaseAuth.instance.currentUser!.updateDisplayName(newName);
        userData['displayName'] = newName;
      }

      if (_pickedImage != null) {
        String? downloadURL = await uploadImageAndGetDownloadURL(_pickedImage!);

        if (downloadURL != null) {
          userData['photoURL'] = downloadURL;

          setState(() {
            _pickedImage = _pickedImage;
          });
        }
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update(userData);

      Fluttertoast.showToast(msg: 'Profile updated successfully');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to update profile: $e');
    }
  }
}
