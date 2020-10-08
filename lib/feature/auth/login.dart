import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trocado_flutter/config/style.dart';
import 'package:trocado_flutter/widget/standard_button.dart';

import 'login_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FocusNode focusPassword = FocusNode();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.clearWhite,
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ListView(
                children: [
                  Image.asset("assets/recycling.png", height: 160, fit: BoxFit.fitHeight),
                  TextField(
                    decoration: InputDecoration(hintText: "Email"),
                    textInputAction: TextInputAction.next,
                    controller: emailController,
                    onSubmitted: (v) =>
                        FocusScope.of(context).requestFocus(focusPassword),
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: "Senha"),
                    textInputAction: TextInputAction.send,
                    obscureText: true,
                    controller: passwordController,
                    focusNode: focusPassword,
                    onSubmitted: (v) => login(),
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                  StandardButton("Entrar", login, Style.primaryColorDark,
                      Style.clearWhite),
                  Padding(padding: EdgeInsets.symmetric(vertical: 4)),
                  Center(
                    child: GestureDetector(
                      child: Text("Nao tem conta? Crie uma agora!",
                          style: TextStyle(
                              decoration: TextDecoration.underline)),
                      onTap: (){
                        Navigator.of(context).pushReplacementNamed("/registration");
                      }
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void login() {
    String email = emailController.text;
    String password = passwordController.text;

    LoginService loginService = new LoginService();
    print("Fazendo login");
    loginService.login(email, password).then(print).catchError(print);
    print("Fim do login");
  }
}
