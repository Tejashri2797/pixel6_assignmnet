import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../baseurl.dart';

class ValidatePanRepo {
  static verifyPAN(BuildContext context, String? pan) async {
    var data = jsonEncode({"panNumber": pan});
    try {
      Uri uri = Uri.http(baseURL, "/api/verify-pan.php");
      http.Response response = await http.post(uri,
          headers: {'Content-Type': 'application/json'}, body: data);
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        return data;
      }
    }
    catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

}