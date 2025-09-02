// ignore_for_file: file_names, must_be_immutable, no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_planning_fyp/UIScreens/ConfirmPackageScreen.dart';
import 'package:travel_planning_fyp/Utills/utills.dart';
import 'package:travel_planning_fyp/Widgets/BoldText.dart';
import 'package:travel_planning_fyp/Widgets/Button.dart';
import 'package:travel_planning_fyp/Widgets/LightText.dart';
import 'package:travel_planning_fyp/Widgets/ModelClass.dart';

class Detailedscreen extends StatefulWidget {
  String imgPath;
  String tittle;
  String? descriptionpkg;
  String id;
  Detailedscreen(
      {super.key,
      required this.imgPath,
      required this.tittle,
      this.descriptionpkg,
      required this.id,});

  @override
  State<Detailedscreen> createState() => _DetailedscreenState();
}

class _DetailedscreenState extends State<Detailedscreen> {
  List<bool> selectedPerson = [
    true,
    false,
    false,
    false,
    false,
  ];
  int selectIndex = 0;


  List<dynamic> favouritePackageId=[]; // Track favourite Package Id
  @override
void initState() {
  super.initState();
  fetchFavouritePkg(); // Fetch favorite packages when the screen loads
}

  //User Favourite Packages fetch ................................................//....................
  Future<void> fetchFavouritePkg()async{
    FirebaseAuth _auth=FirebaseAuth.instance;
    User? user=_auth.currentUser;
    if(user== null){
      Utills().toastMessage("You are not Login!", Colors.red);
      return;
    }
    FirebaseFirestore firestore=FirebaseFirestore.instance;
    QuerySnapshot snapshot=await firestore.collection("Favourites").doc(user.uid).collection("Packages").get();
    setState(() {
      favouritePackageId=snapshot.docs.map((doc)=>doc.id).toList();
    });

  }

  //Add to Favourite packages add and remove  in Firestore...................................
  Future<void> toggleFavouritePackage(PackageList package)async{
    FirebaseAuth _auth=FirebaseAuth.instance;
    User? user=_auth.currentUser;
    if(user == null){
      Utills().toastMessage("User not logged in", Colors.red);
      return;
    }
    FirebaseFirestore favouritePkg=FirebaseFirestore.instance;
    
    DocumentReference favDoc=favouritePkg.collection("Favourites").doc(user.uid).collection("Packages").doc(package.id);
    if(favouritePackageId.contains(package.id)){
      await favDoc.delete();
      setState(() {
        favouritePackageId.remove(package.id);
      });
      Utills().toastMessage("Removed from Favourite", const Color.fromARGB(255, 54, 12, 206));
    }else{
      await favDoc.set({
      "Location_Name": package.locationName,
      "Description":package.description,
      "ImageURL": package.imgPath,
      });
      setState(() {
        favouritePackageId.add(package.id);
      });
      Utills().toastMessage("Added to Favourite", const Color.fromARGB(255, 54, 12, 206));
    }
    
  }

  



