import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../modal/paninformation_modal.dart';
import '../repository/validate_pan_repo.dart';

class ValidatePanVm extends ChangeNotifier{
  List<PanInformationModal> panInfoList = [];
  bool isLoading = false;


Future<void>verifyPAN(BuildContext context, String? pan,Function(String) onSuccess)async{
   isLoading = true;
   notifyListeners();
   var data = await ValidatePanRepo.verifyPAN(context,pan);

   if(data!= null){
     final value = PanInformationModal.fromJson(data);
     panInfoList.add(value);
     isLoading = false;
     notifyListeners();
     onSuccess(value.fullName!);


  }
  else{
    Timer(const Duration(seconds: 1),(){
      isLoading = false;
      notifyListeners();
    });
  }




}


}