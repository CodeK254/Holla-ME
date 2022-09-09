// ignore_for_file: use_build_context_synchronously, avoid_print

import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hollame/Constants/errors.dart';
import 'package:hollame/Models/api_model.dart';
import 'package:hollame/Screens/home.dart';
import 'package:hollame/Screens/register.dart';
import 'package:hollame/Services/user_service.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  void _loadUserInfo() async {
    print('Loading user info');
    String token = await getToken();
    if(token == '') {
      print('No token found');
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const SignUp()), (route) => false);
    } else {
      print(token);
      ApiResponse response = await userDetails();
      if(response.error == null){
        print('User info loaded');
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false);
      }
      else if(response.error == unauthorized){
        print(response.error);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const SignUp()), (route) => false);
      }
      else{
        print('An error occurred while processing');
        Fluttertoast.showToast(msg: "${response.error}");
      }
    }
  }

  @override

  void initState() {
    _loadUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height,
        maxWidth: MediaQuery.of(context).size.width,
      ),
      color: Colors.white,
      child: Center(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.4,
            maxWidth: MediaQuery.of(context).size.width * 0.6,
          ),
          decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/logo2.jpg"), fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}