// ignore_for_file: file_names


class PackageList{

  String imgPath;
  String? locationName;
  String? description;
  String id;
  final bool isFavourite;

  PackageList({ required this.imgPath,
  this.locationName,
  this.description,
  required this.id,
  this.isFavourite=false});

}