  @override
  Widget build(BuildContext context) {
final isFavourite = favouritePackageId.contains(widget.id);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              // 1st Container (Top Image)...............................//.............................
              Container(
                height: MediaQuery.sizeOf(context).height * 0.38,
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.imgPath),
                    fit: BoxFit.cover,
                  ),
                ),

                //Row Widget Use for Back to HomeScreen Icon and Favrotie add..................//......................
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border:
                                  Border.all(width: 2, color: Colors.white)),
                          child:
                              const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                      ),

                      //Favourite Container..............................................
                      GestureDetector(
                        onTap: () {
                          final package = PackageList(
                            id: widget.id, // Replace with actual ID logic
                            imgPath: widget.imgPath,
                            locationName: widget.tittle,
                            description: widget.descriptionpkg ?? "",);
                          toggleFavouritePackage(package);
                        },
                        child: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(width: 2, color: Colors.white)),
                          child: isFavourite? const Icon(
                                    Icons.favorite, color: Colors.red,):
                                    const Icon(Icons.favorite_outline, color: Colors.white,),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              // 2nd Container (Overlapping)..........................//....................................
              Transform.translate(
                //Move Container Top Up..............................//.....................................
                offset: const Offset(0, -30),
                child: Container(
                  height: MediaQuery.sizeOf(context).height * 0.63,
                  width: MediaQuery.sizeOf(context).width,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Row Use for Title Name and Price.....................//.....................
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Boldtext(
                              text: widget.tittle,
                              size: 28,
                              color: const Color.fromARGB(255, 54, 12, 206),
                            ),
                            Boldtext(
                              text: "Rs. ${(selectIndex + 1) * 4000}",
                              size: 18,
                              color: const Color.fromARGB(255, 54, 12, 206),
                            )
                          ],
                        ),

                        //Row Use for Pakistan Name and Icon and per day Price.....................//.....................
                        Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            //1st Row Use for location icon and Pakistan............................//.................
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Color.fromARGB(255, 54, 12, 206),
                                  size: 16,
                                ),
                                Boldtext(
                                  text: "Pakistan",
                                  size: 14,
                                  color: const Color.fromARGB(255, 54, 12, 206),
                                ),

                                //2nd Row Use for Per Day.........................................//.....................
                                SizedBox(
                                  width: MediaQuery.sizeOf(context).width * 0.5,
                                ),
                                Row(
                                  children: [
                                    Boldtext(
                                      text: "(Per Day)",
                                      size: 14,
                                      color: const Color.fromARGB(
                                          255, 54, 12, 206),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),

                        //Rating Row  with Listview...........................//...............................
                        Row(
                          
                          children: List.generate(5, (index) {
                            return Icon(
                              index < 4 ? Icons.star : Icons.star_border,
                              size: 15,
                              color: index < 4 ? Colors.yellow : Colors.grey,
                            );
                          }),
                        ),

                        //BoldText for Peoples and text selection....................................//...........................
                        const SizedBox(
                          height: 10,
                        ),
                        Boldtext(
                          text: "People",
                          color: const Color.fromARGB(255, 54, 12, 206),
                          size: 22,
                        ),
                        Lighttext(
                          text: "Select Number of People",
                          color: const Color.fromARGB(255, 54, 12, 206),
                          size: 14,
                        ),

                        //Row List for boxes for numbers............................................//............................

                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: List.generate(5, (index) {
                            int numbers = index + 1;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8, top: 8),
                              child: GestureDetector(
                                onTap: () {
                                  for (int i = 0;
                                      i < selectedPerson.length;
                                      i++) {
                                    selectedPerson[i] = false;
                                  }
                                  setState(() {
                                    selectedPerson[index] = true;
                                    selectIndex = index;
                                  });
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      color: selectedPerson[index]
                                          ? const Color.fromARGB(
                                              255, 54, 12, 206)
                                          : const Color(0xFF9C27B0),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Center(
                                      child: Boldtext(
                                    text: numbers.toString(),
                                    size: 28,
                                    color: Colors.white,
                                  )),
                                ),
                              ),
                            );
                          }),
                        ),

                        //Description of the Package............................................//.........................
                        const SizedBox(
                          height: 15,
                        ),
                        Boldtext(
                          text: "Description",
                          size: 22,
                          color: const Color.fromARGB(255, 54, 12, 206),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Lighttext(
                          text: widget.descriptionpkg.toString(),
                          size: 16,
                          color: const Color.fromARGB(255, 54, 12, 206),
                        ),

                        //BookNow Button.......................................................//...........................
                        const SizedBox(
                          height: 22,
                        ),
                        Center(
                            child: GestureDetector(
                          onTap: () {
                            double selectedPrice = (selectIndex + 1) * 4000.0;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Confirmpackagescreen(
                                          price: selectedPrice,
                                          locationName: widget.tittle,
                                          imgPath: widget.imgPath,
                                        )));
                          },
                          child: Button(
                            text: "Book Now",
                            height: 50,
                            width: 250,
                            color: const Color.fromARGB(255, 54, 12, 206),
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
