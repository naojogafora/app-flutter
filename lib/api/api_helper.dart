import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:trocado_flutter/exception/BadRequestException.dart';
import 'package:trocado_flutter/exception/FetchDataException.dart';
import 'package:trocado_flutter/exception/UnauthorizedException.dart';
import 'dart:convert';
import 'dart:async';

class ApiHelper {
  static const _baseUrl = "https://trocado-api.herokuapp.com/api/";

  Future<dynamic> get(String url) async {
    print('Api Get, url $url');
    var responseJson;
    var headers = {'Accept': 'Application/json'};

    try {
      final response = await http.get(_baseUrl + url, headers: headers);
      responseJson = _returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> post(String url, Map<String, dynamic> body) async {
    print('Api Post, url $url');
    var headers = {'Accept': 'Application/json'};
    var responseJson;

    try {
      final response = await http.post(_baseUrl + url, body: body, headers: headers);
      responseJson = _returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }
}

  dynamic _returnResponse(http.Response response) {
    print("Respnse body:");
    print(response.body.toString());
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
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