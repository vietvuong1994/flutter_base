import 'dart:convert';
import 'dart:io';
import 'package:DJCloud/commons/constant.dart';
import 'package:DJCloud/commons/dialogs.dart';
import 'package:DJCloud/commons/http/appException.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiBaseHelper {
  final String _baseUrl = "http://upload.djcloud.vn/api/v1/";
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  Future<dynamic> get(BuildContext context, String url) async {
    var responseJson;
    Dialogs.showLoadingDialog(context, _keyLoader);
    try {
      final response = await http
          .get(_baseUrl + url)
          .timeout(Duration(seconds: REQUEST_TIME_OUT));
      responseJson = _returnResponse(response);
    } on SocketException {
      print('No net');
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      throw FetchDataException('No Internet connection');
    }
    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
    print('api get receive');
    return responseJson;
  }

  Future<dynamic> post(BuildContext context, String url,
      {Map body, Map header}) async {
    final Map<String, String> defaultHeader = {
      'Content-Type': 'application/json',
    };
    final Map<String, dynamic> defaultBody = {};

    final Map<String, dynamic> headerData =
        header != null ? {...defaultHeader, ...header} : defaultHeader;
    final Map<String, dynamic> bodyData = body != null ? body : defaultBody;

    var responseJson;
    Dialogs.showLoadingDialog(context, _keyLoader);
    try {
      final response = await http
          .post(_baseUrl + url, headers: headerData, body: jsonEncode(bodyData))
          .timeout(Duration(seconds: REQUEST_TIME_OUT));
      responseJson = _returnResponse(response);
    } on SocketException {
      print('No net');
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      throw FetchDataException('No Internet connection');
    }
    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
    print('api post response');
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
