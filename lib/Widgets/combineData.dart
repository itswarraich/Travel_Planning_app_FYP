// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class CombinedData {
  final List<QueryDocumentSnapshot> packages;
  final List<dynamic> favourites;

  CombinedData({required this.packages, required this.favourites});
}