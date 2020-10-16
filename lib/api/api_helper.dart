import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:trocado_flutter/exception/BadRequestException.dart';
import 'package:trocado_flutter/exception/FetchDataException.dart';
import 'package:trocado_flutter/exception/UnauthorizedException.dart';
import 'dart:convert';
import 'dart:async';

import 'package:trocado_flutter/feature/auth/authentication_provider.dart';

class ApiHelper {
  static const _baseUrl = "https://trocado-api.herokuapp.com/api/";

  Future<dynamic> get(BuildContext context, String url) async {
    print('Api Get, url $url');
    var responseJson;
    var headers = {'Accept': 'Application/json'};

    if(context != null && Provider.of<AuthenticationProvider>(context, listen: false).authenticationToken != null) {
      headers.addAll({'Authorization': "Bearer " + Provider
          .of<AuthenticationProvider>(context, listen: false)
          .authenticationToken});
    }

    try {
      final response = await http.get(_baseUrl + url, headers: headers);
      responseJson = _returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> post(BuildContext context, String url, {Map<String, dynamic> body, String token}) async {
    print('Api Post, url $url');
    var responseJson;
    var headers = {'Accept': 'Application/json'};

    if(token != null){
      headers.addAll({'Authorization': "Bearer " + token});
    } else if(context != null && Provider.of<AuthenticationProvider>(context, listen: false).authenticationToken != null)
      headers.addAll({'Authorization': "Bearer " + Provider.of<AuthenticationProvider>(context, listen: false).authenticationToken});

    try {
      final response = await http.post(_baseUrl + url, body: body, headers: headers);
      responseJson = _returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> delete(BuildContext context, String url) async {
    var responseJson;
    var headers = {'Accept': 'Application/json'};

    if(context != null && Provider.of<AuthenticationProvider>(context, listen: false).authenticationToken != null)
      headers.addAll({'Authorization': "Bearer " + Provider.of<AuthenticationProvider>(context, listen: false).authenticationToken});

    try{
      final response = await http.delete(url);
      responseJson = _returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorizedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}