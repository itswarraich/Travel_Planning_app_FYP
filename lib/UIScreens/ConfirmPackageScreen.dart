// ignore_for_file: file_names

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_planning_fyp/UIScreens/AllBottomScreens.dart';
import 'package:travel_planning_fyp/Utills/utills.dart';
import 'package:travel_planning_fyp/Widgets/BoldText.dart';
import 'package:travel_planning_fyp/Widgets/Button.dart';
import 'package:travel_planning_fyp/Widgets/TextFormField.dart';
import 'package:travel_planning_fyp/Widgets/drawerList.dart';

class Confirmpackagescreen extends StatefulWidget {
  final double price;
  final String locationName;
  final String? imgPath;
  const Confirmpackagescreen(
      {super.key,
      required this.price,
      required this.locationName,
      this.imgPath});

  @override
  State<Confirmpackagescreen> createState() => _ConfirmpackagescreenState();
}

class _ConfirmpackagescreenState extends State<Confirmpackagescreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  //FormKey....................................//......................
  final GlobalKey<FormState> _key1 = GlobalKey<FormState>();
  //Controllers................................//......................
  final nameController = TextEditingController();
  final locationController = TextEditingController();
  final phoneController = TextEditingController();
  final numberDaysController = TextEditingController();
  final priceController = TextEditingController();
  final paymentController = TextEditingController();
  final idController = TextEditingController();

  int selectedDays = 1;
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = _auth.currentUser;
    // Set the initial price
    priceController.text = widget.price.toString();
    locationController.text = widget.locationName.toString();
    numberDaysController.text = selectedDays.toString();
  }

  //Add method for firebase................................//.....................
  void submitBooking() async{
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userId = user.uid;
      //Firebase Realtime Database instance.................//..............
      final firestore=FirebaseFirestore.instance;
      await firestore.collection("User_Booking").doc(userId).collection("Bookings").add({
        "Name": nameController.text.toString(),
        "Phone_No": phoneController.text.toString(),
        "Location_Name": locationController.text.toString(),
        "Total_Days": numberDaysController.text.toString(),
        "Total_Price": priceController.text.toString(),
        "Payment_Method": paymentController.text.toString(),
        "Transection_Id": idController.text.toString(),
        "Status": "Pending"
      })
      .then((value) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const Allbottom(initialIndex: 2,)));
      }).onError((error, stackTrace) {
        Utills().toastMessage(error.toString(), Colors.red);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

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

      body: SingleChildScrollView(
        child: Column(
          children: [
            
            //Form Used ...............................................//...........................
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Form(
                  key: _key1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Field for Name...........................................//............................
                      Boldtext(
                        text: "Name",
                        color: const Color.fromARGB(255, 54, 12, 206),
                        size: 13,
                      ),
                      Textformfield1(
                        maxlength: 1,
                        keyboard: TextInputType.text,
                        hintName: " Enter your Name",
                        hideText: false,
                        controller: nameController,
                        heightpadding: 12,
                        borderColor: const Color.fromARGB(255, 54, 12, 206),
                        focusborderColor:
                            const Color.fromARGB(255, 54, 12, 206),
                        borderRadious: 10,
                        styleColor: const Color.fromARGB(255, 54, 12, 206),
                        filled: true,
                        fillColor: Colors.white,
                        hintColor: Colors.grey,
                        icon: const Icon(
                          Icons.person,
                          color: Color.fromARGB(255, 54, 12, 206),
                        ),
                        validator1: (value) {
                          if (value == null || value.isEmpty) {
                            return "Name field cannot be empty!";
                          } else if (value.length < 3) {
                            return "Name is small!";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(
                        height: 8,
                      ),
                      //Field for Phone No .........................................//.............................
                      Boldtext(
                        text: "Phone No",
                        color: const Color.fromARGB(255, 54, 12, 206),
                        size: 13,
                      ),
                      Textformfield1(
                        maxlength: 1,
                        keyboard: TextInputType.phone,
                        hintName: "Enter phone no",
                        hideText: false,
                        controller: phoneController,
                        heightpadding: 12,
                        borderColor: const Color.fromARGB(255, 54, 12, 206),
                        focusborderColor:
                            const Color.fromARGB(255, 54, 12, 206),
                        borderRadious: 10,
                        styleColor: const Color.fromARGB(255, 54, 12, 206),
                        filled: true,
                        fillColor: Colors.white,
                        hintColor: Colors.grey,
                        icon: const Icon(
                          Icons.call,
                          color: Color.fromARGB(255, 54, 12, 206),
                        ),
                        validator1: (value) {
                          if (value == null || value.isEmpty) {
                            return "phone field cannot be empty!";
                          } else if (value.length < 10) {
                            return "Enter valid phone no!";
                          }

                          return null;
                        },
                      ),

                      const SizedBox(
                        height: 8,
                      ),
                      //Field for Location Name...........................................//..................
                      Boldtext(
                        text: "Location Name",
                        color: const Color.fromARGB(255, 54, 12, 206),
                        size: 13,
                      ),
                      Textformfield1(
                        maxlength: 1,
                        keyboard: TextInputType.text,
                        readonly: true,
                        hintName: widget.locationName,
                        hideText: false,
                        controller: locationController,
                        heightpadding: 12,
                        borderColor: const Color.fromARGB(255, 54, 12, 206),
                        focusborderColor:
                            const Color.fromARGB(255, 54, 12, 206),
                        borderRadious: 10,
                        styleColor: const Color.fromARGB(255, 54, 12, 206),
                        filled: true,
                        fillColor: Colors.white,
                        hintColor: Colors.grey,
                        icon: const Icon(
                          Icons.location_on,
                          color: Color.fromARGB(255, 54, 12, 206),
                        ),
                      ),

                      const SizedBox(
                        height: 8,
                      ),
                      //Field for No of Days Selection .........................................//..........................
                      Boldtext(
                        text: "Select Days",
                        color: const Color.fromARGB(255, 54, 12, 206),
                        size: 13,
                      ),
                      Textformfield1(
                        maxlength: 1,
                        keyboard: TextInputType.number,
                        hintName: "",
                        hideText: false,
                        controller: numberDaysController,
                        heightpadding: 12,
                        borderColor: const Color.fromARGB(255, 54, 12, 206),
                        focusborderColor:
                            const Color.fromARGB(255, 54, 12, 206),
                        borderRadious: 10,
                        styleColor: const Color.fromARGB(255, 54, 12, 206),
                        filled: true,
                        fillColor: Colors.white,
                        hintColor: Colors.grey,
                        icon: const Icon(
                          Icons.calendar_today,
                          color: Color.fromARGB(255, 54, 12, 206),
                        ),
                        isdropDown: true,
                        itemColor: Color.fromARGB(255, 54, 12, 206),
                        dropDownItems: List.generate(30, (index) => index + 1),
                        onchange: (value) {
                          setState(() {
                            selectedDays =
                                value; // Assign the selected days as int
                            priceController.text = (selectedDays * widget.price)
                                .toString(); // Update price with int calculation
                          });
                        },
                      ),

                      const SizedBox(
                        height: 8,
                      ),
                      //Field for price Selection .........................................//..........................
                      Boldtext(
                        text: "Total Price",
                        color: const Color.fromARGB(255, 54, 12, 206),
                        size: 13,
                      ),
                      Textformfield1(
                        maxlength: 1,
                        keyboard: TextInputType.number,
                        hintName: "",
                        hideText: false,
                        controller: priceController,
                        heightpadding: 12,
                        borderColor: const Color.fromARGB(255, 54, 12, 206),
                        focusborderColor:
                            const Color.fromARGB(255, 54, 12, 206),
                        borderRadious: 10,
                        styleColor: const Color.fromARGB(255, 54, 12, 206),
                        filled: true,
                        fillColor: Colors.white,
                        hintColor: Colors.grey,
                        readonly: true,
                        icon: const Icon(
                          Icons.money,
                          color: Color.fromARGB(255, 54, 12, 206),
                        ),
                      ),

                      const SizedBox(
                        height: 8,
                      ),
                      //Field for payment method Selection .........................................//..........................
                      Boldtext(
                        text: "Payment Method",
                        color: const Color.fromARGB(255, 54, 12, 206),
                        size: 13,
                      ),
                      Textformfield1(
                        maxlength: 1,
                        keyboard: TextInputType.text,
                        hintName: "--Select-Payment-Method--",
                        hideText: false,
                        controller: paymentController,
                        heightpadding: 12,
                        borderColor: const Color.fromARGB(255, 54, 12, 206),
                        focusborderColor:
                            const Color.fromARGB(255, 54, 12, 206),
                        borderRadious: 10,
                        styleColor: const Color.fromARGB(255, 54, 12, 206),
                        filled: true,
                        fillColor: Colors.white,
                        hintColor: Colors.grey,
                        icon: const Icon(
                          Icons.payment,
                          color: Color.fromARGB(255, 54, 12, 206),
                        ),
                        isdropDown: true,
                        dropDownItems: const [
                          "--Select-payment-method--",
                          "Jazzcash",
                          "Easypaisa"
                        ],
                        validator1: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value == "--Select-payment-method--") {
                            return "Choose a valid payment method!";
                          }
                          return null;
                        },
                        onchange: (value) {
                          paymentController.text = value;
                          if (value == "Jazzcash") {
                            AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.success,
                                    title: "Payment Method",
                                    titleTextStyle: const TextStyle(
                                        color: Color.fromARGB(255, 54, 12, 206),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                    desc:
                                        "Bank: Jazzcash\n Account No:0306-6631428 \n \nBuy the package through Jazzcash and enter transection id.\nFor any query contact us on email: umarafzal4280@email.com.",
                                    descTextStyle: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 54, 12, 206)),
                                    btnOkOnPress: () {})
                                .show();
                          } else if (value == "Easypaisa") {
                            AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.success,
                                    title: "Payment Method",
                                    titleTextStyle: const TextStyle(
                                        color: Color.fromARGB(255, 54, 12, 206),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                    desc:
                                        "Bank: Easypaisa\n Account No:0306-6631428 \n \nBuy the package through easypaisa and enter transection id.\nFor any query contact us on email: umarafzal4280@email.com.",
                                    descTextStyle: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 54, 12, 206)),
                                    btnOkOnPress: () {})
                                .show();
                          }
                        },
                      ),

                      //Field for Transection ID....................//...............................
                      const SizedBox(
                        height: 8,
                      ),
                      Boldtext(
                        text: "Transection Id",
                        color: const Color.fromARGB(255, 54, 12, 206),
                        size: 13,
                      ),
                      Textformfield1(
                        maxlength: 1,
                        keyboard: TextInputType.number,
                        hintName: "#123421584328",
                        hideText: false,
                        controller: idController,
                        heightpadding: 12,
                        borderColor: const Color.fromARGB(255, 54, 12, 206),
                        focusborderColor:
                            const Color.fromARGB(255, 54, 12, 206),
                        borderRadious: 10,
                        styleColor: const Color.fromARGB(255, 54, 12, 206),
                        filled: true,
                        fillColor: Colors.white,
                        hintColor: Colors.grey,
                        icon: const Icon(
                          Icons.badge,
                          color: Color.fromARGB(255, 54, 12, 206),
                        ),
                        validator1: (value) {
                          if (value == null || value.isEmpty) {
                            return "Id cannot be empty";
                          } else if (value.length < 11) {
                            return "Enter valid id";
                          }
                          return null;
                        },
                      ),
                      //Button Used.................................//...............................

                      const SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            if (_key1.currentState?.validate() ?? false) {
                              AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.success,
                                  title: "Successfull",
                                  titleTextStyle: const TextStyle(
                                      color: Color.fromARGB(255, 54, 12, 206),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                  desc:
                                      "Congrats! You have book travel package successfully.For any urgent queries, contact us on email: umarafzal4280@email.com.",
                                  descTextStyle: const TextStyle(
                                      color: Color.fromARGB(255, 54, 12, 206)),
                                  btnOkOnPress: () {
                                    submitBooking();
                                  }).show();
                            }
                          },
                          child: Button(
                              text: "Confirm",
                              loading: loading,
                              height: 50,
                              width: 250,
                              color: const Color.fromARGB(255, 54, 12, 206)),
                        ),
                      )
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
