// ignore_for_file: sized_box_for_whitespace, must_be_immutable, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_planning_fyp/Widgets/BoldText.dart';
import 'package:travel_planning_fyp/Widgets/adminPackages.dart';

class Admincategory extends StatefulWidget {
  const Admincategory({super.key});

  @override
  State<Admincategory> createState() => _AdmincategoryState();
}

class _AdmincategoryState extends State<Admincategory> {
  List<String> categories = [];
  int selectedIndex = 0;
  bool isloading = false;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  // Fetch categories from Firestore
  Future<void> fetchCategories() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Fetch all documents from the "Categories" collection
      QuerySnapshot snapshot = await firestore.collection("Categories").get();

      // Extract category names from the documents
      List<String> fetchedCategories = [];
      for (var doc in snapshot.docs) {
        fetchedCategories
            .add(doc.id); // Assuming document IDs are category names
      }

      setState(() {
        categories = fetchedCategories;
        isloading = false; // Mark loading as complete
      });
    } catch (e) {
      debugPrint("Error fetching categories: $e");
      setState(() {
        isloading = false; // Mark loading as complete even if there's an error
      });
    }
  }

  Future<void> deleteCategoris(String category) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      QuerySnapshot snapshot = await firestore
          .collection("Categories")
          .doc(category)
          .collection("Packages")
          .get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
      //Delete category itself
      await firestore.collection("Categories").doc(category).delete();
      //Refresh the UI
      fetchCategories();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Boldtext(
          text: "Category Deleted Successfully...",
          color: Colors.white,
        ),
        backgroundColor: const Color.fromARGB(255, 54, 12, 206),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to delete category: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isloading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Reset selectedIndex if out of bounds
    if (selectedIndex >= categories.length) {
      selectedIndex = 0;
    }
    return Column(
      children: [
        Container(
          height: 70,
          width: double.maxFinite,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                        height: 70,
                        width: 140,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: selectedIndex == index
                                ? const Color(
                                    0xFFE040FB) // Selected border color
                                : const Color.fromARGB(255, 54, 12,
                                    206), // Unselected border color
                          ),
                          borderRadius: BorderRadius.circular(30),
                          gradient: selectedIndex == index
                              ? const LinearGradient(
                                  colors: [
                                    Color(0xFF9C27B0),
                                    Color(0xFFE040FB)
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                )
                              : null,

                          color: selectedIndex == index
                              ? null
                              : Colors.white, // White background for unselected
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 8),
                          child: Row(
                            children: [
                              //Text inside Container mean Category Name...................................
                              Center(
                                  child: Boldtext(
                                text: categories[index].toString(), size: 17,
                                color: selectedIndex == index
                                    ? Colors.white // Selected text color
                                    : const Color.fromARGB(255, 54, 12,
                                        206), // Unselected text color,
                              )),

                              //Delete Icon................................................................
                              const Spacer(),
                              GestureDetector(
                                  onTap: () async {
                                    await deleteCategoris(categories[index]);
                                  },
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 25,
                                  )),
                            ],
                          ),
                        )),
                  ),
                );
              }),
        ),
        const SizedBox(
          height: 20,
        ),
        categories.isNotEmpty
            ? Adminpackages(
                category: categories[selectedIndex],
              )
            : Center(
                child: Boldtext(
                  text: "No Package Found",
                  size: 11,
                  color: const Color.fromARGB(255, 54, 12, 206),
                ),
              ),
      ],
    );
  }
}
