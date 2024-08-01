import 'package:flutter/material.dart';
import 'package:pixel6_assignment/view/customer_registration.dart';
import 'package:pixel6_assignment/view_modal/postcode_details_vm.dart';
import 'package:pixel6_assignment/view_modal/validatepan_vm.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => ValidatePanVm()),
    ChangeNotifierProvider(create: (_)=>PostcodeDetailsVm())],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.blue,
        appBarTheme: const AppBarTheme(
          color:Color(0xFF3820F0),
        ),
      ),
      home:  CustomerRegistration(),
    ),
  ));
}
