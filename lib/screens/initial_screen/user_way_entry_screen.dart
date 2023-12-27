import 'dart:ui';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shopbiz_app/constants/constants.dart';
import 'package:shopbiz_app/screens/credientals/login_screen.dart';
import 'package:shopbiz_app/screens/credientals/signup_screen.dart';

class UserWayEntryScreen extends StatelessWidget {
  const UserWayEntryScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: CachedNetworkImageProvider(AppUtils.splashScreenBgImg),
          ),
        ),
        child: Container(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ///logo
                Container(
                  child: const CircleAvatar(
                    radius: 100,
                    backgroundImage:
                        AssetImage('assets/images/e_commerce_logo.png'),
                  ),
                ),

                ///
                const SizedBox(height: 20),

                ///
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome to ',
                      style: AppUtils.animationStyle(),
                    ),
                    AnimatedTextKit(
                      animatedTexts: [
                        TyperAnimatedText(
                          'Shopbiz',
                          textStyle: AppUtils.animationStyle(),
                          speed: const Duration(milliseconds: 600),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                ///
                Row(
                  children: [
                    Expanded(
                      child: MaterialButton(
                        height: 50,
                        shape: const StadiumBorder(),
                        color: Colors.blue,
                        child: const Center(child: Text('LOGIN')),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(builder: (_) {
                            return const LogInScreen();
                          }), (route) => false);
                        },
                      ),
                    ),
                    const SizedBox(width: 16), // Adjusted spacing
                    Expanded(
                      child: MaterialButton(
                        height: 50,
                        shape: const StadiumBorder(),
                        color: Colors.red,
                        child: const Center(child: Text('SIGNUP')),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(builder: (_) {
                            return const SignUpScreen();
                          }), (route) => false);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
