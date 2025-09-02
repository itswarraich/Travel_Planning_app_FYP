// ignore_for_file: unnecessary_cast, must_be_immutable, file_names, sized_box_for_whitespace, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_planning_fyp/Widgets/BoldText.dart';
import 'package:travel_planning_fyp/Widgets/ModelClass.dart';

class Adminpackages extends StatefulWidget {
  String category;
  Adminpackages({super.key, required this.category});

  @override
  State<Adminpackages> createState() => _AdminpackagesState();
}

class _AdminpackagesState extends State<Adminpackages> {
  Future<void> deletePackages(String packageId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      await firestore
          .collection("Categories")
          .doc(widget.category)
          .collection("Packages")
          .doc(packageId)
          .delete();

      // Refresh the UI
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Boldtext(
            text: "Package Deleted Successfully...",
            color: Colors.white,
          ),
          backgroundColor: const Color.fromARGB(255, 54, 12, 206),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to delete package: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 14, bottom: 8),
      child: Container(
        height: MediaQuery.sizeOf(context).height * .72,
        width: double.maxFinite,
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("Categories")
                .doc(widget.category)
                .collection("Packages")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Boldtext(
                    text: "No Package Found...",
                    color: const Color.fromARGB(255, 54, 12, 206),
                    size: 14,
                  ),
                );
              }

              // Map Firestore documents to PackageList objects
              List<PackageList> packages = snapshot.data!.docs.map((doc) {
                var data = doc.data() as Map<String, dynamic>;
                return PackageList(
                  id: doc.id,
                  imgPath: data["ImageURL"] ?? "",
                  locationName: data["Location_Name"] ?? "Unkown",
                  description: data["Description"] ?? "Unkown",
                );
              }).toList();
              return Container(
                height: double.maxFinite,
                width: double.maxFinite,
                child: packages.isEmpty
                    ? Center(
                        child: Boldtext(
                          text: "No Package Found...",
                          color: const Color.fromARGB(255, 54, 12, 206),
                          size: 14,
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: packages.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Container(
                              height: 200,
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                        packages[index].imgPath,
                                      ),
                                      fit: BoxFit.cover)),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 150,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.location_on,
                                            color: Colors.white),
                                        Boldtext(
                                          text: packages[index]
                                              .locationName
                                              .toString(),
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () async {
                                            await deletePackages(
                                                packages[index].id.toString());
                                          },
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                            size: 33,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
              );
            }),
      ),
    );
  }
}
