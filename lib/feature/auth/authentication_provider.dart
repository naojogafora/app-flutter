import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trocado_flutter/api/api_helper.dart';
import 'package:trocado_flutter/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationProvider extends ChangeNotifier {
  static const LOGIN_URL = "auth/login";

  User user;
  String authenticationToken;
  ApiHelper apiHelper = ApiHelper();

  bool get isUserLogged => user != null;

  AuthenticationProvider(){
    loadAuthFromStorage();
  }

  Future<bool> login(BuildContext context, String email, String password) async {
    if (email.isEmpty || password.isEmpty || user != null) {
      return false;
    }

    final body = {
      'email': email,
      'password': password,
    };

    var responseJson = await apiHelper.post(context, LOGIN_URL, body: body);
    parseAndSetUser(responseJson);
    saveAuthToStorage(responseJson);
    notifyListeners();
    return true;
  }

  void parseAndSetUser(dynamic authJson) {
    user = User.fromJson(authJson['user']);
    authenticationToken = authJson['access_token'];
  }

  void saveAuthToStorage(dynamic authJson) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_json', jsonEncode(authJson));
  }

  void loadAuthFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String authPref = prefs.getString('auth_json');

    if(authPref == null || authPref.isEmpty){
      user = null;
      authenticationToken = null;
    } else {
      dynamic authJson = jsonDecode(authPref);
      parseAndSetUser(authJson);
    }

    notifyListeners();
  }

  void logout(BuildContext context){
    saveAuthToStorage(null);
    user = null;
    authenticationToken = null;
    notifyListeners();
  }
}
