// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:hollame/Constants/widgets.dart';
import 'package:hollame/Models/api_model.dart';
import 'package:hollame/Services/user_service.dart';
import 'package:image_picker/image_picker.dart';

class UserUpdate extends StatefulWidget {
  const UserUpdate({super.key});

  @override
  State<UserUpdate> createState() => _UserUpdateState();
}

class _UserUpdateState extends State<UserUpdate> {
  final ImagePicker _picker = ImagePicker();
  File? image;

  bool loading = false;

  void updateUserInfo() async {
    String? imageBits = getStringImage(image);
    ApiResponse response = await userUpdate(imageBits, _username.text, _phone.text, _email.text, _about.text , _facebook.text);

    print("Response body is: ${response.toString()}");

    if(response.error == null) {
      Navigator.pushReplacementNamed(context, "/user_profile");
    } else {
      showDialog(
        context: context, 
        builder: (context) => GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: AlertDialog(
            title: const Text("Error"),
            content: Text(
              "${response.error}",
            ),
          ),
        ),
      );
    }
  }

  void _addImage() async {
    // Pick an image
    final XFile? imageLoc = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      image = File(imageLoc!.path);
    });

    print("Image is: $image");
  }

  final TextEditingController _username = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _facebook = TextEditingController();
  final TextEditingController _about = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade100,
      appBar: myAppbar(context, 2),
      body: ListView(
        children: [
          Stack(
            children: [
              Column(
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
                      child: Container(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.2,
                          maxWidth: MediaQuery.of(context).size.width * 0.9,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.03),
                        ),
                        child: Center(
                          child: Container(
                            constraints: BoxConstraints(
                              maxHeight: MediaQuery.of(context).size.height * 0.12,
                              maxWidth: MediaQuery.of(context).size.width * 0.5,
                            ),
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/logo2.jpg"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.003, bottom: MediaQuery.of(context).size.height * 0.003),
                      child: Container(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.3,
                          maxWidth: MediaQuery.of(context).size.width * 0.9,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.03),
                        ),
                        child: ListView(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.25,/* left: MediaQuery.of(context).size.height * 0.12*/),
                                  child: Center(
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white70,
                                      ),
                                      width: MediaQuery.of(context).size.width * 0.4,
                                      child: TextFormField(
                                        controller: _username,
                                        decoration: const InputDecoration(
                                          label: Text("Username"),
                                          border: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.brown,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                                Center(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white70,
                                    ),
                                    width: MediaQuery.of(context).size.width * 0.4,
                                    child: TextFormField(
                                      controller: _phone,
                                      decoration: const InputDecoration(
                                        label: Text("Phone"),
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.brown,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white70,
                                    ),
                                    width: MediaQuery.of(context).size.width * 0.3,
                                    child: TextFormField(
                                      controller: _about,
                                      maxLines: 3,
                                      decoration: const InputDecoration(
                                        label: Text("About"),
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.brown,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ), 
                      ),
                    ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.17, left: MediaQuery.of(context).size.width * 0.35),
                child: CircleAvatar(
                  radius: MediaQuery.of(context).size.height * 0.08,
                  backgroundColor: Colors.grey[200],
                  child: CircleAvatar(
                    radius: MediaQuery.of(context).size.height * 0.07,
                    backgroundColor: Colors.brown,
                    child: image == null ? GestureDetector(
                      onTap: () {
                        _addImage();
                      },
                      child: const Center(
                        child: Icon(
                          Icons.add_a_photo,
                          color: Colors.white70,
                          size: 30,
                        ),
                      ),
                    ):
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.07),
                        image: DecorationImage(
                          image: FileImage(
                            image!,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05, vertical: MediaQuery.of(context).size.height * 0.015),
            child: TextFormField(
              style: const TextStyle(color: Colors.white),
              controller: _email,
              validator: (value) {
                if (value == "") {
                  return "Email required";
                }
              },
              decoration: myInputDecoration("Enter your email.", "Email"),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05, vertical: MediaQuery.of(context).size.height * 0.015),
            child: TextFormField(
              style: const TextStyle(color: Colors.white),
              controller: _facebook,
              validator: (value) {
                if (value == "") {
                  return "Facebook link is required.";
                }
              },
              decoration: myInputDecoration("Facebook link here", "Facebook"),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
            child: TextButton(
              onPressed: (){
                setState(() {
                  loading = !loading;
                });
                updateUserInfo();
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: Center(
                child: loading == false ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Submit",
                    style: GoogleFonts.firaSans(
                      fontSize: 22,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ):
                const Center(child: CircularProgressIndicator(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}