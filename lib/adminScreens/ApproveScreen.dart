// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_planning_fyp/Utills/utills.dart';
import 'package:travel_planning_fyp/Widgets/BoldText.dart';


class Approvescreen extends StatefulWidget {
  const Approvescreen({super.key});

  @override
  State<Approvescreen> createState() => _ApprovescreenState();
}

class _ApprovescreenState extends State<Approvescreen> {

final firstore=FirebaseFirestore.instance ; 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: const Color.fromARGB(255, 54, 12, 206),
        centerTitle: true,
        title: Boldtext(
          text: "All User Packages",
          size: 25,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        
      ),
      backgroundColor: Colors.white,
      
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder<QuerySnapshot>(
        stream: firstore.collectionGroup("Bookings").snapshots(),
        builder: (context, snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }
          if(!snapshot.hasData|| snapshot.data!.docs.isEmpty){
            return Center(child: Boldtext(text: "No Package Found...", color:const Color.fromARGB(255, 54, 12, 206), size: 14));
          }
          final bookings=snapshot.data!.docs;

          
          
          return  ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index){
              final booking=bookings[index].data() as Map<String, dynamic>;
              final status=booking["Status"]?? "Unknown";
              final userId=bookings[index].reference.parent.parent?.id?? "Unknown";
              final bookingId=bookings[index].id;
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
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                              image: const DecorationImage(
                                  image: AssetImage("assets/images/6.webp"),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(30)),
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
                                text: booking["Location_Name"].toString(),
                                size: 12,
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
                          text: "PayId: ${booking["Transection_Id"]}",
                          color: const Color.fromARGB(255, 54, 12, 206),
                          size: 12,
                        ),
                        Boldtext(
                          text: "Total Rs: ${booking["Total_Price"].toString()}",
                          size: 12,
                          color: const Color.fromARGB(255, 54, 12, 206),
                        ),
                        Boldtext(text: "Total Days: ${booking["Total_Days"].toString()}",
                        size: 12,
                        color: const Color.fromARGB(255, 54, 12, 206),),
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
                          color: status=="Pending"?Colors.red: status=="Rejected"?Colors.red: Colors.green
                        )
                        ],),

                        //Two Button USed  Approve and reject by admin...............//.............
                        const SizedBox(height: 10,),
                        Row(children: [
                          ElevatedButton(onPressed: (){
                            updateStatus(
                            userId,
                            bookingId,
                            "Approved");
                          }, child: Boldtext(text: "Approve", size: 10,
                          color: const Color.fromARGB(255, 54, 12, 206),)),
                          const SizedBox(width: 10,),
                          ElevatedButton(onPressed: (){
                            updateStatus(
                            userId,
                            bookingId,
                            "Rejected");
                          }, child: Boldtext(text: "Reject", size: 10,
                          color: const Color.fromARGB(255, 54, 12, 206),))
                        ],)
                      ],
                    )
                  ],
                ),
              ),
            );
          });
        
        }),
      ),
    );
  }
  void updateStatus(String userId, String bookingId, String newStatus) async {
    try {
      await firstore
          .collection("User_Booking")
          .doc(userId)
          .collection("Bookings")
          .doc(bookingId)
          .update({"Status": newStatus});

      Utills().toastMessage(
        "Booking $newStatus",
        newStatus == "Approved"
            ? const Color.fromARGB(255, 54, 12, 206)
            : Colors.red,
      );
    } catch (error) {
      Utills().toastMessage(error.toString(), Colors.red);
    }
  }
}




