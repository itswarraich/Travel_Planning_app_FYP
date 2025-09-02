// ignore_for_file: sized_box_for_whitespace, file_names


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_planning_fyp/Widgets/BoldText.dart';
import 'package:travel_planning_fyp/Widgets/PackageListile.dart';

class Namelistile extends StatefulWidget {
  const Namelistile({super.key, required this.searchQuery});
  final String searchQuery;

  @override
  State<Namelistile> createState() => _NamelistileState();
}

class _NamelistileState extends State<Namelistile> {
  List<dynamic> categories = [];
  List<String> name = ["Family", "Friends", "Honeymoon", "Group"];
  int selectedIndex = 0;
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  // Fetch categories once when the widget is first built
  Future<void> fetchCategories() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    List<String> fetchedCategories = [];

    for (String category in name) {
      QuerySnapshot snapshot = await firestore
          .collection("Categories")
          .doc(category)
          .collection("Packages")
          .get();

      if (snapshot.docs.isNotEmpty) {
        fetchedCategories.add(category);
      }
    }

    setState(() {
      categories = fetchedCategories;
      isLoading = false; // Mark loading as complete
    });
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Reset selectedIndex if out of bounds
    if (selectedIndex >= categories.length) {
      selectedIndex = 0;
    }

    return Column(
      children: [
        // Category selection bar
        Container(
          height: 40,
          width: double.maxFinite,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 7),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index; // Update the selected index
                    });
                  },
                  child: Container(
                    height: 40,
                    width: 130,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selectedIndex == index
                            ? const Color(0xFFE040FB) // Selected border color
                            : const Color.fromARGB(255, 54, 12, 206), // Unselected border color
                      ),
                      borderRadius: BorderRadius.circular(30),
                      gradient: selectedIndex == index
                          ? const LinearGradient(
                              colors: [Color(0xFF9C27B0), Color(0xFFE040FB)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            )
                          : null, // No gradient for unselected
                      color: selectedIndex == index
                          ? null
                          : Colors.white, // White background for unselected
                    ),
                    child: Center(
                      child: Boldtext(
                        text: categories[index].toString(),
                        color: selectedIndex == index
                            ? Colors.white // Selected text color
                            : const Color.fromARGB(255, 54, 12, 206), // Unselected text color
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        // Display the selected package widget
        const SizedBox(height: 30),
        categories.isNotEmpty
            ? Packagelistile(
                key: ValueKey(categories[selectedIndex] + widget.searchQuery),
                category: categories[selectedIndex],
                searching: widget.searchQuery,
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





//Future builder by getting category according ot the package search.................

// class Namelistile extends StatefulWidget {
//   const Namelistile({super.key, required this.searchQuery});
//   final String searchQuery;

//   @override
//   State<Namelistile> createState() => _NamelistileState();
// }

// class _NamelistileState extends State<Namelistile> {
//   List<String> name = ["Family", "Friends", "Honeymoon", "Group"];
//   int selectedIndex = 0;

//   // Fetch categories that contain packages matching the search query (case-insensitive)
//   Future<List<String>> getFilteredCategories(String searchQuery) async {
//     FirebaseFirestore firestore = FirebaseFirestore.instance;
//     List<String> filteredCategories = [];

//     for (String category in name) {
//       QuerySnapshot snapshot = await firestore
//           .collection("Categories")
//           .doc(category)
//           .collection("Packages")
//           .get();

//       // Perform case-insensitive filtering locally
//       bool hasMatchingPackage = snapshot.docs.any((doc) {
//         var data = doc.data() as Map<String, dynamic>;
//         String locationName = data["Location_Name"] ?? "";
//         return locationName.toLowerCase().contains(searchQuery.toLowerCase());
//       });

//       if (hasMatchingPackage) {
//         filteredCategories.add(category);
//       }
//     }

//     return filteredCategories;
//   }

//   @override
//   Widget build(BuildContext context) {
//     debugPrint("Search Query in Namelistile: ${widget.searchQuery}");
//     return FutureBuilder<List<String>>(
//       future: getFilteredCategories(widget.searchQuery), // Re-fetch categories when searchQuery changes
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         }

//         if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return Center(
//             child: Boldtext(
//               text: "No Categories Found",
//               size: 11,
//               color: const Color.fromARGB(255, 54, 12, 206),
//             ),
//           );
//         }

//         List<String> filteredCategories = snapshot.data!;

//         // Reset selectedIndex if out of bounds
//         if (selectedIndex >= filteredCategories.length) {
//           selectedIndex = 0;
//         }

//         return Column(
//           children: [
//             // Category selection bar
//             Container(
//               height: 40,
//               width: double.maxFinite,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: filteredCategories.length,
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: const EdgeInsets.only(right: 7),
//                     child: GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           selectedIndex = index; // Update the selected index
//                         });
//                       },
//                       child: Container(
//                         height: 40,
//                         width: 130,
//                         decoration: BoxDecoration(
//                           border: Border.all(
//                             color: selectedIndex == index
//                                 ? const Color(0xFFE040FB) // Selected border color
//                                 : const Color.fromARGB(255, 54, 12, 206), // Unselected border color
//                           ),
//                           borderRadius: BorderRadius.circular(30),
//                           gradient: selectedIndex == index
//                               ? const LinearGradient(
//                                   colors: [Color(0xFF9C27B0), Color(0xFFE040FB)],
//                                   begin: Alignment.centerLeft,
//                                   end: Alignment.centerRight,
//                                 )
//                               : null, // No gradient for unselected
//                           color: selectedIndex == index
//                               ? null
//                               : Colors.white, // White background for unselected
//                         ),
//                         child: Center(
//                           child: Boldtext(
//                             text: filteredCategories[index].toString(),
//                             color: selectedIndex == index
//                                 ? Colors.white // Selected text color
//                                 : const Color.fromARGB(255, 54, 12, 206), // Unselected text color
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             // Display the selected package widget
//             const SizedBox(height: 30),
//             filteredCategories.isNotEmpty
//                 ? Packagelistile(
//                     key: ValueKey(filteredCategories[selectedIndex] + widget.searchQuery),
//                     category: filteredCategories[selectedIndex],
//                     searching: widget.searchQuery,
//                   )
//                 : Center(
//                     child: Boldtext(
//                       text: "No Package Found",
//                       size: 11,
//                       color: const Color.fromARGB(255, 54, 12, 206),
//                     ),
//                   ),
//           ],
//         );
//       },
//     );
//   }
// }
