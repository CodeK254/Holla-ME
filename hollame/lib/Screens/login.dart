// ignore_for_file: use_build_context_synchronously

import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:hollame/Constants/widgets.dart';
import 'package:hollame/Models/api_model.dart';
import 'package:hollame/Models/user_model.dart';
import 'package:hollame/Screens/home.dart';
import 'package:hollame/Services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool loading = false;

  final TextEditingController _phone = TextEditingController();
  final TextEditingController _password = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token!);
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false);
  }

  void _loginUser() async {
    ApiResponse response = await userLogin(_phone.text, _password.text);

    if(response.error == null){
      _saveAndRedirectToHome(response.data as User);
    } else {
      setState(() {
        loading = !loading;
      });
      showDialog(
        context: context, 
        builder: (context){
          return AlertDialog(
            title: const Text("Error"),
            contentPadding: const EdgeInsets.all(10),
            content: Text(
              response.error as String,
              style: GoogleFonts.rancho(
                fontSize: 20,
                color: Colors.brown,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context), 
                child: const Text("OK")
              )
            ],
          );
        }
      );
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: myAppbar(context, 0),
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: MediaQuery.of(context).size.width * 0.2),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  controller: _phone,
                  validator: (value) {
                    if (value == "") {
                      return "Phone number required.";
                    }
                  },
                  decoration: myInputDecoration("Enter your phone number", "Phone"),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                child: TextFormField(
                  style: const TextStyle(color: Colors.white),
                  obscureText: true,
                  controller: _password,
                  validator: (value) {
                    if (value == "") {
                      return "Password field is required.";
                    }
                  },
                  decoration: myInputDecoration("Enter your password","Password"),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                child: TextButton(
                  onPressed: (){
                    if(_formKey.currentState!.validate()){
                      setState(() {
                        loading = !loading;
                      });
                      _loginUser();
                    }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: Center(
                    child: loading == false ? Text(
                      "Submit",
                      style: GoogleFonts.firaSans(
                        fontSize: 22,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ) :
                    const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  ),
                ),
              ),
              altNavigate(context, "Dont have an account?", "register", "Sign Up"),
            ],
          ),
        ),
      ),
    );
  }
}