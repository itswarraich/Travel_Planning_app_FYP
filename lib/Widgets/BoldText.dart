// ignore_for_file: file_names

import 'package:flutter/material.dart';


// ignore: must_be_immutable
class Boldtext extends StatelessWidget {
  double size;
  final String font;
  final String text;
  final Color? color;
  final TextAlign? align;
  final TextOverflow? textOverflow;
  final TextDecoration? decoration;


Boldtext({super.key,
  this.size=20,
  this.align,
  this.textOverflow=TextOverflow.ellipsis,
  this.font="font30",
  this.color,
  required this.text,
  this.decoration});

  @override
  Widget build(BuildContext context) {
    return  Text(overflow: textOverflow,
    text,
    textAlign: align,
    style: TextStyle(fontWeight: FontWeight.bold,
    fontSize: size,
    color: color,
    fontFamily: font,decoration:decoration),);
  }
}