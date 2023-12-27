// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shopbiz_app/constants/constants.dart';
// import 'package:shopbiz_app/screens/credientals/login_with_phone_number.dart';
// import 'package:shopbiz_app/screens/home/home_screen.dart';

// class AuthServices {
//   Future<void> loginWithPhone(BuildContext context, String phone) async {
//     FirebaseAuth _auth = FirebaseAuth.instance;
//     TextEditingController otpC = TextEditingController();

//     try {
//       await _auth.verifyPhoneNumber(
//         phoneNumber: phone,
//         verificationCompleted: (PhoneAuthCredential credential) async {
//           UserCredential result = await _auth.signInWithCredential(credential);
//           Navigator.pop(context); // Close the OTP dialog

//           User? user = result.user;
//           if (user != null) {
//             await storePhoneNumberSecurely(phone);
//             navigateTo(context, LogInWithPhoneNumber());
//           } else {
//             Fluttertoast.showToast(msg: 'User is not signed in');
//           }
//         },
//         verificationFailed: (FirebaseAuthException e) {
//           Fluttertoast.showToast(msg: e.message ?? 'Verification failed');
//         },
//         codeSent: (String verificationCode, int? token) {
//           showDialog(
//             context: context,
//             builder: (_) {
//               return AlertDialog(
//                 title: Text('Enter OTP'),
//                 content: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     TextField(
//                       controller: otpC,
//                       inputFormatters: [
//                         FilteringTextInputFormatter.digitsOnly
//                       ], // Allow only digits
//                     ),
//                   ],
//                 ),
//                 actions: [
//                   ElevatedButton(
//                     onPressed: () async {
//                       final code = otpC.text;
//                       PhoneAuthCredential credential =
//                           PhoneAuthProvider.credential(
//                         verificationId: verificationCode,
//                         smsCode: code,
//                       );

//                       UserCredential result =
//                           await _auth.signInWithCredential(credential);
//                       User? user = result.user;
//                       if (user != null) {
//                         navigateTo(context, HomeScreen());
//                         print('Success');
//                       } else {
//                         Fluttertoast.showToast(msg: 'Error signing in');
//                       }
//                     },
//                     child: Text('Verify'),
//                   )
//                 ],
//               );
//             },
//           );
//         },
//         codeAutoRetrievalTimeout: (id) => {},
//       );
//     } catch (e) {
//       Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
//     }
//   }

//   Future<void> storePhoneNumberSecurely(String phoneNumber) async {
//     // Implement the secure storage logic here
//   }
// }
