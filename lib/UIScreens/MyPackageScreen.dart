// ignore_for_file: sized_box_for_whitespace, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_planning_fyp/Widgets/BoldText.dart';
import 'package:travel_planning_fyp/Widgets/drawerList.dart';

class Mypackagescreen extends StatefulWidget {
  const Mypackagescreen({super.key});

  @override
  State<Mypackagescreen> createState() => _MypackagescreenState();
}

class _MypackagescreenState extends State<Mypackagescreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  final User? user1 = FirebaseAuth.instance.currentUser;
  late CollectionReference userBookingRef;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;

    if (user1 != null) {
      userBookingRef =
          FirebaseFirestore.instance.collection("User_Booking").doc(user1!.uid).collection("Bookings");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 54, 12, 206),
        centerTitle: true,
        title: Boldtext(
          text: "My Packages",
          size: 25,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        
      ),
      backgroundColor: Colors.white,
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
                    user!=null? Boldtext(text: user!.email.toString(), color: Colors.white,): Boldtext(text: "abc@gmail.com", color: Colors.white,)
                    
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: userBookingRef.snapshots(),
          builder: (context, snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }
          if(!snapshot.hasData|| snapshot.data!.docs.isEmpty){
            return Center(child: Boldtext(text: "No Package Found...", color:const Color.fromARGB(255, 54, 12, 206), size: 14));
          }
          final bookings=snapshot.data!.docs;
          
          return ListView.builder(
            itemCount: bookings.length,
          itemBuilder: (context,  index) {
            final booking=bookings[index].data() as Map<String ,dynamic>;
            final status=booking["Status"];
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              height: 160,
              width: double.maxFinite,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(1, 1))
                  ],
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(30)),
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // First Column: Image & Location
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                              image: const DecorationImage(
                                  image: AssetImage("assets/images/6.webp"),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(50)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 6, top: 5),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Color.fromARGB(255, 54, 12, 206),
                              ),
                              Boldtext(
                                text: booking["Location_Name"],
                                size: 17,
                                color: const Color.fromARGB(255, 54, 12, 206),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    // Second Column: Details
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Boldtext(
                          text: "Pakistan",
                          color: const Color.fromARGB(255, 54, 12, 206),
                        ),
                        Boldtext(
                          text: "Total Days: ${booking["Total_Days"]}",
                          size: 13,
                          color: const Color.fromARGB(255, 54, 12, 206),
                        ),
                        Boldtext(
                          text: "Total Rs: ${booking["Total_Price"]}",
                          size: 13,
                          color: const Color.fromARGB(255, 54, 12, 206),
                        ),
                        //Row for status colors....................

                        Row(children: [
                          Boldtext(
                          text: "Status: ",
                          size: 13,
                          color: const Color.fromARGB(255, 54, 12, 206),
                        ),
                        Boldtext(
                          text: status,
                          size: 13,
                          color: getStatusColors(status),
                        )
                        ],)
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
        }),
      ),
    ));
  }
}



//Function for status colors change...............................//..........
 getStatusColors(String status){
  switch(status){
    case "Pending":
    return Colors.red;
    case "Approved":
    return const Color.fromARGB(255, 54, 12, 206);
    case "Rejected":
    return Colors.red;
    default:
    return const Color.fromARGB(255, 54, 12, 206);
  }
  
}