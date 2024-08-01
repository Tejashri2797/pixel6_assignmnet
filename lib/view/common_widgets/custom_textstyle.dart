import 'package:flutter/material.dart';

class CustomTextStyle {
  static TextStyle labelTextStyle(BuildContext context) {
    double height = MediaQuery.of(context).size.height /60;
    return TextStyle(
        color: Colors.black, fontSize: height, fontWeight: FontWeight.w500);
  }

  static TextStyle hintTextStyle(BuildContext context) {
    double height = MediaQuery.of(context).size.height / 67;
    return TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black45,
      fontSize: height,
    );
  }

  static TextStyle textFieldTextStyle(BuildContext context){
    double height = MediaQuery.of(context).size.height / 65;
    return TextStyle(
      fontSize: height,
      color: Colors.black,
    );
  }

  static TextStyle appBarTextStyle(BuildContext context) {
    double height = MediaQuery.of(context).size.height /45;
    return TextStyle(
        color: Colors.white, fontSize: height, fontWeight: FontWeight.bold);
  }

  static TextStyle detailsLabel(BuildContext context){
    double height = MediaQuery.of(context).size.height /60;
    return TextStyle(color: Colors.black, fontSize: height, fontWeight: FontWeight.bold);
  }
  static TextStyle detailsValue(BuildContext context){
    double height = MediaQuery.of(context).size.height /60;
    return TextStyle(color: Colors.black, fontSize: height,fontWeight: FontWeight.w500);
  }
}



