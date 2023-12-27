import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopbiz_app/constants/constants.dart';

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
            return Column(
              children: [
                SizedBox(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: CircleAvatar(
                        radius: 100,
                        backgroundColor: Colors.grey,
                        child: InkWell(
                          onTap: () => showModalBottomSheetSuggestions(context),
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            child: _pickedImage != null
                                ? CircleAvatar(
                                    radius: 100,
                                    backgroundImage: FileImage(_pickedImage!),
                                  )
                                : user['photoURL'] != null
                                    ? CircleAvatar(
                                        radius: 100,
                                        backgroundImage:
                                            NetworkImage(user['photoURL']),
                                      )
                                    : const Icon(Icons.person, size: 80),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                sizedbox(),

                ///profile cards
                AppUtils.profileCard(
                    Icons.person_outline, user['displayName'].toString()),

                sizedbox(),

                AppUtils.profileCard(
                    Icons.email_outlined, user['email'].toString()),

                sizedbox(),

                ///save button
                MaterialButton(
                  color: Theme.of(context).primaryColor,
                  child: const Text(
                    'SAVE',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    _updateProfile(user.id);
                  },
                ),
              ],
            );
          } else {
            return const Center(child: Text('No user data found.'));
          }
        },
      ),
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

  ///
  ///
  Future<String?> uploadImageAndGetDownloadURL(File imageFile) async {
    try {
      /// Upload the image to Firebase Storage and get the download URL using Firebase Storage:
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('user_id.jpg');
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      // For simplicity, let's assume we have the downloadURL (replace this with your actual logic)
      // String downloadURL = 'https://example.com/path/to/downloaded/image.jpg';

      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  void _updateProfile(String userId) async {
    String newName = _nameController.text.trim();

    try {
      // Fetch current user data
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      // Get current user data
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;

      // Update display name if it's not empty
      if (newName.isNotEmpty) {
        await FirebaseAuth.instance.currentUser!.updateDisplayName(newName);
        userData['displayName'] = newName;
      }

      // Upload and update profile image if it's selected
      if (_pickedImage != null) {
        String? downloadURL = await uploadImageAndGetDownloadURL(_pickedImage!);

        if (downloadURL != null) {
          // Update 'photoURL' in Firestore with the download URL
          userData['photoURL'] = downloadURL;

          // Update the state to reflect the new picked image
          setState(() {
            _pickedImage = _pickedImage;
          });
        }
      }

      // Update Firestore document with the new user data
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
