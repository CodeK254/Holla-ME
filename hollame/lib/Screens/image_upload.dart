// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:hollame/Models/api_model.dart';
import 'package:hollame/Services/user_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class ImageUpload extends StatefulWidget {
  Map data;

  ImageUpload({required this.data});

  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  final TextEditingController _message = TextEditingController();

  File? imageFile;
  final ImagePicker _picker = ImagePicker();

  uploadImage() async {
    final XFile? imagePath = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      imageFile = File(imagePath!.path);
    });

    print("Image is: $imageFile");
  }

  sendYourMessage(int id, message) async {
    String? image = getStringImage(imageFile);
    ApiResponse response = await sendMessage(image, id, message);

    if(response.error != null) {
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
    } else {
      setState(() {
        _message.text = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    messageInput() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
                maxHeight: MediaQuery.of(context).size.height * 0.08,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.brown[100],
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 1,
                      color: Colors.black,
                    )
                  ]
                ),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.emoji_emotions_outlined, color: Colors.brown),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.55,
                        maxHeight: MediaQuery.of(context).size.height * 0.07,
                      ),
                      child: TextField(
                        controller: _message,
                        decoration: InputDecoration(
                          hintText: "Message",
                          hintStyle: GoogleFonts.firaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          uploadImage();
                        },
                        child: const Icon(
                          Icons.attach_file, 
                          color: Colors.brown
                        )
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.015),
            GestureDetector(
              onTap: () async {
                await sendYourMessage(widget.data["id"], _message.text);
                Navigator.pop(context);
              },
              child: CircleAvatar(
                backgroundColor: Colors.brown,
                radius: MediaQuery.of(context).size.width * 0.07,
                child: _message.text == "" ? const Center(
                  child: Icon(
                    Icons.mic,
                    color: Colors.white,
                    size: 25,
                  ),
                )
                :
                const Center(
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Scaffold(
      body: Stack(
        children: [
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
              maxWidth: MediaQuery.of(context).size.width,
            ),
            decoration: imageFile == null ? const BoxDecoration(
              color: Colors.black,
            ):
            BoxDecoration(
              image: DecorationImage(
                image: FileImage(imageFile!),
                fit: BoxFit.cover,
              )
            )
          ),
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.9),
            child: messageInput(),
          ),
        ],
      ),
    );
  }
}