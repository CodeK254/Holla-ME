// ignore_for_file: sort_child_properties_last, use_build_context_synchronously, avoid_print

import 'package:hollame/Models/api_model.dart';
import 'package:hollame/Models/user_model.dart';
import 'package:hollame/Screens/home.dart';
import 'package:hollame/Services/user_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hollame/Constants/widgets.dart';
import "package:fluttertoast/fluttertoast.dart";
import "dart:io";

import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
    // Pick an image

  void pickImageFile() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = File(image!.path);
    });
  }

  final GlobalKey<FormState> _formKeyOne = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyTwo = GlobalKey<FormState>();

  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _passwordConfirm = TextEditingController();

  final PageController _controller = PageController();
  bool isLastPage = false;

  bool loading = false;

  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token!);
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false);
  }

  void _registerUser() async {
    String? imageString = getStringImage(_imageFile);
    print("Image in 64 bit code is: $imageString");
    ApiResponse response = await userRegistration(imageString!, _username.text, _phone.text, _password.text);
    print("Response is: ${response.error}");

    if(response.error == null){
      print("Error is null");
      _saveAndRedirectToHome(response.data as User);
    } else {
      print("There is an error");
      Fluttertoast.showToast(msg: "${response.error}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppbar(context, -1),
      body: ListView(
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: double.infinity,
              maxHeight: MediaQuery.of(context).size.height,
            ),
            decoration: BoxDecoration(
              color: Colors.brown[100],
            ),
            child: Stack(
              children: [
                PageView(
                  controller: _controller,
                    onPageChanged: (index){
                      setState(() {
                        isLastPage = index == 1;
                      });
                    },
                  children: [
                    Center(
                      child: Form(
                        key: _formKeyOne,
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
                            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                              child: TextFormField(
                                style: const TextStyle(color: Colors.white),
                                obscureText: true,
                                controller: _passwordConfirm,
                                validator: (value) {
                                  if (value != _password.text) {
                                    return "Passwords don`t match.";
                                  }
                                },
                                decoration: myInputDecoration("Confirm your password","Confirm Password"),
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                              child: TextButton(
                                onPressed: (){
                                  if(_formKeyOne.currentState!.validate()){
                                    _controller.jumpToPage(1);
                                  }
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                                child: Center(
                                  child: Text(
                                    "Submit",
                                    style: GoogleFonts.firaSans(
                                      fontSize: 22,
                                      color: Colors.white,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            altNavigate(context, "Already have an account?", "login", "Sign In"),
                          ],
                        ),
                      ),
                    ),
                    ListView(
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                        Stack(
                          children: [
                            Center(
                              child: _imageFile == null ? CircleAvatar(
                                radius: MediaQuery.of(context).size.width * 0.25,
                                backgroundColor: Colors.blueGrey[50],
                              )
                              :
                              CircleAvatar(
                                radius: MediaQuery.of(context).size.width * 0.25,
                                backgroundImage: FileImage(_imageFile!),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.08, left: MediaQuery.of(context).size.width * 0.38),
                                child: GestureDetector(
                                  onTap: () {
                                    pickImageFile();
                                  },
                                  child: const Icon(
                                    Icons.camera,
                                    size: 40,
                                    color: Colors.teal,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                        Form(
                          key: _formKeyTwo,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                            child: TextFormField(
                              style: const TextStyle(color: Colors.white),
                              controller: _username,
                              validator: (value) {
                                if (value == "") {
                                  return "User name is required.";
                                }
                              },
                              decoration: myInputDecoration("Enter your Username", "Username"),
                            ),
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                          child: TextButton(
                            onPressed: (){
                              if(_formKeyTwo.currentState!.validate()){
                                setState(() {
                                  loading = !loading;
                                });
                                _registerUser();
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
                              ):
                              const CircularProgressIndicator(
                                color: Colors.white
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}