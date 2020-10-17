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
    String fullUrl = _baseUrl + url;
    var responseJson;
    var headers = {'Accept': 'Application/json'};
    print('Api Get, url $fullUrl');

    if (context != null &&
        Provider.of<AuthenticationProvider>(context, listen: false)
                .authenticationToken !=
            null) {
      headers.addAll({
        'Authorization': "Bearer " +
            Provider.of<AuthenticationProvider>(context, listen: false)
                .authenticationToken
      });
    }

    try {
      final response = await http.get(fullUrl, headers: headers);
      responseJson = _returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> post(BuildContext context, String url,
      {Map<String, dynamic> body = const {}, String token, Map<String, String> extraHeaders}) async {
    String fullUrl = _baseUrl + url;
    var responseJson;
    var headers = {'Accept': 'Application/json'};
    print('Api Post, url $fullUrl');

    if (token != null) {
      headers.addAll({'Authorization': "Bearer " + token});
    } else if (context != null) {
      String savedToken =
          Provider.of<AuthenticationProvider>(context, listen: false)
              .authenticationToken;
      if (savedToken != null) {
        headers.addAll({'Authorization': "Bearer " + savedToken});
      }
    }

    try {
      final response =
          await http.post(fullUrl, body: body, headers: headers);
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

    if (context != null &&
        Provider.of<AuthenticationProvider>(context, listen: false)
                .authenticationToken !=
            null)
      headers.addAll({
        'Authorization': "Bearer " +
            Provider.of<AuthenticationProvider>(context, listen: false)
                .authenticationToken
      });

    try {
      final response = await http.delete(_baseUrl + url, headers: headers);
      responseJson = _returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    dynamic responseJson;
    String message;

    try {
      responseJson = json.decode(response.body.toString());
      print(responseJson);

      if (responseJson != null && responseJson['message'] != null)
        message = responseJson['message'].toString();
    } catch (e) {}

    switch (response.statusCode) {
      case 200:
        return responseJson;
      case 400:
        throw BadRequestException(message);
      case 401:
      case 403:
        throw UnauthorizedException(message);
      case 500:
      default:
        throw FetchDataException(
            'Request Error (code ${response.statusCode}). ' +
                message?.toString());
    }
  }
}
