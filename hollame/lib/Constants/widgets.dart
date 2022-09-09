import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';

InputDecoration myInputDecoration(String? hint, String? label){
  return InputDecoration(
    hintText: hint,
    hintStyle: GoogleFonts.rancho(
      fontSize: 18,
      letterSpacing: 1.2,
      color: Colors.grey,
    ),
    label: Text(
      label!,
      style: GoogleFonts.firaSans(
        fontSize: 15,
        letterSpacing: 1.2,
        color: Colors.white,
      ),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(2),
      borderSide: const BorderSide(
        width: 2,
        color: Colors.white,
      )
    ),
  );
}

AppBar myAppbar(BuildContext context, int? index) {
  return AppBar(
    elevation: 1,
    backgroundColor: Colors.white,
    toolbarHeight: MediaQuery.of(context).size.height * 0.09,
    iconTheme: const IconThemeData(color: Colors.brown),
    title: Row(
      children: [
        Text(
          "HollaMe-",
          style: GoogleFonts.firaSans(
            fontSize: 30,
            color: Colors.brown,
            letterSpacing: 1.5,
          ),
        ),
        const Icon(
          Icons.phonelink_ring_outlined,
          color: Colors.brown,
        ),
      ],
    ),
    actions: [
      index != 3 ? Container()
      : 
      Padding(
        padding: const EdgeInsets.all(20),
        child: GestureDetector(
          onTap: (){
            Navigator.pushNamed(context, "/user_update");
          },
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.02,
              minWidth: MediaQuery.of(context).size.width * 0.1,
            ),
            decoration: const BoxDecoration(
              color: Colors.brown,
              boxShadow: [
                BoxShadow(
                  blurRadius: 2,
                ),
              ],
            ),
            child: const Padding(
              padding: EdgeInsets.all(4.0),
              child: Text("Update"),
            ),
          ),
        ),
      ),
    ],
  );
}

Row myTextRow(BuildContext context, IconData? icon, String label) {
  return Row(
    children: [
      Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(
          icon,
          color: Colors.black,
          size: 30,
        ),
      ),
      SizedBox(width: MediaQuery.of(context).size.width * 0.2),
      Text(
        label,
        style: GoogleFonts.firaSans(
          fontSize: 18,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}
