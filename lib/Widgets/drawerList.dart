// ignore_for_file: avoid_unnecessary_containers, file_names

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_planning_fyp/UIScreens/AllBottomScreens.dart';
import 'package:travel_planning_fyp/UIScreens/SignIN.dart';
import 'package:travel_planning_fyp/Utills/utills.dart';
import 'package:travel_planning_fyp/Widgets/BoldText.dart';

class Drawerlist extends StatefulWidget {
  const Drawerlist({super.key});

  @override
  State<Drawerlist> createState() => _DrawerlistState();
}

class _DrawerlistState extends State<Drawerlist> {
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          //1st List HomeScreen..............................................//............................
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Allbottom(
                            initialIndex: 0,
                          )));
            },
            child: ListTile(
              leading: const Icon(
                Icons.home_outlined,
                color: Color.fromARGB(255, 54, 12, 206),
              ),
              title: Boldtext(
                text: "Home",
                size: 18,
                color: const Color.fromARGB(255, 54, 12, 206),
              ),
            ),
          ),

          //2ndd List MyFavScreen............................................//.................................
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Allbottom(
                            initialIndex: 1,
                          )));
            },
            child: ListTile(
              leading: const Icon(
                Icons.favorite_outline,
                color: Color.fromARGB(255, 54, 12, 206),
              ),
              title: Boldtext(
                text: "My Favorites",
                size: 18,
                color: const Color.fromARGB(255, 54, 12, 206),
              ),
            ),
          ),

          //3rd List MyPackageScreen..................................//............................
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Allbottom(
                            initialIndex: 2,
                          )));
            },
            child: ListTile(
              leading: const Icon(
                Icons.card_travel_outlined,
                color: Color.fromARGB(255, 54, 12, 206),
              ),
              title: Boldtext(
                text: "My Packages",
                size: 18,
                color: const Color.fromARGB(255, 54, 12, 206),
              ),
            ),
          ),

          const SizedBox(
            height: 50,
          ),

          //Divider Use...........................................//.................................
          Container(
            height: 2,
            width: 260,
            color: const Color.fromARGB(255, 54, 12, 206),
          ),
          const SizedBox(
            height: 20,
          ),
          //List Use for Logout.....................................//...................................
          GestureDetector(
            onTap: () {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.warning,
                animType: AnimType.topSlide,
                showCloseIcon: true,
                title: "Warning",
                titleTextStyle: const TextStyle(
                    color: Color.fromARGB(255, 54, 12, 206),
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
                desc: "Are you sure to want Logout?",
                descTextStyle:
                    const TextStyle(color: Color.fromARGB(255, 54, 12, 206)),
                btnCancelOnPress: () {
                  Navigator.pop(context);
                },
                btnOkOnPress: () {
                  _auth.signOut().then((value) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignIN()));
                  }).onError(
                    (error, stackTrace) {
                      Utills().toastMessage("Network Problem!", Colors.red);
                    },
                  );
                },
              ).show();
            },
            child: ListTile(
              leading: const Icon(
                Icons.logout_outlined,
                color: Color.fromARGB(255, 54, 12, 206),
              ),
              title: Boldtext(
                text: "Logout",
                size: 18,
                color: const Color.fromARGB(255, 54, 12, 206),
              ),
            ),
          ),
        ],
      ),
    );
  }
}








//Dialogue box commented............................//.....................................

// Future<void> logOut(BuildContext context){
//     return showDialog(context: context,
//     builder: (context){
//       return AlertDialog(
//         title: Column(children: [
//           Transform.translate(
//           offset:const  Offset(0, -60),
//           child: Center(
//             child: Container(
//             clipBehavior: Clip.none,  
//             height: 90, width: 90, 
//             decoration: BoxDecoration(
//               color: Colors.yellow,
//               borderRadius: BorderRadius.circular(60)),),
//           ),
//         ),
//         ],),
//         content: Lighttext(text: "Are you sure to want Logout?", color: const Color.fromARGB(255, 54, 12, 206), size: 17,),
//         actions: [
//           GestureDetector(
//             onTap: () {
//               Navigator.pop(context);
//             },
//             child: Boldtext(text: "Cancel",size: 17, color:const Color.fromARGB(255, 54, 12, 206) ,)),
//           const SizedBox(width: 98,),
//           GestureDetector(
//             onTap: () {
//               _auth.signOut().then((value){
//                 Navigator.push(context, MaterialPageRoute(builder: (context)=> SignIN()));
//               });
//             },
//             child: Boldtext(text: "Confirm",size: 17, color: const Color.fromARGB(255, 54, 12, 206),)),
//         ],
//       );
//     });
//   }