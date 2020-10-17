import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trocado_flutter/api/api_helper.dart';
import 'package:trocado_flutter/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationProvider extends ChangeNotifier {
  static const LOGIN_URL = "auth/login";
  static const REFRESH_TOKEN_URL = "auth/refresh";
  static const LOGOUT_URL = "auth/logout";

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
    authenticationToken = authJson['access_token'];
    user = User.fromJson(authJson['user']);
  }

  void saveAuthToStorage(dynamic authJson) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_json', jsonEncode(authJson));
  }

  void loadAuthFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String authPref = prefs.getString('auth_json');

    if(authPref == null || authPref.isEmpty || authPref == "null"){
      user = null;
      authenticationToken = null;
    } else {
      dynamic authJson = jsonDecode(authPref);
      parseAndSetUser(authJson);
      Future.delayed(Duration(seconds: 5), () => refreshToken(authenticationToken));
    }

    notifyListeners();
  }

  void refreshToken(String currentToken) async {
    print("Refreshing token");
    var responseJson = await apiHelper.post(null, REFRESH_TOKEN_URL, token: currentToken);
    parseAndSetUser(responseJson);
    saveAuthToStorage(responseJson);
    print("Token refreshed");
  }

  void logout(BuildContext context){
    saveAuthToStorage(null);
    invalidateToken(authenticationToken);
    user = null;
    authenticationToken = null;
    notifyListeners();
  }

  void invalidateToken(String token){
    apiHelper.post(null, LOGOUT_URL, token: token);
  }
}
