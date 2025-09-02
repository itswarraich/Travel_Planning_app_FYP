// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_planning_fyp/Utills/utills.dart';
import 'package:travel_planning_fyp/Widgets/BoldText.dart';
import 'package:travel_planning_fyp/Widgets/Button.dart';
import 'package:travel_planning_fyp/Widgets/LightText.dart';
import 'package:travel_planning_fyp/Widgets/TextFormField.dart';

class Verifyemail extends StatefulWidget {
  const Verifyemail({super.key});

  @override
  State<Verifyemail> createState() => _VerifyemailState();
}

class _VerifyemailState extends State<Verifyemail> {
  final TextEditingController emailController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //appBar: AppBar(title: Boldtext(text: "Forgot Password"),centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.only(
            left: 20.0, right: 20.0, bottom: 20.0, top: 100),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Text about Inform..................................//.................................
              Boldtext(
                text: "Forgot Your Password",
                color: const Color.fromARGB(255, 54, 12, 206),
                size: 22,
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 17),
                child: Lighttext(
                  text:
                      "Please enter the email address you’d  like your password, reset information sent to",
                  color: const Color.fromARGB(255, 71, 70, 70),
                ),
              ),

              const SizedBox(
                height: 40,
              ),
              //TextFormField.......................................//................................
              Textformfield1(
                maxlength: 1,
                keyboard: TextInputType.emailAddress,
                focusborderColor: const Color.fromARGB(255, 54, 12, 206),
                borderColor: const Color.fromARGB(255, 54, 12, 206),
                borderRadious: 20,
                hintName: "Enter your Email...",
                controller: emailController,
                hideText: false,
                icon: const Icon(
                  Icons.email,
                  color: Color.fromARGB(255, 54, 12, 206),
                ),
              ),
              const SizedBox(
                height: 35,
              ),

              //Forgot Button.......................................//....................................
              GestureDetector(
                onTap: () {
                  setState(() {
                    loading = true;
                  });
                  _auth
                      .sendPasswordResetEmail(
                          email: emailController.text.toString())
                      .then((value) {
                    Utills().toastMessage(
                        "We have sent you email to recover your password, please check email",
                        const Color.fromARGB(255, 54, 12, 206));
                    setState(() {
                      loading = false;
                    });
                  }).onError((error, stackTrace) {
                    setState(() {
                      loading = false;
                    });
                    Utills().toastMessage(error.toString(), Colors.red);
                  });
                },
                child: Button(
                    loading: loading,
                    text: "Forgot",
                    height: 50,
                    width: double.maxFinite,
                    color: const Color.fromARGB(255, 54, 12, 206)),
              ),

              //Back to SignIn Page................................//.....................................
              const SizedBox(
                height: 40,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Boldtext(
                    text: "Back to SignIn",
                    color: const Color.fromARGB(255, 54, 12, 206),
                    decoration: TextDecoration.underline,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
