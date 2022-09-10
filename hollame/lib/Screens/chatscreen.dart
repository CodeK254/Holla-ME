import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hollame/Constants/errors.dart';
import 'package:hollame/Constants/widgets.dart';
import 'package:hollame/Models/api_model.dart';
import 'package:hollame/Services/user_service.dart';

class ChatScreen extends StatefulWidget {
  Map data;

  ChatScreen({required this.data});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _message = TextEditingController();

  Map user = {};

  void getUser() async {
    ApiResponse response = await userDetails();

    if(response.error == null){
      setState(() {
        Map things = response.data as Map;

        user = things["user"];
      });
    }
  }

  void sendYourMessage(int id, message) async {
    ApiResponse response = await sendMessage(id, message);

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

  var data = [];

  Future<Object?> getMessages() async {
    ApiResponse response = await getChat(widget.data["id"]);

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
    }

    setState(() {
      data = response.data as List;
    });

    return data;
  }
  @override

  void initState(){
    getUser();
    getMessages();
    super.initState();
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
                    const SizedBox(width: 10),
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.6,
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
                  ],
                ),
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.015),
            GestureDetector(
              onTap: (){
                sendYourMessage(widget.data["id"], _message.text);
              },
              child: CircleAvatar(
                backgroundColor: Colors.brown[100],
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
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.brown,
        ),
        toolbarHeight: MediaQuery.of(context).size.height * 0.09,
        backgroundColor: Colors.white,
        elevation: 1,
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(3.0),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.brown,
                  size: 15,
                ),
              ),
              widget.data["image"] == null ? CircleAvatar(
                radius: 15,
                backgroundColor: Colors.brown,
                child: Text(
                  widget.data["name"][0],
                  style: GoogleFonts.rancho(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              )
              :
              CircleAvatar(
                radius: 15,
                backgroundColor: Colors.brown,
                backgroundImage: NetworkImage(
                  widget.data["image"],
                ),
              ),
            ],
          ),
        ),
        title: Text(
          widget.data["name"],
          style: GoogleFonts.rancho(
            fontSize: 25,
            fontWeight: FontWeight.w500,
            color: Colors.brown,
          ),
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context){
              return [
                
              ];
            }
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.03,
              maxWidth: MediaQuery.of(context).size.width,
            ),
            decoration: BoxDecoration(
              color: Colors.brown[100],
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  widget.data["about"],
                  style: GoogleFonts.rancho(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: getMessages(),
              builder: (context, snapshot) {
                if(snapshot.hasError){
                  Fluttertoast.showToast(msg: somethingwentwrong);
                }

                if(snapshot.hasData){
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.brown,
                      backgroundColor: Colors.transparent,
                    ),
                  );
                }
                else{
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Align(
                        alignment: data[index]["user"]["id"] == user["id"] ? Alignment.topRight : Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.85,
                            ),
                            decoration: BoxDecoration(
                              color: data[index]["user"]["id"] == user["id"] ? Colors.brown[400] : Colors.teal,
                              borderRadius: data[index]["user"]["id"] == user["id"] ? const BorderRadius.only(topLeft: Radius.circular(7), bottomLeft: Radius.circular(7)) : const BorderRadius.only(topRight: Radius.circular(7), bottomRight: Radius.circular(7)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      CircleAvatar(
                                        radius: 12,
                                        child: Container(
                                          decoration: data[index]["user"]["image"] == null ? BoxDecoration(
                                            color: Colors.brown,
                                            borderRadius: BorderRadius.circular(12),
                                          )
                                          :
                                          BoxDecoration(
                                            color: Colors.brown,
                                            borderRadius: BorderRadius.circular(12),
                                            image: DecorationImage(
                                              image: NetworkImage(data[index]["user"]["image"]),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.1),
                                        child: Text(
                                          data[index]["user"]["name"],
                                          style: GoogleFonts.rancho(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(height: 0, color: Colors.brown),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                  child: Text(
                                    data[index]["message"],
                                    style: GoogleFonts.rancho(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              }
            )
          ),
          messageInput(),
        ],
      ),
    );
  }
}