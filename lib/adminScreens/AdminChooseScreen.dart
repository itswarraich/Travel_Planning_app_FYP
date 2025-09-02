// ignore_for_file: prefer_final_fields, file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_planning_fyp/UIScreens/SignIN.dart';
import 'package:travel_planning_fyp/Utills/utills.dart';
import 'package:travel_planning_fyp/Widgets/BoldText.dart';
import 'package:travel_planning_fyp/Widgets/Button.dart';
import 'package:travel_planning_fyp/adminScreens/AddPackages.dart';
import 'package:travel_planning_fyp/adminScreens/ApproveScreen.dart';
import 'package:travel_planning_fyp/adminScreens/DeletePackages.dart';


class Adminchoosescreen extends StatefulWidget {
  const Adminchoosescreen({super.key});

  @override
  State<Adminchoosescreen> createState() => _AdminchoosescreenState();
}

class _AdminchoosescreenState extends State<Adminchoosescreen> {
  FirebaseAuth _auth=FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 54, 12, 206),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Boldtext(
              text: "Choose What To Do?",
              color: Colors.white,
            ),
            const Spacer(),
            GestureDetector(
                onTap: () {
                  _auth.signOut().then((value) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignIN()));
                  }).onError(
                    (error, stackTrace) {
                      Utills().toastMessage(error.toString(), Colors.red);
                    },
                  );
                },
                child: const Icon(Icons.logout)),
                
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

          //Container Use for Company Logo...............................//....................

          Container(
            height: 90,
            width: 90,
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: Colors.yellow),
              borderRadius: BorderRadius.circular(30),
              image:const  DecorationImage(image: AssetImage("assets/images/6.webp"))
            ),
          ),

          //First Button for Add Packages..................................//...................
          const SizedBox( height: 20,),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const  Addpackages()));
            },
            child: Button(text: "Add Packages",
            height: 50,
            width: double.maxFinite,
            color: const Color.fromARGB(255, 54, 12, 206)),
          ),

          //Second Button For Approve Packages...........................//......................
          const SizedBox(height: 20,),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const  Approvescreen()));
            },
            child: Button(text: "Aprove Packages",
            height: 50,
            width: double.maxFinite,
            color: const Color.fromARGB(255, 54, 12, 206)),
          ),


          //Third Button For Delete Packages...........................//......................
          const SizedBox(height: 20,),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const  Deletepackages() ));
            },
            child: Button(text: "Delete Packages", 
            height: 50, 
            width: double.maxFinite, 
            color: const Color.fromARGB(255, 54, 12, 206)),
          )
        
        ],),
      ),
    );
  }
}