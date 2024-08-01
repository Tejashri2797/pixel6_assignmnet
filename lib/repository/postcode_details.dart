import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../baseurl.dart';

class PostcodeDetailsRepo {
  static getCodeDetails(BuildContext context, int? code) async {
    var data = jsonEncode({"postcode": code});
    try {
      Uri uri = Uri.http(baseURL, "/api/get-postcode-details.php");
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