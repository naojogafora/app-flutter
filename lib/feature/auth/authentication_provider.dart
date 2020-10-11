import 'package:flutter/material.dart';
import 'package:trocado_flutter/api/api_helper.dart';
import 'package:trocado_flutter/model/user.dart';

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

    var responseJson = await apiHelper.post(context, LOGIN_URL, body);
    parseAndSaveUser(responseJson);
    notifyListeners();
    return true;
  }

  void parseAndSaveUser(dynamic authJson) {
    user = User.fromJson(authJson['user']);
    authenticationToken = authJson['access_token'];
    saveAuthToStorage(authJson);
  }

  void saveAuthToStorage(dynamic authJson) {
    //TODO Save json to storage
  }

  void loadAuthFromStorage(){
    //TODO
    notifyListeners();
  }

  void logout(BuildContext context){
    saveAuthToStorage(null);
    user = null;
    authenticationToken = null;
    //TODO
    notifyListeners();
  }
}
