import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:synchronized/synchronized.dart';
import 'package:trocado_flutter/api/api_helper.dart';
import 'package:trocado_flutter/exception/FetchDataException.dart';
import 'package:trocado_flutter/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationProvider extends ChangeNotifier {
  static const LOGIN_URL = "auth/login";
  static const REFRESH_TOKEN_URL = "auth/refresh";
  static const LOGOUT_URL = "auth/logout";

  User user;
  String _authenticationToken;
  ApiHelper apiHelper = ApiHelper();

  Lock authTokenLock = Lock(reentrant: true);
  set authenticationToken(val) => authTokenLock.synchronized(() => this._authenticationToken = val);
  Future<String> get authenticationToken async {
    return await authTokenLock.synchronized<String>(() => this._authenticationToken);
  }

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

  Future<void> loadAuthFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String authPref = prefs.getString('auth_json');

    if(authPref == null || authPref.isEmpty || authPref == "null"){
      user = null;
      authenticationToken = null;
    } else {
      dynamic authJson = jsonDecode(authPref);
      parseAndSetUser(authJson);
      refreshToken();
    }

    notifyListeners();
  }

  Future<void> refreshToken() async {
    print("Refreshing token");
    authTokenLock.synchronized(() async {
      print("Refreshing inside sync");
      try {
        var responseJson = await apiHelper.post(
            null, REFRESH_TOKEN_URL, token: _authenticationToken);
        parseAndSetUser(responseJson);
        saveAuthToStorage(responseJson);
        print("Token refreshed");
      } on FetchDataException catch (e) {
        if(e.httpCode == 500) {
          saveAuthToStorage(null);
        }
      }
    });
    notifyListeners();
  }

  void logout(BuildContext context) async {
    saveAuthToStorage(null);
    await invalidateCurrentToken();
    user = null;
    authenticationToken = null;
    notifyListeners();
  }

  Future<void> invalidateCurrentToken() async {
    apiHelper.post(null, LOGOUT_URL, token: _authenticationToken);
  }
}
