import 'package:flutter/material.dart';
import 'package:hollame/Screens/home.dart';
import 'package:hollame/Screens/loading.dart';
import 'package:hollame/Screens/login.dart';
import 'package:hollame/Screens/register.dart';
import 'package:hollame/Screens/screens.dart';
import 'package:hollame/Screens/update_user.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (context) => const Loading(),
        "/register": (context) => const SignUp(),
        "/login": (context) => const Login(),
        "/home": (context) => const HomeScreen(),
        "/user_profile" : (context) => const UserProfile(),
        "/user_update" : (context) => const UserUpdate(),
      },
    )
  );
}