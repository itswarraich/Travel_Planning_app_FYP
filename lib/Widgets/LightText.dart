// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';

class Lighttext extends StatelessWidget {
  double size;
  final String text;
  final String font;
  Color color;
  TextOverflow textOverflow;
  Lighttext({super.key,
  this.textOverflow=TextOverflow.ellipsis,
  this.font="font30",
  this.size=20,
  this.color=Colors.white,
  required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      maxLines: 10,
      overflow: textOverflow,
      text,
      textAlign: TextAlign.justify,
      style: TextStyle(
        
        fontSize: size, color: color,fontFamily: font),
    );
  }
}