import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'screens/game.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Center(
        child: Column(
          children: [
            SizedBox(
                height: 120,
                width: 120,
                child: Image.asset('assets/images/splash.png')),
            SizedBox(height: 30),
            const Text(
              'Made By Vineet Kumar',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      splashIconSize: 200,
      duration: 1000,
      backgroundColor: Color(0xFFfff550),
      nextScreen: GameScreen(),
      splashTransition: SplashTransition.fadeTransition,
    );
  }
}
