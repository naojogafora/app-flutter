import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trocado_flutter/api/api_helper.dart';
import 'package:trocado_flutter/feature/auth/authentication_provider.dart';

class RegistrationProvider {
  ApiHelper apiHelper = ApiHelper();
  static const REGISTER_URL = "signup";

  Future<dynamic> register(
      BuildContext context, String name, String lastName, String email, String password) async {
    if (name.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty) {
      return false;
    }

    final body = {
      'name': name,
      'last_name': lastName,
      'email': email,
      'password': password,
    };

    var responseJson = await apiHelper.post(context, REGISTER_URL, body: body);
    Provider.of<AuthenticationProvider>(context, listen: false).saveLogin(responseJson);
    return responseJson;
  }
}
