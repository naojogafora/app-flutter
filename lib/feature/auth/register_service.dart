import 'package:trocado_flutter/api/api_helper.dart';

class RegisterService {
  ApiHelper apiHelper = ApiHelper();
  static const REGISTER_URL = "signup";

  Future<dynamic> register(String name, String lastName, String email, String password) async{
    if(name.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty){
      return false;
    }

    final body = {
      'name': name,
      'last_name': lastName,
      'email': email,
      'password': password,
    };

    print(body);
    var responseJson = await apiHelper.post(REGISTER_URL, body);
    return responseJson;
  }
}