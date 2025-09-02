// ignore_for_file: file_names

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:travel_planning_fyp/UIScreens/HomeScreen.dart';
import 'package:travel_planning_fyp/UIScreens/MyFavScreen.dart';
import 'package:travel_planning_fyp/UIScreens/MyPackageScreen.dart';

class Allbottom extends StatefulWidget {
  final int initialIndex;
  const Allbottom({super.key, this.initialIndex = 0});

  @override
  State<Allbottom> createState() => _AllbottomState();
}

class _AllbottomState extends State<Allbottom> {
  final bottomNavigationKey = GlobalKey<CurvedNavigationBarState>();
  int index = 0;
  List<Widget> screens = [
    const Homescreen(),
    const Myfavscreen(),
    const Mypackagescreen(),
  ];

  @override
  void initState() {
    super.initState();
    index = widget
        .initialIndex; // set intialindex when widget (list Screen) is load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
          key: bottomNavigationKey,
          onTap: (selectedIndex) {
            setState(() {
              index = selectedIndex;
            });
          },
          index: index,
          height: 60,
          backgroundColor: Colors.white,
          color: const Color.fromARGB(255, 54, 12, 206),
          animationDuration: const Duration(milliseconds: 300),
          items: const [
            Icon(
              Icons.home,
              color: Colors.white,
            ),
            Icon(
              Icons.favorite,
              color: Colors.white,
            ),
            Icon(
              Icons.card_travel,
              color: Colors.white,
            )
          ]),
      body: screens[index],
    );
  }
}
