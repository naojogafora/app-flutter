import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trocado_flutter/config/style.dart';
import 'package:trocado_flutter/feature/auth/authentication_provider.dart';
import 'package:trocado_flutter/feature/auth/password_reset_screen.dart';
import 'package:trocado_flutter/widget/standard_button.dart';

class AuthenticationScreen extends StatefulWidget {
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
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
                    onSubmitted: (v) => FocusScope.of(context).requestFocus(focusPassword),
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: "Senha"),
                    textInputAction: TextInputAction.send,
                    obscureText: true,
                    controller: passwordController,
                    focusNode: focusPassword,
                    onSubmitted: (v) => login(),
                  ),
                  const Divider(
                    height: 6
                  ),
                  GestureDetector(
                    child: Align(
                      child: Text(
                        "Esqueci a senha",
                        style: TextStyle(
                            color: Style.primaryColorDark, decoration: TextDecoration.underline,),
                      ),
                      alignment: Alignment.centerRight,
                    ),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PasswordResetScreen())),
                  ),
                  const Divider(height: 6),
                  StandardButton("Entrar", login, Style.primaryColorDark, Style.clearWhite),
                  const Divider(height: 6),
                  Center(
                    child: GestureDetector(
                        child: Text("Nao tem conta? Crie uma agora!",
                            style: TextStyle(decoration: TextDecoration.underline)),
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed("/registration");
                        }),
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

    Provider.of<AuthenticationProvider>(context, listen: false)
        .login(context, email, password)
        .then((bool success) {
      if (success) {
        Navigator.of(context).pop();
      }
    }).catchError(print);
  }
}
