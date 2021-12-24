import 'package:flutter/material.dart';

const Color bluishClr = Color(0xFF4e5ae8);
const Color yellowClr = Color(0xFFFF8746);
const Color pinkClr = Color(0xFFff4667);
const Color white = Colors.white;
const Color primaryClr = bluishClr;
const Color darkGreyClr = Color(0xFF121212);
// ignore: prefer_const_constructors
Color darkHeadClr = Color(0xFF424242);

class Themes{
  static final light = ThemeData(
        primaryColor: primaryClr,
        brightness: Brightness.light
      );
  static final dark = ThemeData(
        primaryColor: darkGreyClr,
        brightness: Brightness.dark
      );
}