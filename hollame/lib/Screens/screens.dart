// ignore_for_file: constant_identifier_names, avoid_print, sized_box_for_whitespace

import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:hollame/Constants/widgets.dart';
import 'package:hollame/Models/api_model.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:hollame/Screens/chatscreen.dart';
import 'package:hollame/Screens/user_bio.dart';
import 'package:hollame/Services/user_service.dart';
import "package:http/http.dart" as http;

List data = [];

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {

  void getUsers() async {
    ApiResponse response = await getAllUsers();
    
    setState(() {
      data = response.data as List;
    });

    print("Data is: $data");
  }

  @override

  void initState() {
    getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index){
          return Padding(
            padding: const EdgeInsets.only(top: 2),
            child: GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => UserBio(data: data[index])));
              },
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          data[index]["image"] == null ? CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.brown,
                            child: Text(
                              data[index]["name"][0],
                              style: GoogleFonts.rancho(
                                fontSize: 25,
                                color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                            ),
                          )
                          :
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.brown,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                image: DecorationImage(
                                  image: NetworkImage(data[index]["image"]),
                                  fit: BoxFit.cover,
                                )
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            data[index]["name"],
                            style: GoogleFonts.rancho(
                              fontSize: 20,
                              color: Colors.black,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}

class MessageUsers extends StatefulWidget {
  const MessageUsers({super.key});

  @override
  State<MessageUsers> createState() => _MessageUsersState();
}

class _MessageUsersState extends State<MessageUsers> {

  void getUsers() async {
    ApiResponse response = await getAllUsers();
    
    setState(() {
      data = response.data as List;
    });

    print("Data is: $data");
  }

  @override

  void initState() {
    getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index){
          return Padding(
            padding: const EdgeInsets.only(top: 2),
            child: GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(data: data[index])));
              },
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          data[index]["image"] == null ? CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.brown,
                            child: Text(
                              data[index]["name"][0],
                              style: GoogleFonts.rancho(
                                fontSize: 25,
                                color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                            ),
                          )
                          :
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.brown,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                image: DecorationImage(
                                  image: NetworkImage(data[index]["image"]),
                                  fit: BoxFit.cover,
                                )
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            data[index]["name"],
                            style: GoogleFonts.rancho(
                              fontSize: 20,
                              color: Colors.black,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  void _callNumber(String number) async{
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);

    print(res);
  }

  Map? data = {};

  userData() async {
    ApiResponse response = await userDetails();

    setState(() {
      Map? mpdata = response.data as Map;

      data = mpdata["user"];
    });

    print(data);
  }
  @override

  void initState() {
    userData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade100,
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
                        child: data!["name"] != null  && data!["phone"] != null ?  ListView(
                              // padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.28, vertical: MediaQuery.of(context).size.height * 0.12),
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.25,/* left: MediaQuery.of(context).size.height * 0.12*/),
                                  child: Center(
                                    child: Text(
                                      data!["name"],
                                      style: GoogleFonts.firaSans(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                Center(
                                  child: Text(
                                    "+254 ${data!["phone"]}",
                                    style: GoogleFonts.firaSans(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                                data!["about"] != null ? Padding(
                                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                                  child: Text(
                                    data!["about"],
                                    style: GoogleFonts.firaSans(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),
                                )
                                :
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                                  child: Text(
                                    "loading...",
                                    style: GoogleFonts.firaSans(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            )
                            :
                            ListView(
                              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.28, vertical: MediaQuery.of(context).size.height * 0.12),
                              children: [
                                Center(
                                  child: Text(
                                    "...",
                                    style: GoogleFonts.firaSans(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                Center(
                                  child: Text(
                                    "+254 ...",
                                    style: GoogleFonts.firaSans(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.grey,
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
                  child: data!["image"] == null ? CircleAvatar(
                    radius: MediaQuery.of(context).size.height * 0.07,
                    backgroundColor: Colors.brown,
                  )
                  :
                  CircleAvatar(
                    radius: MediaQuery.of(context).size.height * 0.07,
                    backgroundImage: NetworkImage(data!["image"]),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05, vertical: MediaQuery.of(context).size.height * 0.004),
            child: TextButton(
              onPressed: () {
                _callNumber("+254${data!["phone"]}");
              }, 
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              child: myTextRow(context, Icons.call_outlined, "Call Me"),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05, vertical: MediaQuery.of(context).size.height * 0.004),
            child: TextButton(
              onPressed: () {
    
              }, 
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              child: myTextRow(context, Icons.email_outlined, "Email"),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05, vertical: MediaQuery.of(context).size.height * 0.004),
            child: TextButton(
              onPressed: () {
    
              }, 
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              child: myTextRow(context, Icons.facebook, "Facebook"),
            ),
          ),
        ],
      ),
    );
  }
}

const Body = [
  MessageUsers(),
  Icon(Icons.groups_outlined),
  Users(),
  UserProfile(),
];
