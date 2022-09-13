import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hollame/Constants/widgets.dart';
import 'package:hollame/Screens/screens.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      backgroundColor: Colors.white,
      appBar: myAppbar(context, currentIndex), 
      body: Body[currentIndex],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: Colors.brown.shade100,
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ), 
        child: NavigationBar(
          elevation: 2,
          height: 60,
          backgroundColor: Colors.white,
          selectedIndex: currentIndex,
          onDestinationSelected: (value) {
            setState(() {
              currentIndex = value;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(
                Icons.email_outlined,
              ), 
              label: "Messages",
            ),
            NavigationDestination(
              icon: Icon(
                Icons.groups_outlined,
              ), 
              label: "Groups",
            ),
            NavigationDestination(
              icon: Icon(
                Icons.search_outlined,
              ), 
              label: "Find Friends",
            ),
            NavigationDestination(
              icon: Icon(
                Icons.person_outlined,
              ), 
              label: "User Profiles",
            ),
          ],
        ),
      ),
    );
  }
}