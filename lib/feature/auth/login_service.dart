import 'package:trocado_flutter/api/api_helper.dart';

class LoginService {
  ApiHelper apiHelper = ApiHelper();
  static const LOGIN_URL = "auth/login";

  Future<dynamic> login(String email, String password) async{
    if(email.isEmpty || password.isEmpty){
      return false;
    }

    final body = {
      'email': email,
      'password': password,
    };

    var responseJson = await apiHelper.post(LOGIN_URL, body);
    return responseJson;
  }
}