import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_market_app/constants/db_collections.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
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

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    fetchAdminData();
  }

  // Function to fetch admin data from Firestore
  Future<void> fetchAdminData() async {
    String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection(DatabaseCollection.adminsCollection)
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
  void updateAdminProfile(
      BuildContext context, String currentUserUid, String newDisplayName,
      {String? newEmail, File? newPhoto}) async {
    try {
      // Map to hold updated profile data
      Map<String, dynamic> updateData = {};

      // Update the display name
      if (newDisplayName.isNotEmpty) {
        updateData['displayName'] = newDisplayName;
        _adminName = newDisplayName;
      }

      // Update the email if provided
      if (newEmail != null && newEmail.isNotEmpty) {
        updateData['email'] = newEmail;
        _adminEmail = newEmail;
      }

      // Upload new profile picture if provided
      if (newPhoto != null) {
        String fileName = path.basename(newPhoto.path);
        Reference firebaseStorageRef =
            FirebaseStorage.instance.ref().child('profile_pics/$fileName');
        UploadTask uploadTask = firebaseStorageRef.putFile(newPhoto);
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
        String photoUrl = await taskSnapshot.ref.getDownloadURL();
        updateData['photoUrl'] = photoUrl;
        _adminPhotoUrl = photoUrl;
      }

      // Update Firestore document with the new data
      await FirebaseFirestore.instance
          .collection(DatabaseCollection.adminsCollection)
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

  dynamic _imageFile;

  // Function to pick an image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
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
      bottomNavigationBar: SizedBox(
        height: 60,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: MaterialButton(
            color: Theme.of(context).primaryColor,
            shape: StadiumBorder(),
            onPressed: () {
              updateAdminProfile(context,
                  FirebaseAuth.instance.currentUser!.uid, _adminName ?? '',
                  newEmail: _adminEmail, newPhoto: _imageFile);
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
        padding: EdgeInsets.all(10),
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
                      ? Icon(Icons.person, size: 100)
                      : null,
                ),
              ),

              // Display admin name and email
              tile(Icons.person, _adminName ?? 'Loading...'),
              tile(Icons.email, _adminEmail ?? 'Loading...'),
            ],
          ),
        ),
      ),
    );
  }

  // Function to build a tile widget
  Widget tile(IconData leadingIcon, String title) {
    return Card(
      child: ListTile(
        leading: Icon(leadingIcon),
        title: Text(title),
      ),
    );
  }
}
