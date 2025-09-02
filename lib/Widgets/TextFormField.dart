// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';

class Textformfield1 extends StatelessWidget {
  Textformfield1({
    super.key,
    required this.hintName,
    required this.maxlength,
    required this.keyboard,
    this.formKey,
    this.validator1,
    this.icon,
    required this.hideText,
    required this.controller,
    this.fillColor,
    this.filled,
    this.hintColor,
    this.styleColor,
    this.borderRadious = 20,
    required this.borderColor,
    this.focusborderColor = Colors.white,
    this.heightpadding = 17,
    this.isdropDown = false,
    this.dropDownItems,
    this.readonly = false,
    this.onchange,
    this.itemColor=Colors.grey,
  });

  String hintName;
  final int maxlength;
  final TextInputType keyboard;
  final GlobalKey<FormState>? formKey;
  final String? Function(String?)? validator1;
  final Icon? icon;
  final bool hideText;
  final TextEditingController? controller;
  final Color? fillColor;
  final bool? filled;
  final Color? hintColor;
  final Color? styleColor;
  final double borderRadious;
  final Color borderColor;
  final Color focusborderColor;
  final double heightpadding;
  final bool isdropDown;
  final List<dynamic>? dropDownItems;
  final bool readonly;
  final Function(dynamic)? onchange;
  final Color itemColor;

  @override
  Widget build(BuildContext context) {
    return isdropDown
        ? DropdownButtonFormField<dynamic>(
            value: (controller!.text.isNotEmpty &&
                    dropDownItems!.contains(controller!.text))
                ? controller!.text
                : dropDownItems!.first,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: heightpadding),
              filled: filled,
              fillColor: fillColor,
              hintText: hintName,
              hintStyle: TextStyle(color: hintColor),
              prefixIcon: icon,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadious),
                borderSide: BorderSide(width: 2, color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadious),
                borderSide: BorderSide(width: 2, color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadious),
                borderSide: BorderSide(width: 2, color: focusborderColor),
              ),
            ),
            items: dropDownItems?.asMap().entries.map((entry) {
              final index = entry.key;
              final value = entry.value;

              return DropdownMenuItem<dynamic>(
                value: value,
                child: Text(
                  value.toString(),
                  style: TextStyle(
                    color: index == 0 ? itemColor : styleColor,
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              controller!.text = value
                  .toString(); // This correctly converts the int value to string
              if (onchange != null) {
                onchange!(
                    value!); // Pass the int value to the onchange callback
              }
            },
          )
        : TextFormField(
            maxLines: maxlength,
            cursorColor: borderColor,
            style: TextStyle(color: styleColor),
            readOnly: readonly,
            controller: controller,
            obscureText: hideText,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: heightpadding),
              filled: filled,
              fillColor: fillColor,
              hintText: hintName,
              hintStyle: TextStyle(color: hintColor),
              prefixIcon: icon,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadious),
                borderSide: BorderSide(width: 2, color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadious),
                borderSide: BorderSide(width: 2, color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadious),
                borderSide: BorderSide(width: 2, color: focusborderColor),
              ),
            ),
            validator: validator1,
            onChanged: onchange,
          );
  }
}
