// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore, sized_box_for_whitespace, no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_planning_fyp/UIScreens/DetailedScreen.dart';
import 'package:travel_planning_fyp/Utills/utills.dart';
import 'package:travel_planning_fyp/Widgets/BoldText.dart';
import 'package:travel_planning_fyp/Widgets/ModelClass.dart';
import 'package:rxdart/rxdart.dart';
import 'package:travel_planning_fyp/Widgets/combineData.dart';

class Packagelistile extends StatefulWidget {
  final String category; // Pass the selected category as a parameter
  final String searching; // pass the package searching parameter
  const Packagelistile(
      {super.key, required this.category, required this.searching});

  @override
  State<Packagelistile> createState() => _PackagelistileState();
}

class _PackagelistileState extends State<Packagelistile> {
  List<dynamic> favouritePackageId = []; // Track favourite Package Id
  late Stream<CombinedData> _combinedStream;

  @override
  void initState() {
    super.initState();
    _combinedStream = CombineLatestStream.combine2(
      getFilteredPackages(widget.searching), // First stream: Packages
      fetchFavouritePkg(), // Second stream: Favourites
      (QuerySnapshot packagesSnapshot, List<String> favourites) {
        return CombinedData(
          packages: packagesSnapshot.docs,
          favourites: favourites,
        );
      },
    );
  }

  Stream<List<String>> fetchFavouritePkg() async* {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? user = _auth.currentUser;
  if (user == null) {
    Utills().toastMessage("You are not logged in!", Colors.red);
    yield []; // Emit an empty list if the user is not logged in
    return;
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  QuerySnapshot snapshot = await firestore
      .collection("Favourites")
      .doc(user.uid)
      .collection("Packages")
      .get();

  // Update the favouritePackageId list
  setState(() {
    favouritePackageId = snapshot.docs.map((doc) => doc.id).toList();
  });

  yield snapshot.docs.map((doc) => doc.id).toList(); // Emit the list of favourite package IDs
}
  // Stream to fetch filtered packages
  Stream<QuerySnapshot> getFilteredPackages(String searchQuery) {
    return FirebaseFirestore.instance
        .collection("Categories")
        .doc(widget.category)
        .collection("Packages")
        .snapshots();
  }


 Future<void> toggleFavouritePackage(PackageList package) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? user = _auth.currentUser;
  if (user == null) {
    Utills().toastMessage("User not logged in", Colors.red);
    return;
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Reference to the user's favourites collection
  DocumentReference favDoc = firestore
      .collection("Favourites")
      .doc(user.uid)
      .collection("Packages")
      .doc(package.id);

  if (favouritePackageId.contains(package.id)) {
    // Remove from favourites
    await favDoc.delete();
    setState(() {
      favouritePackageId.remove(package.id); // Update the list
    });
    Utills().toastMessage(
        "Removed from Favourite", const Color.fromARGB(255, 54, 12, 206));
  } else {
    // Add to favourites
    await favDoc.set({
      "Category": widget.category,
      "Location_Name": package.locationName,
      "Description": package.description,
      "ImageURL": package.imgPath,
    });
    setState(() {
      favouritePackageId.add(package.id); // Update the list
    });
    Utills().toastMessage(
        "Added to Favourite", const Color.fromARGB(255, 54, 12, 206));
  }
}
 @override
Widget build(BuildContext context) {
  return Container(
    height: 260,
    width: double.maxFinite,
    child: StreamBuilder<CombinedData>(
      stream: _combinedStream, // Use the combined stream here
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.packages.isEmpty) {
          return Center(
              child: Boldtext(
                  text: "No Package Found...",
                  color: const Color.fromARGB(255, 54, 12, 206),
                  size: 14));
        }

        final packages = snapshot.data!.packages;
        //final favourites = snapshot.data!.favourites;

        // Map Firestore documents to PackageList objects
        List<PackageList> packageList = packages.map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          return PackageList(
            id: doc.id,
            imgPath: data["ImageURL"] ?? "",
            locationName: data["Location_Name"] ?? "",
            description: data["Description"] ?? "",
            isFavourite: favouritePackageId.contains(doc.id), // Use favouritePackageId directly
          );
        }).toList();

        // Filter packages based on search query
        List<PackageList> filteredPackages = widget.searching.isEmpty
            ? packageList
            : packageList
                .where((package) =>
                    (package.locationName != null &&
                        package.locationName!
                            .toLowerCase()
                            .contains(widget.searching.toLowerCase())))
                .toList();

        // Build the ListView
        return Container(
            height: 260,
            width: double.maxFinite,
            child: filteredPackages.isEmpty
                ? Center(
                    child: Boldtext(
                        text: "No Package Found...",
                        color: const Color.fromARGB(255, 54, 12, 206),
                        size: 14))
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: filteredPackages.length,
                    itemBuilder: (context, index) {
                      final package = filteredPackages[index];
                      final isFavourite = favouritePackageId.contains(package.id); // Use favouritePackageId directly
                      return Padding(
                        padding: const EdgeInsets.only(right: 7),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Detailedscreen(
                                  imgPath: package.imgPath,
                                  tittle: package.locationName.toString(),
                                  descriptionpkg: package.description,
                                  id: package.id.toString(),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 260,
                            width: 170,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: NetworkImage(package.imgPath),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, left: 120),
                                  child: GestureDetector(
                                    onTap: () {
                                      toggleFavouritePackage(package); // Call the method here
                                    },
                                    child: Container(
                                      height: 35,
                                      width: 35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          width: 2,
                                          color: Colors.white,
                                        ),
                                      ),
                                      child: isFavourite
                                          ? const Icon(Icons.favorite,
                                              color: Colors.red) // Filled heart for favourite
                                          : const Icon(Icons.favorite_outline,
                                              color: Colors.white), // Outlined heart for non-favourite
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 165),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 5, right: 5, top: 15),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.location_on,
                                          color: Colors.white),
                                      Boldtext(
                                        text: package.locationName.toString(),
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ));
      },
    ),
  );
}
}