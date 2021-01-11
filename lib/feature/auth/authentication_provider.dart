import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';
import 'package:trocado_flutter/api/api_helper.dart';
import 'package:trocado_flutter/exception/FetchDataException.dart';
import 'package:trocado_flutter/exception/UnauthorizedException.dart';
import 'package:trocado_flutter/model/user.dart';
import 'package:trocado_flutter/response/basic_message_response.dart';

class AuthenticationProvider extends ChangeNotifier {
  static const LOGIN_URL = "auth/login";
  static const REFRESH_TOKEN_URL = "auth/refresh";
  static const LOGOUT_URL = "auth/logout";
  static const CHANGE_PASSWORD = "password/change";
  static const REQUEST_PASSWORD_RESET = "password/request_reset";
  static const RESET_PASSWORD = "password/reset";
  static const USER_UPDATE = "account/update";
  static const PHOTO_UPLOAD = "account/image";

  User user;
  String _authenticationToken;
  ApiHelper apiHelper = ApiHelper();

  Lock authTokenLock = Lock(reentrant: true);
  set authenticationToken(val) => authTokenLock.synchronized(() => this._authenticationToken = val);

  Future<String> get authenticationToken async {
    return await authTokenLock.synchronized<String>(() => this._authenticationToken);
  }

  bool get isUserLogged => user != null;

  AuthenticationProvider() {
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
    saveLogin(responseJson);
    return true;
  }

  void saveLogin(dynamic responseJson){
    parseAndSetUser(responseJson);
    saveAuthToStorage(responseJson);
    notifyListeners();
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

    if (authPref == null || authPref.isEmpty || authPref == "null") {
      user = null;
      authenticationToken = null;
    } else {
      dynamic authJson = jsonDecode(authPref);
      parseAndSetUser(authJson);
      await refreshToken();
    }

    notifyListeners();
  }

  Future<void> refreshToken() async {
    await authTokenLock.synchronized(() async {
      try {
        var responseJson =
            await apiHelper.post(null, REFRESH_TOKEN_URL, token: _authenticationToken);
        parseAndSetUser(responseJson);
        saveAuthToStorage(responseJson);
      } on FetchDataException catch (e) {
        if (e.httpCode == 500) {
          logout();
        }
      } on UnauthorizedException catch (e) {
        print(e.msg);
        logout();
      }
    });
    notifyListeners();
  }

  void logout() async {
    saveAuthToStorage(null);
    invalidateCurrentToken();
    user = null;
    authenticationToken = null;
    notifyListeners();
  }

  void invalidateCurrentToken() {
    try {
      apiHelper.post(null, LOGOUT_URL, token: _authenticationToken);
    } catch (e) {
      //
    }
  }

  Future<BasicMessageResponse> updateProfile(BuildContext context, User user) async {
    var response = await apiHelper.post(context, USER_UPDATE, body: user.toJson());
    User updatedUser = User.fromJson(response);
    this.user = updatedUser;
    notifyListeners();
    return BasicMessageResponse("Usuário atualizado", success: true);
  }

  Future<BasicMessageResponse> changePassword(
      BuildContext context, String oldPassword, String newPassword) async {
    var response = await apiHelper.post(context, CHANGE_PASSWORD,
        body: {'old_password': oldPassword, 'new_password': newPassword});
    return BasicMessageResponse.fromJson(response);
  }

  Future<BasicMessageResponse> requestPasswordReset(BuildContext context, String email) async {
    var response = await apiHelper.post(context, REQUEST_PASSWORD_RESET, body: {'email': email});
    return BasicMessageResponse.fromJson(response);
  }

  Future<BasicMessageResponse> resetPassword(
      BuildContext context, String email, String code, String newPassword) async {
    var response = await apiHelper.post(context, RESET_PASSWORD, body: {
      'email': email,
      'code': code,
      'new_password': newPassword,
    });
    return BasicMessageResponse.fromJson(response);
  }

  Future<String> uploadProfileImage(BuildContext context, File image) async {
    List<http.MultipartFile> files = [];
    files.add(http.MultipartFile.fromBytes("photo", image.readAsBytesSync(),
        filename: apiHelper.getFileName(image.path),
        contentType: apiHelper.getMediaTypeFromFile(image.path)));
    var response = await apiHelper.multipartRequest(context, PHOTO_UPLOAD, multipartFiles: files);
    user.profilePhotoUrl = response["profile_photo_url"];
    notifyListeners();
    return user.profilePhotoUrl;
  }
}
