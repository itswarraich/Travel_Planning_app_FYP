// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:travel_planning_fyp/Widgets/BoldText.dart';
import 'package:travel_planning_fyp/firebase_services/splash_service.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  SplashService splashScreen = SplashService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splashScreen.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              height: 190,
              width: 190,
              decoration: BoxDecoration(
                  image: const DecorationImage(
                      image: AssetImage("assets/images/6.webp")),
                  borderRadius: BorderRadius.circular(95)),
            ),
          ),
          Center(
              child: Boldtext(
            text: "Travel Services",
            size: 25,
            color: const Color.fromARGB(255, 54, 12, 206),
          ))
        ],
      ),
    );
  }
}
