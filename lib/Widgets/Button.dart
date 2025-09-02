// ignore_for_file: prefer_const_constructors_in_immutables, must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:travel_planning_fyp/Widgets/BoldText.dart';

class Button extends StatelessWidget {
   Button({super.key,
   required this.text,
   required this.height,
   required this.width,
   required this.color,
   this.ontap,
   this.loading=false});

   final String text;
   final double height;
   final double width;
   final Color color;
   final VoidCallback? ontap;
   final bool loading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color:color,
          borderRadius: BorderRadius.circular(20)
        ),
        child: Center(child: loading?const  CircularProgressIndicator(color: Colors.yellow, strokeWidth: 3,):
        Boldtext(text: text, color: Colors.yellow,)),
      
      ),
    );
  }
}