import 'package:cloud_firestore/cloud_firestore.dart' as cloud_firestore;
import 'package:e_market_app/constants/constants.dart' as k;
import 'package:e_market_app/constants/db_collections.dart' as collections;
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' as image_picker;
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;

class CurrentAdminProfileScreen extends StatefulWidget {
  const CurrentAdminProfileScreen({Key? key}) : super(key: key);

  @override
  _CurrentAdminProfileScreenState createState() =>
      _CurrentAdminProfileScreenState();
}

class _CurrentAdminProfileScreenState extends State<CurrentAdminProfileScreen> {
  String? _adminName;
  String? _adminEmail;
  String? _adminPhotoUrl;

  final picker = image_picker.ImagePicker();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchAdminData();
  }

  // Function to fetch admin data from Firestore
  Future<void> fetchAdminData() async {
    String currentUserUid =
        firebase_auth.FirebaseAuth.instance.currentUser!.uid;
    cloud_firestore.DocumentSnapshot snapshot = await cloud_firestore
        .FirebaseFirestore.instance
        .collection(collections.DatabaseCollection.adminsCollection)
        .doc(currentUserUid)
        .get();

    if (snapshot.exists) {
      setState(() {
        _adminName = snapshot['displayName'];
        _adminEmail = snapshot['email'];
        _adminPhotoUrl = snapshot['photoUrl'];
      });
    }
  }

  // Function to update admin profile
  void updateAdminProfile(BuildContext context, String currentUserUid,
      {File? newPhoto}) async {
    try {
      // Map to hold updated profile data
      Map<String, dynamic> updateData = {};

      // Update the name if provided
      if (_nameController.text.isNotEmpty) {
        updateData['displayName'] = _nameController.text;
        _adminName = _nameController.text;
      }

      // Update the email if provided
      if (_emailController.text.isNotEmpty) {
        updateData['email'] = _emailController.text;
        _adminEmail = _emailController.text;
      }

      // Upload new profile picture if provided
      if (newPhoto != null) {
        String fileName = path.basename(newPhoto.path);
        firebase_storage.Reference firebaseStorageRef = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('profile_pics/$fileName');
        firebase_storage.UploadTask uploadTask =
            firebaseStorageRef.putFile(newPhoto);
        firebase_storage.TaskSnapshot taskSnapshot =
            await uploadTask.whenComplete(() {});
        String photoUrl = await taskSnapshot.ref.getDownloadURL();
        updateData['photoUrl'] = photoUrl;
        _adminPhotoUrl = photoUrl;
      }

      // Update Firestore document with the new data
      await cloud_firestore.FirebaseFirestore.instance
          .collection(collections.DatabaseCollection.adminsCollection)
          .doc(currentUserUid)
          .update(updateData);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );

      // Update the UI with the new data
      setState(() {});

      // Close the dialog
      Navigator.of(context).pop();
    } catch (error) {
      // Show error message if update fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile: $error'),
        ),
      );
    }
  }

  ///_imageFile
  var _imageFile;

  // Function to pick an image from gallery
  Future<void> _pickImage() async {
    final pickedFile =
        await picker.pickImage(source: image_picker.ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Profile'),
      ),

      /// bottomNavigationBar
      bottomNavigationBar: SizedBox(
        height: 60,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: MaterialButton(
            color: Theme.of(context).primaryColor,
            shape: StadiumBorder(),
            onPressed: () {
              updateAdminProfile(
                  context, firebase_auth.FirebaseAuth.instance.currentUser!.uid,
                  newPhoto: _imageFile);
            },
            child: Center(
              child: Text(
                'Update/Save',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Admin profile pic
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                    radius: 100,
                    backgroundImage: _adminPhotoUrl!.isNotEmpty
                        ? NetworkImage(_adminPhotoUrl!)
                        : null,
                    child: _adminPhotoUrl!.isEmpty
                        ? Image.network(k.AppUtils.noProfileImage)
                        : null),
              ),

              ///
              k.sizedbox(),

              // Text fields for name and email
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: _adminName,
                ),
              ),

              ///
              k.sizedbox(),

              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: _adminEmail,
                ),
              ),

              // Display admin name and email
              _listTile(Icons.person, _adminName ?? 'Loading...'),
              _listTile(Icons.email, _adminEmail ?? 'Loading...'),
            ],
          ),
        ),
      ),
    );
  }

  // Function to build a _listTile widget
  Widget _listTile(IconData leadingIcon, String title) {
    return Card(
      child: ListTile(
        leading: Icon(leadingIcon),
        title: Text(title, textAlign: TextAlign.center),
      ),
    );
  }
}
