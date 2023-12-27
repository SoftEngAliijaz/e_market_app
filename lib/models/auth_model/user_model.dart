class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String?
      photoURL; // It's optional in case the UserModel doesn't have a photo.

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoURL,
  });

  // Create a method to convert the UserModel object to a map for Firestore.
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
    };
  }

  // Create a factory method to create a UserModel object from Firestore data.
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      displayName: map['displayName'],
      photoURL: map['photoURL'],
    );
  }
}
