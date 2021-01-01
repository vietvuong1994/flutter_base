import 'package:DJCloud/commons/http/apiBaseHelper.dart';
import 'package:flutter/material.dart';

class ApiUtils {
  static final sampleApi = 'https://jsonplaceholder.typicode.com/posts';

  Future<dynamic> callApiExample(
      BuildContext context) async {
    var result = await ApiBaseHelper().get(context, sampleApi);
    return result;
  }
}