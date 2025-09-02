// ignore_for_file: override_on_non_overriding_member, prefer_const_constructors_in_immutables, file_names, avoid_unnecessary_containers, non_constant_identifier_names, avoid_types_as_parameter_names, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_planning_fyp/UIScreens/AllBottomScreens.dart';
import 'package:travel_planning_fyp/UIScreens/HomeScreen.dart';
import 'package:travel_planning_fyp/UIScreens/SignUpScreen.dart';
import 'package:travel_planning_fyp/UIScreens/VerifyEmail.dart';
import 'package:travel_planning_fyp/Utills/utills.dart';
import 'package:travel_planning_fyp/Widgets/BoldText.dart';
import 'package:travel_planning_fyp/Widgets/Button.dart';
import 'package:travel_planning_fyp/Widgets/TextFormField.dart';
import 'package:travel_planning_fyp/adminScreens/AddPackages.dart';
import 'package:travel_planning_fyp/adminScreens/AdminChooseScreen.dart';

import '../Widgets/LightText.dart';

class SignIN extends StatefulWidget {
  SignIN({super.key});

  @override
  State<SignIN> createState() => _SignINState();
}

class _SignINState extends State<SignIN> {
//create a Form Global Key....................
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool loading = false;

//SignIn Function....................................//.............................
  void signIn() {
    setState(() {
      loading = true;
    });

    _auth.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    ).then((UserCredential userCredential) {
      String uid = userCredential.user!.uid;

      // Initialize Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Fetch role from Firestore
      firestore.collection("Users").doc(uid).get().then((DocumentSnapshot doc) {
        if (doc.exists) {
          var data = doc.data() as Map<String, dynamic>;
          String role = data["role"] ?? "user"; // Default to "user" if role is missing or null

          if (role == 'admin') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Adminchoosescreen()),
            ); // Admin screen
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Allbottom(initialIndex: 0)),
            ); // User screen
          }
        } else {
          Utills().toastMessage("User role not defined", Colors.red);
        }
      }).catchError((error) {
        Utills().toastMessage("Error fetching role: $error", Colors.red);
      });
    }).onError((error, stackTrace) {
      Utills().toastMessage("Sign-in failed: $error", Colors.red);
    }).whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }


 
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color.fromARGB(255, 54, 12, 206),
        body: SingleChildScrollView(
          child: Column(
            children: [
              //1st Contaner..........................//...........................
              Container(
                height: MediaQuery.sizeOf(context).height * 0.25,
                width: MediaQuery.sizeOf(context).width * 1,
                color: const Color.fromARGB(255, 54, 12, 206),
                child: Center(
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
              ),

              //2nd Container.........................//............................
              Container(
                height: MediaQuery.sizeOf(context).height * 0.72,
                width: double.maxFinite,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(255, 54, 12, 206),
                          blurRadius: 20,
                          offset: Offset(0, -8))
                    ],
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //TextFormField Part ...........................//.........................

                        Boldtext(
                          text: "SignIn",
                          color: const Color.fromARGB(255, 54, 12, 206),
                          size: 22,
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        //Email Field..................................///.........................
                        Textformfield1(
                          maxlength: 1,
                          keyboard: TextInputType.emailAddress,
                          focusborderColor:
                              const Color.fromARGB(255, 54, 12, 206),
                          borderColor: const Color.fromARGB(255, 54, 12, 206),
                          borderRadious: 20,
                          controller: emailController,
                          icon: const Icon(
                            Icons.email,
                            color: Color.fromARGB(255, 54, 12, 206),
                          ),
                          hintName: "Email",
                          hideText: false,
                          formKey: _formkey,
                          validator1: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email Cannot be Empty!";
                            } else if (!value.endsWith("@gmail.com")) {
                              return "Enter Correct Email!";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 13,
                        ),

                        //Passwrod Field..............................//..........................
                        Textformfield1(
                          maxlength: 1,
                          keyboard: TextInputType.text,
                          focusborderColor:
                              const Color.fromARGB(255, 54, 12, 206),
                          borderColor: const Color.fromARGB(255, 54, 12, 206),
                          borderRadious: 20,
                          controller: passwordController,
                          icon: const Icon(
                            Icons.lock,
                            color: Color.fromARGB(255, 54, 12, 206),
                          ),
                          hintName: "Password",
                          hideText: true,
                          formKey: _formkey,
                          validator1: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter Password";
                            } else if (value.length < 6) {
                              return "Password length not Match!";
                            }
                            return null;
                            //   }else if (!RegExp(r'^(?=.*[A-Z])(?=.*[!@#$%^&*()]).*$').hasMatch(value)) {
                            //   return "Password must contain an uppercase letter and a special character!";
                            // }return null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const Verifyemail()));
                            },
                            child: Boldtext(
                              text: "Forgot Password?",
                              size: 14,
                              color: const Color.fromARGB(255, 54, 12, 206),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 35,
                        ),

                        //SignUp Button ..............................//...........................
                        Button(
                          text: "SignIn",
                          loading: loading,
                          height: 50,
                          width: double.maxFinite,
                          color: const Color.fromARGB(255, 54, 12, 206),
                          //Function Call ..............................//..........................
                          ontap: () {
                            if (_formkey.currentState?.validate() ?? false) {
                              signIn();
                            }
                            //Navigator.push(context, MaterialPageRoute(builder: (context)=>const Homescreen()));
                          },
                        ),

                        //RichText Use for not Have Account?...........//...........................
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lighttext(
                              text: "Don`t have an Account?",
                              size: 15,
                              color: const Color.fromARGB(255, 71, 70, 70),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Signupscreen()));
                                },
                                child: Boldtext(
                                  text: "SignUp",
                                  color: const Color.fromARGB(255, 54, 12, 206),
                                  size: 17,
                                ))
                          ],
                        )
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
