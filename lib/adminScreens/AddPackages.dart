// ignore_for_file: file_names, sized_box_for_whitespace, unused_field, prefer_adjacent_string_concatenation

import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_planning_fyp/Utills/utills.dart';
import 'package:travel_planning_fyp/Widgets/BoldText.dart';
import 'package:travel_planning_fyp/Widgets/Button.dart';
import 'package:travel_planning_fyp/Widgets/TextFormField.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Addpackages extends StatefulWidget {
  const Addpackages({super.key});

  @override
  State<Addpackages> createState() => _AddpackagesState();
}

class _AddpackagesState extends State<Addpackages> {
  final _auth = FirebaseAuth.instance;
  //create key form validation.....................................
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  //Controllers.....................................................
  final packageController = TextEditingController();
  final locationNameController = TextEditingController();
  final descriptionController = TextEditingController();

  //for loading showing............
  bool loading = false;

  //selected image store....................
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  File? _selectedImg;
  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _selectedImg = File(pickedFile.path);
      } else {
        debugPrint("No Image Selected!");
      }
    });
  }

  Future addPackage() async {
  String category = packageController.text.trim();
  String captilizedCategory=category[0].toUpperCase() + category.substring(1);
  String location = locationNameController.text.trim();
  String description = descriptionController.text.trim();

  if (category.isNotEmpty && location.isNotEmpty && description.isNotEmpty && _selectedImg != null) {
    // Upload image to Firebase Storage and get URL
    var imageName = DateTime.now().microsecondsSinceEpoch.toString();
    firebase_storage.Reference reference = firebase_storage.FirebaseStorage.instance.ref('Folder/Images/$imageName');
    firebase_storage.UploadTask uploadTask = reference.putFile(_selectedImg!.absolute);
    await Future.value(uploadTask);
    String imageUrl = await reference.getDownloadURL();

    // Firestore Reference
    CollectionReference categoriesRef = FirebaseFirestore.instance.collection('Categories');
    QuerySnapshot querySnapshot=await categoriesRef.where("name", isEqualTo: captilizedCategory).get();
    DocumentReference categoryDoc;
    if (querySnapshot.docs.isEmpty) {
      categoryDoc=categoriesRef.doc(captilizedCategory);
      await categoryDoc.set({
        "name": captilizedCategory
      });
    }else{
      categoryDoc=categoriesRef.doc(querySnapshot.docs.first.id);
    }

    CollectionReference packageRef=categoryDoc.collection("Packages");
    await packageRef.add({
      "Location_Name": location,
      "Description":description,
      "ImageURL": imageUrl
    });

    // Clear fields after adding package
    packageController.clear();
    locationNameController.clear();
    descriptionController.clear();
    setState(() {
      _selectedImg = null;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      //Appbar...................................//..........................................
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 54, 12, 206),
        centerTitle: true,
        title: Row(
          children: [
            Boldtext(
              text: "Add Packages",
              size: 25,
              color: Colors.white,
            ),
            
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _key,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Package Catogory selection................................//.....................
                Boldtext(
                  text: "Package Category",
                  size: 13,
                  color: const Color.fromARGB(255, 54, 12, 206),
                ),
                Textformfield1(
                  maxlength: 1,
                    keyboard: TextInputType.text,
                    hintName: "Add Package Category",
                    hideText: false,
                    heightpadding: 12,
                    borderRadious: 10,
                    controller: packageController,
                    borderColor: const Color.fromARGB(255, 54, 12, 206),
                    focusborderColor: const Color.fromARGB(255, 54, 12, 206),
                    filled: true,
                    fillColor: Colors.white,
                    hintColor: Colors.grey,
                    isdropDown: true,
                    dropDownItems: ["Select-Package-Category","Family", "Friends", "Honeymoon", "Group"],
                    icon: const Icon(
                      Icons.category,
                      color: Color.fromARGB(255, 54, 12, 206),
                    ),
                    ),

                //Location Name field.......................................//........................
                const SizedBox(
                  height: 10,
                ),
                Boldtext(
                  text: "Location Name",
                  size: 13,
                  color: const Color.fromARGB(255, 54, 12, 206),
                ),
                Textformfield1(
                  maxlength: 1,
                  hintName: "Add location name",
                  keyboard: TextInputType.text,
                  hideText: false,
                  heightpadding: 12,
                  controller: locationNameController,
                  borderColor: const Color.fromARGB(255, 54, 12, 206),
                  focusborderColor: const Color.fromARGB(255, 54, 12, 206),
                  borderRadious: 10,
                  filled: true,
                  fillColor: Colors.white,
                  hintColor: Colors.grey,
                  icon: const Icon(
                    Icons.location_on,
                    color: Color.fromARGB(255, 54, 12, 206),
                  ),
                  validator1: (value) {
                    if (value == null || value.isEmpty) {
                      return "Location name cannot be empty!";
                    }
                    return null;
                  },
                ),

                //Description  field.......................................//........................
                const SizedBox(
                  height: 10,
                ),
                Boldtext(
                  text: "Package Description",
                  size: 13,
                  color: const Color.fromARGB(255, 54, 12, 206),
                ),
                Textformfield1(
                  maxlength: 3,
                  hintName: "Add description pakage",
                  keyboard: TextInputType.text,
                  hideText: false,
                  borderRadious: 10,
                  controller: descriptionController,
                  borderColor: const Color.fromARGB(255, 54, 12, 206),
                  focusborderColor: const Color.fromARGB(255, 54, 12, 206),
                  filled: true,
                  fillColor: Colors.white,
                  hintColor: Colors.grey,
                  icon:const  Icon(
                    
                    Icons.description,
                    color: Color.fromARGB(255, 54, 12, 206),
                  ),
                  validator1: (value) {
                    if (value == null || value.isEmpty) {
                      return "Description cannot be empty!";
                    }
                    return null;
                  },
                ),

                //Container for Image Selection for Package................................//........................
                const SizedBox(
                  height: 10,
                ),
                Boldtext(
                  text: "Image Selection",
                  color: const Color.fromARGB(255, 54, 12, 206),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      pickImage();

                    },
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 2,
                              color: const Color.fromARGB(255, 54, 12, 206))),
                      child: _selectedImg != null
                          ? Image.file(_selectedImg!.absolute, fit: BoxFit.cover,)
                          : const Icon(
                              Icons.image,
                              color: Color.fromARGB(255, 54, 12, 206),
                            ),
                    ),
                  ),
                ),

                //Button for Add Package....................................//.............................
                const SizedBox(
                  height: 25,
                ),
                GestureDetector(
                    onTap: ()  async{
                      if (_key.currentState?.validate() ?? false) {
                        setState(() {
                          loading = true;
                        });

                        await addPackage().then((value) {
                          setState(() {
                            loading = false;
                          });
                          Utills().toastMessage("Package Added Successfully...",
                              const Color.fromARGB(255, 54, 12, 206));
                        }).onError(
                          (error, stackTrace) {
                            Utills().toastMessage(error.toString(), Colors.red);
                            setState(() {
                              loading = false;
                            });
                          },
                        );
                      }
                    },
                    child: Center(
                        child: Button(
                            text: "Add Package",
                            loading: loading,
                            height: 50,
                            width: 250,
                            color: const Color.fromARGB(255, 54, 12, 206)))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
