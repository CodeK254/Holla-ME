import "package:flutter/material.dart";
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hollame/Constants/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class UserBio extends StatefulWidget {
  Map data;

  UserBio({required this.data});

  @override
  State<UserBio> createState() => _UserBioState();
}

class _UserBioState extends State<UserBio> {
  void launchEmail({String? userEmail}) async {
    final url = Uri.parse("mailto:$userEmail");

    if(await canLaunchUrl(url)){
      launchEmail(userEmail: url.toString());
    }
  }

  void _callNumber(String number) async{
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);

    print(res);
  }

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
                        child: widget.data["name"] != null  && widget.data["phone"] != null ?  ListView(
                              // padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.28, vertical: MediaQuery.of(context).size.height * 0.12),
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.25,/* left: MediaQuery.of(context).size.height * 0.12*/),
                                  child: Center(
                                    child: Text(
                                      widget.data["name"],
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
                                    "+254 ${widget.data["phone"]}",
                                    style: GoogleFonts.firaSans(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                                widget.data["about"] != null ? Padding(
                                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                                  child: Text(
                                    widget.data["about"],
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
                  child: widget.data["image"] == null ? CircleAvatar(
                    radius: MediaQuery.of(context).size.height * 0.07,
                    backgroundColor: Colors.brown,
                    child: Center(
                      child: Text(
                        widget.data["name"][0],
                        style: GoogleFonts.rancho(
                          fontSize: 35,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                  :
                  CircleAvatar(
                    radius: MediaQuery.of(context).size.height * 0.07,
                    backgroundImage: NetworkImage(widget.data["image"]),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05, vertical: MediaQuery.of(context).size.height * 0.004),
            child: TextButton(
              onPressed: () {
                _callNumber("+254${widget.data["phone"]}");
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
                launchEmail();
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