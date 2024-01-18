class UserModel {
  final String? uid;
  final String? email;
  final String? displayName;
  final String? photoUrl; // Updated from photoURL
  final String? userType;
  final bool? isAdmin;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.userType,
    this.isAdmin,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl, // Updated from photoURL
      'userType': userType,
      'isAdmin': isAdmin,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      userType: map['userType'] ?? '',
      isAdmin: map['isAdmin'] ?? false,
    );
  }
}
