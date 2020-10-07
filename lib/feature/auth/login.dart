import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trocado_flutter/config/base_theme.dart';
import 'package:trocado_flutter/widget/standard_button.dart';

import 'login_service.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  FocusNode focusPassword = FocusNode();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.primaryColor,
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ListView(
                children: [
                  TextField(
                    decoration: InputDecoration(hintText: "Email"),
                    textInputAction: TextInputAction.next,
                    controller: emailController,
                    onSubmitted: (v) => FocusScope.of(context).requestFocus(focusPassword),
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: "Senha", fillColor: Style.primaryColorDark),
                    textInputAction: TextInputAction.send,
                    obscureText: true,
                    controller: passwordController,
                    focusNode: focusPassword,
                    onSubmitted: (v) => login(),
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                  StandardButton(
                      "Entrar",
                      login,
                      Style.primaryColorDark,
                      Style.clearWhite
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void login(){
    String email = emailController.text;
    String password = passwordController.text;

    LoginService loginService = new LoginService();
    print("Fazendo login");
    loginService.login(email, password).then(print).catchError(print);
    print("Fim do login");
  }
}
