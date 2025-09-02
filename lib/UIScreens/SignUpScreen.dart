// ignore_for_file: override_on_non_overriding_member, prefer_const_constructors_in_immutables, file_names, avoid_unnecessary_containers, unnecessary_import, avoid_types_as_parameter_names, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:travel_planning_fyp/UIScreens/AllBottomScreens.dart';
import 'package:travel_planning_fyp/UIScreens/SignIN.dart';
import 'package:travel_planning_fyp/Utills/utills.dart';
import 'package:travel_planning_fyp/Widgets/BoldText.dart';
import 'package:travel_planning_fyp/Widgets/Button.dart';
import 'package:travel_planning_fyp/Widgets/LightText.dart';
import 'package:travel_planning_fyp/Widgets/TextFormField.dart';


class Signupscreen extends StatefulWidget {
  Signupscreen({super.key});

  @override
  State<Signupscreen> createState() => _SignupscreenState();
}

class _SignupscreenState extends State<Signupscreen> {
//create a Form Global Key.................................//...................
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
//create Controller here....................................//....................
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

//Firebase Auth Instance Create initialize.......................//..................
  final FirebaseAuth _auth = FirebaseAuth.instance;
//create loading................................................//..................
  bool loading = false;

//Signup Function..............................................//....................

void signUp() {
  setState(() {
    loading = true;
  });

  _auth
      .createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim())
      .then((value) {
    String uid = value.user!.uid; // Get user UID
    FirebaseFirestore firestore=FirebaseFirestore.instance;
    firestore.collection("Users").doc(uid).set({
      "email":emailController.text.trim(),
      "role": "user"
    });
    

    // Navigate to user home screen
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Allbottom(initialIndex: 0,)));

    setState(() {
      loading = false;
    });

    Utills().toastMessage(
        "Registered Successfully...", const Color.fromARGB(255, 54, 12, 206));
  }).onError((error, StackTrace) {
    setState(() {
      loading = false;
    });
    Utills().toastMessage(error.toString(), Colors.red);
  });
}

@override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //resizeToAvoidBottomInset: true,
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
                          text: "SignUp",
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
                              return "Password must be at least 6 characters long!";
                            } else if (!RegExp(
                                    r'^(?=.*[A-Z])(?=.*[!@#$%^&*()]).*$')
                                .hasMatch(value)) {
                              return "Password must contain an uppercase letter and a special character!";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 13,
                        ),

                        //Confrim Password..........................///...........................
                        Textformfield1(
                          maxlength: 1,
                          keyboard: TextInputType.text,
                          focusborderColor:
                              const Color.fromARGB(255, 54, 12, 206),
                          borderColor: const Color.fromARGB(255, 54, 12, 206),
                          borderRadious: 20,
                          controller: confirmPasswordController,
                          icon: const Icon(
                            Icons.lock,
                            color: Color.fromARGB(255, 54, 12, 206),
                          ),
                          hintName: "Confirm Password",
                          hideText: true,
                          formKey: _formkey,
                          validator1: (value) {
                            if (value != passwordController.text) {
                              return "Password do not Match!";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),

                        //SignUp Button ..............................//...........................
                        Button(
                          text: "SignUp",
                          loading: loading,
                          height: 50,
                          width: double.maxFinite,
                          color: const Color.fromARGB(255, 54, 12, 206),
                          //Function Call ..............................//..........................
                          ontap: () {
                            if (_formkey.currentState?.validate() ?? false) {
                              // function call here....................//............................
                              signUp();
                            }

                            //Navigator.push(context, MaterialPageRoute(builder: (context)=>const Homescreen()));
                          },
                        ),

                        //Text Use for Already if Login?...........//...........................
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lighttext(
                              text: "Already have an Account?",
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
                                          builder: (context) => SignIN()));
                                },
                                child: Boldtext(
                                  text: "SignIn",
                                  size: 17,
                                  color: const Color.fromARGB(255, 54, 12, 206),
                                ))
                          ],
                        ),
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
