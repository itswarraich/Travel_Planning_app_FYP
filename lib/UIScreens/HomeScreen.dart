// ignore_for_file: file_names, unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_planning_fyp/UIScreens/MyFavScreen.dart';
import 'package:travel_planning_fyp/UIScreens/MyPackageScreen.dart';
import 'package:travel_planning_fyp/UIScreens/SignIN.dart';
import 'package:travel_planning_fyp/Widgets/BoldText.dart';
import 'package:travel_planning_fyp/Widgets/LightText.dart';
import 'package:travel_planning_fyp/Widgets/NameListile.dart';
import 'package:travel_planning_fyp/Widgets/PackageListile.dart';
import 'package:travel_planning_fyp/Widgets/TextFormField.dart';
import 'package:travel_planning_fyp/Widgets/drawerList.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  String searchData = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = _auth.currentUser;
  }

  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //Appbar...................................//..........................................
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 54, 12, 206),
          centerTitle: true,
          title: Boldtext(
            text: "Travelling",
            size: 25,
            color: Colors.white,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),

        //Drawer..................................//..........................................
        drawer: Drawer(
          child: Column(
            children: [
              //1st Container....................//................................................
              Expanded(
                flex: 1,
                child: Container(
                  color: const Color.fromARGB(255, 54, 12, 206),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(45),
                            border: Border.all(width: 2, color: Colors.yellow),
                            //color: Colors.red
                            image: const DecorationImage(
                                image: AssetImage("assets/images/6.webp"),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      user != null
                          ? Boldtext(
                              text: user!.email.toString(),
                              color: Colors.white,
                            )
                          : Boldtext(
                              text: "abc@gmail.com",
                              color: Colors.white,
                            )
                    ],
                  ),
                ),
              ),

              //2nd Container...................//...............................................
              Expanded(
                flex: 3,
                child: Container(
                  color: Colors.white,
                  child: const Column(
                    children: [
                      Drawerlist(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),

                //First Column Used for Text and SearchBar..................................//.................
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Text Used Welcome User.................................................//.................
                    Boldtext(
                      text: "Welcome",
                      size: 25,
                      color: const Color.fromARGB(255, 54, 12, 206),
                    ),
                    Lighttext(
                      text: "Explore The Beauty of Pakistan",
                      size: 17,
                      color: const Color.fromARGB(255, 54, 12, 206),
                    ),

                    const SizedBox(
                      height: 25,
                    ),

                    //Search Field Used Here..................................................//.................
                    Textformfield1(
                      maxlength: 1,
                      keyboard: TextInputType.text,
                      borderColor: const Color.fromARGB(255, 54, 12, 206),
                      focusborderColor: const Color.fromARGB(255, 54, 12, 206),
                      //focusborderColor: Colors.purpleAccent.shade100,
                      //borderColor:Colors.purpleAccent,
                      borderRadious: 40,
                      styleColor: const Color.fromARGB(255, 54, 12, 206),
                      filled: true,
                      fillColor: Colors.white,
                      heightpadding: 13,
                      // fillColor:const Color.fromARGB(255, 54, 12, 206),
                      icon: const Icon(
                        Icons.search,
                        color: Color.fromARGB(255, 54, 12, 206),
                      ),
                      hintName: "Search Pakages",
                      hintColor: Colors.grey,
                      hideText: false,
                      controller: searchController,
                      onchange: (value) {
                        setState(() {
                          searchData = value;
                        });
                      },
                    ),
                  ],
                ),
              ),

              //2nd Column for lists.....................................//.................................
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //Popular Packges Text.........................//..............................
                    const SizedBox(
                      height: 5,
                    ),
                    Boldtext(
                      text: "Popular Packages",
                      size: 22,
                      color: const Color.fromARGB(255, 54, 12, 206),
                    ),

                    //Package Name List...........................//............................................
                    const SizedBox(
                      height: 21,
                    ),
                    Namelistile(
                      searchQuery: searchData,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
