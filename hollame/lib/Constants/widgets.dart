// ignore_for_file: use_build_context_synchronously

import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:hollame/Services/user_service.dart';

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

class MenuItems{
  String name;
  IconData icon;

  MenuItems({required this.name, required this.icon});

  static List<MenuItems> menuItems = [
    MenuItems(name: "Settings", icon: Icons.settings),
    MenuItems(name: "Update User", icon: Icons.verified_user),
    MenuItems(name: "Sign Out", icon: Icons.logout),
  ];
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
      PopupMenuButton<dynamic>(
        onSelected: (value) {
          switch(value){
            case 0:
            break;

            case 1:
            Navigator.pushNamed(context, "/user_update");
            break;

            case 2:
            logoutUser();
            Future.delayed(const Duration(seconds: 3),(){
              Navigator.pushReplacementNamed(context, "/login");
            });
            break;
          }
        },
        itemBuilder: (context){
          return [
            PopupMenuItem(
              value: 0,
              child: Row(
                children: [
                  const Icon(Icons.settings),
                  const SizedBox(width: 5),
                  Text(
                    "Settings",
                    style: GoogleFonts.rancho(
                      fontSize: 18,
                      color: Colors.brown,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 1,
              child: Row(
                children: [
                  const Icon(Icons.update_rounded),
                  const SizedBox(width: 5),
                  Text(
                    "Update User",
                    style: GoogleFonts.rancho(
                      fontSize: 18,
                      color: Colors.brown,
                    ),
                  ),
                ],
              ),
            ),
            const PopupMenuDivider(height: 0),
            PopupMenuItem(
              value: 2,
              child: Row(
                children: [
                  const Icon(Icons.logout_outlined),
                  const SizedBox(width: 5),
                  Text(
                    "Sign Out",
                    style: GoogleFonts.rancho(
                      fontSize: 18,
                      color: Colors.brown,
                    ),
                  ),
                ],
              ),
            ),
          ];
        }
      ),
      // index != 3 ? Container()
      // : 
      // Padding(
      //   padding: const EdgeInsets.all(20),
      //   child: GestureDetector(
      //     onTap: (){
      //       Navigator.pushNamed(context, "/user_update");
      //     },
      //     child: Container(
      //       constraints: BoxConstraints(
      //         maxHeight: MediaQuery.of(context).size.height * 0.02,
      //         minWidth: MediaQuery.of(context).size.width * 0.1,
      //       ),
      //       decoration: const BoxDecoration(
      //         color: Colors.brown,
      //         boxShadow: [
      //           BoxShadow(
      //             blurRadius: 2,
      //           ),
      //         ],
      //       ),
      //       child: const Padding(
      //         padding: EdgeInsets.all(4.0),
      //         child: Text("Update"),
      //       ),
      //     ),
      //   ),
      // ),
    ],
  );
}

PopupMenuItem<MenuItems> menuItem(MenuItems item) => PopupMenuItem(
  value: item,
  child: Row(
    children: [
      Icon(item.icon),
      const SizedBox(width: 5),
      Text(item.name),
    ],
  ),
);

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

altNavigate(context, String statement, String route, String routeName) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.05),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          statement,
          style: GoogleFonts.rancho(
            fontSize: 23,
            fontWeight: FontWeight.normal,
            color: Colors.brown,
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: (){
            Navigator.pushReplacementNamed(context, "/$route");
          },
          child: Text(
            routeName,
            style: GoogleFonts.rancho(
              fontSize: 25,
              fontWeight: FontWeight.normal,
              color: Colors.teal,
            ),
          ),
        ),
      ],
    ),
  );
}