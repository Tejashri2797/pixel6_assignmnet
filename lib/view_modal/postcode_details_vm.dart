import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pixel6_assignment/modal/postcode_details_modal.dart';
import '../repository/postcode_details.dart';

class PostcodeDetailsVm extends ChangeNotifier{
  List<PostCodeDetailsModal> postDetailsList = [];
  String? city;
  String? state;
  bool isLoading = false;
  Future<void>getPostDetails(BuildContext context, int? code,Function(String, String) onSuccess)async{
    isLoading = true;
    notifyListeners();
    var data = await PostcodeDetailsRepo.getCodeDetails(context,code ,);

    if(data!= null){
     final value = PostCodeDetailsModal.fromJson(data);
     postDetailsList.add(value);
      isLoading = false;
      notifyListeners();
     postDetailsList.forEach((v){
       v.city?.forEach((v){
         city = v.name;
       });
       v.state?.forEach((v){
         state = v.name;
       });

     });
     if (city != null && state != null) {
       onSuccess(city!, state!);
     }


    }



    else{
      Timer(const Duration(seconds: 1),(){
        isLoading = false;
        notifyListeners();
      });
    }





  }


}