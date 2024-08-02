import 'package:flutter/material.dart';

import 'custom_textstyle.dart';

Widget commonLabel(BuildContext context, String label) => RichText(
    text: TextSpan(
        text: label,
        style: CustomTextStyle.labelTextStyle(context),
        children: const <TextSpan>[
          TextSpan(text: "*", style: TextStyle(color: Colors.redAccent))
        ]));

Widget commonButton(BuildContext context,String name)=>
    Container(
      height: MediaQuery.of(context).size.height/24,
      width:   MediaQuery.of(context).size.width/2.5,
      decoration:  BoxDecoration(
          color: const Color.fromRGBO(115, 103, 240, 1),
          borderRadius: BorderRadius.circular(10)),
      child: Center(child: Text(name,
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.height /55),)),
    );


Widget commonDetailText(BuildContext context, String label,String value) => RichText(
    text: TextSpan(
        text: label,
        style: CustomTextStyle.detailsLabel(context),
        children:  <TextSpan>[
          TextSpan(text: value, style: CustomTextStyle.detailsValue(context),)
        ]));