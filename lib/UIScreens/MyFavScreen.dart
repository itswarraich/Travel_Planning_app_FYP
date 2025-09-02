// ignore_for_file: file_names, no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_planning_fyp/UIScreens/DetailedScreen.dart';
import 'package:travel_planning_fyp/Utills/utills.dart';
import 'package:travel_planning_fyp/Widgets/BoldText.dart';
import 'package:travel_planning_fyp/Widgets/drawerList.dart';

class Myfavscreen extends StatefulWidget {
  const Myfavscreen({super.key});

  @override
  State<Myfavscreen> createState() => _MyfavscreenState();
}

class _MyfavscreenState extends State<Myfavscreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  List<dynamic> fetchFavList=[];


  

  //Remove the package from favourite list...........................//.......................
  Future <void> removePackagebyID(String documentID)  async{
    FirebaseAuth _auth=FirebaseAuth.instance;
    user=_auth.currentUser;
    if(user==null){
      return;
    }
    FirebaseFirestore firestore=FirebaseFirestore.instance;
     DocumentReference favDoc = firestore
      .collection("Favourites")
      .doc(user!.uid)
      .collection("Packages")
      .doc(documentID);

      await favDoc.delete();
    // setState(() {
    //   fetchFavList.removeWhere((package)=>package["id"]==documentID);
    // });
    Utills().toastMessage("Remove from Favourites...", const  Color.fromARGB(255, 54, 12, 206));
  }

 @override
Widget build(BuildContext context) {
  user = _auth.currentUser;
  if (user == null) {
    return Center(
      child: Boldtext(
        text: "User not logged in",
        size: 14,
        color: const Color.fromARGB(255, 54, 12, 206),
      ),
    );
  }

  return SafeArea(
    child: Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 54, 12, 206),
        centerTitle: true,
        title: Boldtext(
          text: "My Favorites",
          size: 25,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.white,
      drawer: Drawer(
        child: Column(
          children: [
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
                          image: const DecorationImage(
                            image: AssetImage("assets/images/6.webp"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    user != null
                        ? Boldtext(
                            text: user!.email.toString(),
                            color: Colors.white,
                          )
                        : Boldtext(
                            text: "abc@gmail.com",
                            color: Colors.white,
                          ),
                  ],
                ),
              ),
            ),
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Favourites")
            .doc(user!.uid)
            .collection("Packages")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Boldtext(
                text: "Error: ${snapshot.error}",
                size: 14,
                color: const Color.fromARGB(255, 54, 12, 206),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Boldtext(
                text: "No Favourite Package Found...",
                size: 14,
                color: const Color.fromARGB(255, 54, 12, 206),
              ),
            );
          }

          // Map Firestore documents to package data
          List<Map<String, dynamic>> fetchFavList = snapshot.data!.docs.map((doc) {
            var data = doc.data() as Map<String, dynamic>;
            data["id"] = doc.id;
            return data;
          }).toList();

          return GridView.builder(
            itemCount: fetchFavList.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 300,
              childAspectRatio: 0.7,
            ),
            itemBuilder: (context, index) {
              final package = fetchFavList[index];
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Detailedscreen(
                          imgPath: package["ImageURL"],
                          tittle: package["Location_Name"],
                          id: package["id"],
                          descriptionpkg: package["Description"],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(package["ImageURL"] ?? "assets/images/6.webp"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15, left: 88, right: 15),
                          child: GestureDetector(
                            onTap: () {
                              removePackagebyID(package["id"]);
                            },
                            child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(width: 2, color: Colors.white),
                              ),
                              child: const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 3, left: 10, top: 134, bottom: 3),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.white,
                              ),
                              Boldtext(
                                text: package["Location_Name"] ?? "Unknown Location",
                                size: 12,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    ),
  );
}
}
