import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:live_score_app/sign_in_screen.dart';

import 'home_screen.dart';

class FootballLiveScoreApp extends StatefulWidget {
  const FootballLiveScoreApp({super.key});

  @override
  State<FootballLiveScoreApp> createState() => _FootballLiveScoreAppState();
}

class _FootballLiveScoreAppState extends State<FootballLiveScoreApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.hasData) {
              return const HomeScreen();
            } else {
              return SignInScreen();
            }
          }
      ),
    );
  }
}