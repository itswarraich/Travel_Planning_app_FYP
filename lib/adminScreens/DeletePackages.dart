// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:travel_planning_fyp/Widgets/BoldText.dart';
import 'package:travel_planning_fyp/Widgets/admincategory.dart';

class Deletepackages extends StatefulWidget {
  const Deletepackages({super.key});

  @override
  State<Deletepackages> createState() => _DeletepackagesState();
}

class _DeletepackagesState extends State<Deletepackages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 54, 12, 206),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Boldtext(
          text: "Delete Packages",
          color: Colors.white,
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Admincategory(),
          ],
        ),
      ),
    );
  }
}
