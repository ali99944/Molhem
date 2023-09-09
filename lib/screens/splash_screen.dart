
import 'package:Molhem/screens/welcome_screen.dart';
import 'package:Molhem/screens/welcome_screen_navigator.dart';
import 'package:Molhem/wrappers/authentication_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Center(
          child: Lottie.asset('assets/welcome/brain.json',
              width: 350,
              repeat: true, height: 200, reverse: true, fit: BoxFit.cover),
        ),
      ),
    );
  }
}

